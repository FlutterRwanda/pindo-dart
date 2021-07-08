import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import './pindo_errors.dart';

/// A Dart API client for pindo.io. Check www.pindo.io for more info.
class PindoClient {
  PindoClient({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  @visibleForTesting
  static const authority = 'api.pindo.io';

  /// Get the user's token from their pindo account.
  Future<String> getToken({
    required String username,
    required String password,
  }) async {
    final uri = Uri.https(authority, '/users/token');
    final auth = 'Basic ${base64Encode(utf8.encode("$username:$password"))}';
    _dio.options.headers['authorization'] = auth;
    late Response<Map<String, dynamic>> res;
    Map data;

    try {
      res = await _dio.getUri(uri);
      data = res.data as Map<String, dynamic>;
    } on DioError catch (e, s) {
      throw PindoError(
        message: (e.response?.data as Map)['message'],
        statusCode: (e.response?.data as Map)['status'] ?? res.statusCode,
        type: e.type.valueToString,
        stackTrace: s,
      );
    } on TypeError {
      throw PindoCastingError();
    } on Exception {
      // If the exception is none of the two above, just rethrow it
      rethrow;
    }

    if (data.containsKey('token')) {
      return data['token'];
    }

    throw PindoUnexpectedResponseError(expected: 'token', received: data);
  }

  /// Refresh the user's token
  /// returns the newly generated token
  Future<String> refreshToken({
    required String username,
    required String password,
  }) async {
    final uri = Uri.https(authority, '/users/refresh/token');
    final auth = 'Basic ${base64Encode(utf8.encode("$username:$password"))}';
    _dio.options.headers['authorization'] = auth;
    late Response<Map<String, dynamic>> res;
    Map data;

    try {
      res = await _dio.getUri(uri);
      data = res.data as Map<String, dynamic>;
    } on DioError catch (e, s) {
      throw PindoError(
        message: (e.response?.data as Map)['message'],
        statusCode: (e.response?.data as Map)['status'] ?? res.statusCode,
        type: e.type.valueToString,
        stackTrace: s,
      );
    } on TypeError {
      throw PindoCastingError();
    } on Exception {
      // If the exception is none of the two above, just rethrow it
      rethrow;
    }

    if (data.containsKey('token')) {
      return data['token'];
    }
    throw PindoUnexpectedResponseError(expected: 'token', received: data);
  }

  /// Create a new Pindo account
  /// Returns the url to the user's profile
  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final uri = Uri.https(authority, '/users/register');
    final payload = {
      'username': username,
      'email': email,
      'password': password
    };
    late Response<Map<String, dynamic>> res;
    try {
      res = await _dio.postUri(uri, data: payload);
    } on DioError catch (e, s) {
      throw PindoError(
        message: (e.response?.data as Map)['message'],
        statusCode: (e.response?.data as Map)['status'] ?? res.statusCode,
        type: e.type.valueToString,
        stackTrace: s,
      );
    } on TypeError {
      throw PindoCastingError();
    } on Exception {
      // If the exception is none of the two above, just rethrow it
      rethrow;
    }
  }

  /// Check your balance
  Future<double> balance({required String token}) async {
    final uri = Uri.https(authority, '/wallets/self');
    _dio.options.headers = {'Authorization': 'Bearer $token'};

    late Response<Map<String, dynamic>> res;
    var data = {};
    try {
      res = await _dio.getUri(uri);
      data = res.data as Map<String, dynamic>;
    } on DioError catch (e, s) {
      throw PindoError(
        message: (e.response?.data as Map)['message'],
        statusCode: (e.response?.data as Map)['status'] ?? res.statusCode,
        type: e.type.valueToString,
        stackTrace: s,
      );
    } on TypeError {
      throw PindoCastingError();
    } on Exception {
      // If the exception is none of the two above, just rethrow it
      rethrow;
    }

    if (data.containsKey('amount')) {
      return data['amount'];
    }
    throw PindoUnexpectedResponseError(expected: 'amount', received: data);
  }

  /// Send an SMS to a single user
  /// retutns the remaining balance after the sms is sent
  Future<double> sendSMS({
    required String token,
    required String to,
    required String from,
    required String text,
  }) async {
    final uri = Uri.https(authority, '/v1/sms/');
    final payload = {'to': to, 'text': text, 'sender': from};
    _dio.options.headers = {'Authorization': 'Bearer $token'};
    late Response<Map<String, dynamic>> res;
    Map data;

    try {
      res = await _dio.postUri(uri, data: payload);
      data = res.data as Map<String, dynamic>;
    } on DioError catch (e, s) {
      throw PindoError(
        message: (e.response?.data as Map)['message'],
        statusCode: (e.response?.data as Map)['status'] ?? res.statusCode,
        type: e.type.valueToString,
        stackTrace: s,
      );
    } on TypeError {
      throw PindoCastingError();
    } on Exception {
      rethrow;
    }

    if (data.containsKey('remaining_balance')) {
      return data['remaining_balance'];
    }
    throw PindoUnexpectedResponseError(
      expected: 'remaining_balance',
      received: data,
    );
  }

  /// Setup an organization.
  /// Returns the url to the organization
  Future<String> organization({
    required String token,
    required String name,
    required String webHookURL,
    required int retriesCount,
  }) async {
    final uri = Uri.https(authority, '/orgs/self');
    final payload = {
      'name': name,
      'webhook_url': webHookURL,
      'sms_retries': retriesCount
    };

    _dio.options.headers = {'Authorization': 'Bearer $token'};
    late Response<Map<String, dynamic>> res;
    var data = {};

    try {
      res = await _dio.putUri(uri, data: payload);
      data = res.data!;
    } on DioError catch (e, s) {
      throw PindoError(
        message: (e.response?.data as Map)['message'],
        statusCode: (e.response?.data as Map)['status'] ?? res.statusCode,
        type: e.type.valueToString,
        stackTrace: s,
      );
    } on TypeError {
      throw PindoCastingError();
    } on Exception {
      rethrow;
    }

    if (data.containsKey('self_url')) {
      return data['self_url'];
    }
    throw PindoUnexpectedResponseError(expected: 'self_url', received: data);
  }
}

/// An extension to add additional operations to [DioErrorType];
/// check https://github.com/flutterchina/dio/blob/master/dio/lib/src/dio_error.dart
/// to see all the values of [DioErrorType].
extension DioErrorTypeExtension on DioErrorType {
  /// Gets the value [DioErrorType] in a string format without the prefix.
  String get valueToString => toString().substring(13);
}
