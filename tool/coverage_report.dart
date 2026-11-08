// Merges each package's coverage/lcov.info into coverage/lcov.info at the
// repository root, drops generated code (*.g.dart, *.freezed.dart), prints a
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

  final packages =
      Directory('packages')
          .listSync()
          .whereType<Directory>()
          .where((d) => File('${d.path}/coverage/lcov.info').existsSync())
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  if (packages.isEmpty) {
    stderr.writeln('No coverage found. Run `melos run coverage` first.');
    exit(2);
  }

  final merged = <_FileCoverage>[];
  var totalLines = 0;
  var totalCovered = 0;

  for (final dir in packages) {
    final name = dir.uri.pathSegments.where((s) => s.isNotEmpty).last;
    final files = _parse(
      File('${dir.path}/coverage/lcov.info'),
      'packages/$name',
    ).where((f) => !_generated.hasMatch(f.path)).toList();
    _warnAboutUnloadedFiles(dir, name, files);
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
void _warnAboutUnloadedFiles(
  Directory package,
  String name,
  List<_FileCoverage> reported,
) {
  final reportedPaths = reported.map((f) => f.path).toSet();
  final libDir = Directory('${package.path}/lib');
  final missing =
      libDir
          .listSync(recursive: true)
          .whereType<File>()
          .map((f) => f.path.replaceAll(r'\', '/'))
          .where((p) => p.endsWith('.dart') && !_generated.hasMatch(p))
          .map((p) => 'packages/$name/${p.substring(p.indexOf('lib/'))}')
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
      final libIndex = source.lastIndexOf('lib/');
      final relative = libIndex >= 0 ? source.substring(libIndex) : source;
      current = _FileCoverage('$packagePath/$relative');
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

String _pct(int covered, int total) =>
    total == 0 ? '100.0%' : '${(covered / total * 100).toStringAsFixed(1)}%';
