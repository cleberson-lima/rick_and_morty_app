import 'package:core/types.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result.guard', () {
    test('wraps the value in Success', () async {
      final result = await Result.guard(
        () async => 42,
        toFailure: (_) => const Failure.unexpected(),
      );

      expect(result, const Success(42));
    });

    test('turns an exception into Failed with the mapped failure', () async {
      final result = await Result.guard<int>(
        () async => throw StateError('boom'),
        toFailure: (error) => error is StateError
            ? const Failure.cache()
            : const Failure.unexpected(),
      );

      expect(result, const Failed<int>(Failure.cache()));
    });
  });

  test('Success compares by data', () {
    expect(const Success(1), const Success(1));
    expect(const Success(1), isNot(const Success(2)));
    expect(const Success(1).hashCode, const Success(1).hashCode);
    expect(const Success(1).toString(), 'Success(1)');
  });

  test('Failed compares by failure, whatever its type argument', () {
    expect(
      const Failed<String>(Failure.network()),
      const Failed<Never>(Failure.network()),
    );
    expect(
      const Failed<String>(Failure.network()),
      isNot(const Failed<String>(Failure.cache())),
    );
    expect(
      const Failed<int>(Failure.network()).hashCode,
      const Failed<String>(Failure.network()).hashCode,
    );
    expect(const Failed<int>(Failure.cache()).toString(), contains('Failed('));
  });

  test('a switch handles both cases', () {
    String describe(Result<int> result) => switch (result) {
      Success(:final data) => 'ok $data',
      Failed(:final failure) => 'failed $failure',
    };

    expect(describe(const Success(1)), 'ok 1');
    expect(describe(const Failed(Failure.cache())), startsWith('failed'));
  });
}
