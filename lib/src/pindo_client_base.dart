import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

/// Thown when an exception is thrown while making an http request.
class HttpFailure implements Exception {
  const HttpFailure([this.message]);

  final String? message;

  @override
  String toString() => 'HttpFailure: $message';
}

/// Thrown when a http operation fails
class HttpRequestFailure implements Exception {
  const HttpRequestFailure({required this.statusCode, this.message});

  final int statusCode;
  final String? message;
  @override
  String toString() => 'HttpRequestFailure($statusCode, $message)';
}

/// Thrown when the reponse body cannot be stored in a [Map]
class JSONDecodeException implements Exception {}

/// Thrown when the http response body does not contain the expected data
class ExpectedResultFailure implements Exception {}

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
    final uri = Uri.https(authority, '/users/token')
      ..replace(queryParameters: {'username': username, 'password': password});
    Response res;
    Map data;
    try {
      res = await _dio.getUri(uri);
      data = res.data as Map<String, dynamic>;
    } on TypeError {
      throw JSONDecodeException();
    } on Exception {
      throw const HttpFailure();
    }

    if (data.containsKey('error')) {
      throw HttpRequestFailure(
        statusCode: data['status'],
        message: data['message'],
      );
    }
    if (data.containsKey('token')) {
      return data['token'];
    }

    throw ExpectedResultFailure();
  }

  /// Refresh the user's token
  /// returns the newly generated token
  Future<String> refreshToken({
    required String username,
    required String password,
  }) async {
    final uri = Uri.https(authority, '/users/refresh/token')
      ..replace(queryParameters: {'username': username, 'password': password});

    Response res;
    Map data;
    try {
      res = await _dio.getUri(uri);
      data = res.data as Map<String, dynamic>;
    } on TypeError {
      throw JSONDecodeException();
    } on Exception catch (e) {
      throw HttpFailure(e.toString());
    }
    if (data.containsKey('error')) {
      throw HttpRequestFailure(
        statusCode: data['status'],
        message: data['message'],
      );
    }
    if (data.containsKey('token')) {
      return data['token'];
    }
    throw ExpectedResultFailure();
  }

  /// Create a new Pindo account
  /// Returns the url to the user's profile
  Future<String> register({
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

    Response res;
    var data = {};
    try {
      res = await _dio.postUri(uri, data: payload);
      data = res.data as Map<String, dynamic>;
    } on TypeError {
      throw JSONDecodeException();
    } on Exception catch (e) {
      throw HttpFailure(e.toString());
    }

    if (data.containsKey('error')) {
      throw HttpRequestFailure(
        message: data['message'],
        statusCode: data['status'],
      );
    }

    if (data.containsKey('self_url')) {
      return data['self_url'];
    }
    throw ExpectedResultFailure();
  }

  /// Check your balance
  Future<double> balance({required String token}) async {
    final uri = Uri.https(authority, '/wallets/self');
    _dio.options.headers = {'Authorization': 'Bearer $token'};

    Response res;
    Map data;
    try {
      res = await _dio.getUri(uri);
      data = res.data;
    } on TypeError {
      throw JSONDecodeException();
    } on Exception catch (e) {
      throw HttpFailure(e.toString());
    }

    if (data.containsKey('error')) {
      throw HttpRequestFailure(
        statusCode: data['status'],
        message: data['message'],
      );
    }
    if (data.containsKey('amount')) {
      return data['amount'];
    }
    throw ExpectedResultFailure();
  }

  /// Send an SMS to a single user
  Future<String> sendSMS({
    required String token,
    required String to,
    required String from,
    required String text,
  }) async {
    final uri = Uri.https(authority, '/v1/sms/');
    final payload = {'to': to, 'text': text, 'sender': from};
    _dio.options.headers = {'Authorization': 'Bearer $token'};
    Response res;
    Map data;
    try {
      res = await _dio.postUri(uri, data: payload);
      data = res.data as Map<String, dynamic>;
    } on TypeError {
      throw JSONDecodeException();
    } on Exception catch (e) {
      throw HttpFailure(e.toString());
    }

    if (data.containsKey('error')) {
      throw HttpRequestFailure(
        statusCode: (res.data as Map)['status'],
        message: (res.data as Map)['message'],
      );
    }
    if (data.containsKey('status') && data['status'] == 'sent') {
      return data['status'];
    }
    throw ExpectedResultFailure();
  }

  /// Setup an organization.
  /// Returns the url to the organization
  Future<Map<String, dynamic>> organization({
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
    Response<Map<String, dynamic>> res;
    var data = {};

    try {
      res = await _dio.putUri(uri, data: payload);
      data = res.data!;
    } on TypeError {
      throw JSONDecodeException();
    } on Exception catch (e) {
      throw HttpFailure(e.toString());
    }

    if (data.containsKey('error')) {
      throw HttpRequestFailure(
        statusCode: data['status'],
        message: data['message'],
      );
    }

    if (data.containsKey('self_url')) {
      return data as Map<String, dynamic>;
    }
    throw ExpectedResultFailure();
  }
}
