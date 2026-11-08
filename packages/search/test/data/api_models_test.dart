import 'package:flutter_test/flutter_test.dart';
import 'package:search/src/data/models/api_models.dart';

void main() {
  test('idFromResourceUrl reads the trailing id', () {
    expect(idFromResourceUrl('https://rickandmortyapi.com/api/location/3'), 3);
    expect(idFromResourceUrl('https://rickandmortyapi.com/api/location/3/'), 3);
    expect(idFromResourceUrl(''), isNull, reason: 'unknown origin');
    expect(idFromResourceUrl(null), isNull);
    expect(idFromResourceUrl('https://x.test/api/location/abc'), isNull);
  });
}
