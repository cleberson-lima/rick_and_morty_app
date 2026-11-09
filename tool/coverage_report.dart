// Merges each package's coverage/lcov.info and the app's coverage/app.lcov.info
// (tests of the repository root) into coverage/lcov.info at the root, drops generated code (*.g.dart, *.freezed.dart), prints a
// per-package and per-file summary and, with --min=<percent>, exits 1 when the
// total line coverage is below the threshold.
//
// Usage (after `melos run coverage` has produced the per-package files):
//   dart run tool/coverage_report.dart [--min=80] [--files]
import 'dart:io';

final _generated = RegExp(r'\.(g|freezed)\.dart$');

class _FileCoverage {
  _FileCoverage(this.path);

  final String path;
  final Map<int, int> hits = {};

  int get lines => hits.length;
  int get covered => hits.values.where((h) => h > 0).length;
}

void main(List<String> args) {
  final min = args
      .where((a) => a.startsWith('--min='))
      .map((a) => double.parse(a.substring('--min='.length)))
      .firstOrNull;
  final showFiles = args.contains('--files');

  final packageDirs =
      Directory('packages')
          .listSync()
          .whereType<Directory>()
          .where((d) => File('${d.path}/coverage/lcov.info').existsSync())
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));
  final sources = [
    if (File(_appLcov).existsSync()) const _Source('app', '.', _appLcov),
    for (final dir in packageDirs)
      _Source(
        dir.uri.pathSegments.where((s) => s.isNotEmpty).last,
        'packages/${dir.uri.pathSegments.where((s) => s.isNotEmpty).last}',
        '${dir.path}/coverage/lcov.info',
      ),
  ];

  if (sources.isEmpty) {
    stderr.writeln('No coverage found. Run `melos run coverage` first.');
    exit(2);
  }

  final merged = <_FileCoverage>[];
  var totalLines = 0;
  var totalCovered = 0;

  for (final source in sources) {
    final name = source.name;
    final files = _parse(
      File(source.lcov),
      source.root,
    ).where((f) => !_generated.hasMatch(f.path)).toList();
    _warnAboutUnloadedFiles(source.root, files);
    final lines = files.fold(0, (sum, f) => sum + f.lines);
    final covered = files.fold(0, (sum, f) => sum + f.covered);
    totalLines += lines;
    totalCovered += covered;
    merged.addAll(files);

    stdout.writeln(
      '${name.padRight(12)} ${_pct(covered, lines).padLeft(7)}  ($covered/$lines)',
    );
    if (showFiles) {
      for (final f in files.where((f) => f.covered < f.lines)) {
        stdout.writeln('    ${_pct(f.covered, f.lines).padLeft(7)}  ${f.path}');
      }
    }
  }

  stdout.writeln(
    '${'TOTAL'.padRight(12)} ${_pct(totalCovered, totalLines).padLeft(7)}  '
    '($totalCovered/$totalLines)',
  );

  Directory('coverage').createSync();
  File('coverage/lcov.info').writeAsStringSync(_toLcov(merged));
  stdout.writeln('Merged report: coverage/lcov.info');

  final percent = totalLines == 0 ? 100 : totalCovered / totalLines * 100;
  if (min != null && percent < min) {
    stderr.writeln(
      'Coverage ${percent.toStringAsFixed(1)}% is below the minimum $min%.',
    );
    exit(1);
  }
}

/// Files that no test imports are absent from lcov.info, so they would
/// silently inflate the percentage. List them so they get a test or an
/// explicit `// coverage:ignore-file`.
void _warnAboutUnloadedFiles(String root, List<_FileCoverage> reported) {
  final reportedPaths = reported.map((f) => f.path).toSet();
  final libDir = Directory('$root/lib');
  final missing =
      libDir
          .listSync(recursive: true)
          .whereType<File>()
          .map((f) => f.path.replaceAll(r'\', '/'))
          .where((p) => p.endsWith('.dart') && !_generated.hasMatch(p))
          .map((p) => _join(root, p.substring(p.indexOf('lib/'))))
          .where((p) => !reportedPaths.contains(p))
          .where((p) => _hasExecutableCode(File(p)))
          .toList()
        ..sort();
  for (final path in missing) {
    stderr.writeln('warning: not loaded by any test: $path');
  }
}

/// Barrels, abstract interfaces and freezed declarations have no executable
/// lines, so lcov never lists them. Only files with a function body
/// (`=>` or `) {`) can hide untested code.
final _functionBody = RegExp(r'=>|\)\s*(async\s*)?\{');

bool _hasExecutableCode(File file) {
  final source = file.readAsStringSync();
  if (source.contains('// coverage:ignore-file')) return false;
  final code = source
      .split('\n')
      .where((l) => !l.trimLeft().startsWith('//'))
      .join('\n');
  return _functionBody.hasMatch(code);
}

/// Reads an lcov file, rewriting source paths relative to the repo root.
List<_FileCoverage> _parse(File lcov, String packagePath) {
  final files = <_FileCoverage>[];
  _FileCoverage? current;
  for (final line in lcov.readAsLinesSync()) {
    if (line.startsWith('SF:')) {
      final source = line.substring(3).replaceAll(r'\', '/');
      // The app's tests also load the packages; those files are counted in
      // the packages' own reports, not as the app's.
      if (packagePath == '.' && source.contains('packages/')) {
        current = null;
        continue;
      }
      final libIndex = source.lastIndexOf('lib/');
      final relative = libIndex >= 0 ? source.substring(libIndex) : source;
      current = _FileCoverage(_join(packagePath, relative));
      files.add(current);
    } else if (line.startsWith('DA:') && current != null) {
      final parts = line.substring(3).split(',');
      final lineNumber = int.parse(parts[0]);
      final hits = int.parse(parts[1]);
      current.hits[lineNumber] = (current.hits[lineNumber] ?? 0) + hits;
    }
  }
  return files;
}

String _toLcov(List<_FileCoverage> files) {
  final buffer = StringBuffer();
  for (final f in files) {
    buffer.writeln('SF:${f.path}');
    final lines = f.hits.keys.toList()..sort();
    for (final line in lines) {
      buffer.writeln('DA:$line,${f.hits[line]}');
    }
    buffer
      ..writeln('LF:${f.lines}')
      ..writeln('LH:${f.covered}')
      ..writeln('end_of_record');
  }
  return buffer.toString();
}

/// lcov written by `flutter test --coverage --coverage-path=...` at the root.
const _appLcov = 'coverage/app.lcov.info';

/// One lcov file and the directory its `lib/` paths are relative to.
class _Source {
  const _Source(this.name, this.root, this.lcov);

  final String name;

  /// `.` for the app at the repository root, `packages/<name>` otherwise.
  final String root;
  final String lcov;
}

String _join(String root, String path) => root == '.' ? path : '$root/$path';

String _pct(int covered, int total) =>
    total == 0 ? '100.0%' : '${(covered / total * 100).toStringAsFixed(1)}%';
