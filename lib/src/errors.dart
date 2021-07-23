import 'package:dio/dio.dart';

/// Thrown when the http request goes wrong; contains the
/// message and the status code. Wraps [DioError]
class PindoError implements Exception {
  const PindoError({this.message, this.statusCode, this.type, this.stackTrace});

  /// Exception's stacktrcae
  final StackTrace? stackTrace;

  /// Http response's body message
  final String? message;

  /// Http response's status code
  final int? statusCode;

  /// Value of the exception's [DioErrorType]
  final String? type;

  @override
  String toString() => 'PindoError $type: $message';
}

/// Thrown when the response body cannot be cast as a [Map]
class PindoCastingError implements Exception {}

/// Thrown when the http response body does not contain what it should.
/// Mostly happens when the endpoint for the expected data has been changed
class PindoUnexpectedResponseError implements Exception {
  const PindoUnexpectedResponseError({
    required this.expected,
    this.received,
  });

  final Object expected;
  final Object? received;

  @override
  String toString() {
    return 'PindoUnexpectedResponseError($expected, ${received.toString()})';
  }
}
