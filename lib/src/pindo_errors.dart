import 'package:dio/dio.dart';

/// Thown when an exception is thrown while making an http request.
/// A wrapper over the [DioError] class
/// Mostly used when [response] does not hold any data
class PindoHttpError implements Exception {
  const PindoHttpError({
    required this.requestOptions,
    this.response,
    this.error,
    this.type,
    this.stackTrace,
  });

  final Response? response;
  final String? type;
  final RequestOptions requestOptions;
  final StackTrace? stackTrace;
  final dynamic error;

  @override
  String toString() => 'PindoHttpError($type, ${error.toString()})';
}

/// Like PindoHttpError but only contains the message and the status code.
/// Used when the response contains some data.
class PindoError implements Exception {
  const PindoError([this.message, this.statusCode]);

  final String? message;
  final int? statusCode;

  @override
  String toString() => 'PindoError($message)';
}

/// Thrown when the response body cannot be hold in a [Map]
class PindoResponseFormatError implements Exception {}

/// Thrown when the http response body does not contain what it should.
/// Mostly happens when the endpoint for the expected data has been changed
class PindoUnexpectedResponseError implements Exception {
  const PindoUnexpectedResponseError({
    required this.expected,
    this.received,
  });

  final String expected;
  final dynamic received;

  @override
  String toString() =>
      'UnexpectedResponseError($expected, ${received.toString()})';
}
