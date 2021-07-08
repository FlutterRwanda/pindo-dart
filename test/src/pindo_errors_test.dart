import 'package:pindo_client/src/pindo_errors.dart';
import 'package:test/test.dart';

void main() {
  group('PindoError', () {
    test('has concise toString', () {
      expect(
        const PindoError(message: 'Failed', type: 'response').toString(),
        equals('PindoError response: Failed'),
      );
    });
  });

  group('PindoUnexpectedResponseError', () {
    test('has concise toString', () {
      expect(
        const PindoUnexpectedResponseError(
            expected: 'token', received: {'not-token': 'not'}).toString(),
        equals(
          'PindoUnexpectedResponseError(token, {not-token: not})',
        ),
      );
    });
  });
}
