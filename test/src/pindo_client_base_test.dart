import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pindo_client/pindo_client.dart';
import 'package:pindo_client/src/pindo_client_base.dart';
import 'package:test/test.dart';

class MockDio extends Mock implements Dio {
  MockDio([BaseOptions? options]) : _options = options ?? BaseOptions();
  final BaseOptions _options;
  @override
  BaseOptions get options => _options;
}

void main() {
  late Dio dio;
  late PindoClient subject;

  group('PindoClient', () {
    setUp(() {
      dio = MockDio();
      subject = PindoClient(dio: dio);
    });

    setUpAll(() {
      registerFallbackValue<Uri>(Uri());
    });

    test('returns constructor normally', () {
      expect(() => PindoClient(), returnsNormally);
    });

// PindoClient -> getToken
    group('getToken', () {
      const path = '/users/token';
      const token = 'i-am-a-token';
      const username = 'password'; // Don't do this at home
      const password = 'password'; // Don't do this at home
      final uri = Uri.https(PindoClient.authority, path);
      final reqOptions = RequestOptions(
        path: path,
        baseUrl: PindoClient.authority,
      );
      setUp(() {
        when(() => dio.getUri(any())).thenAnswer(
          (_) async => Response<Map<String, dynamic>>(
            data: {'token': token},
            statusCode: 200,
            requestOptions: reqOptions,
          ),
        );
      });

      test('calls dio.getUri', () async {
        await subject.getToken(username: username, password: password);
        verify(() => dio.getUri(uri)).called(1);
      });

      test('throws a PindoError when a DioError is thrown by dio', () {
        when(() => dio.getUri(any())).thenThrow(
          DioError(
              response: Response(
                requestOptions: reqOptions,
                data: {'message': 'not found', 'status': 404},
              ),
              requestOptions: reqOptions),
        );
        expect(
          () => subject.getToken(username: username, password: password),
          throwsA(isA<PindoError>()),
        );
      });

      test('throws PindoCastingError when the response is not a Map', () {
        when(() => dio.getUri(any())).thenAnswer(
          (_) async => Response(
            data: [],
            statusCode: 200,
            requestOptions: reqOptions,
          ),
        );
        expect(
          () => subject.getToken(username: username, password: password),
          throwsA(isA<PindoCastingError>()),
        );
      });

      test('rethrows an Exception when it\'s none of the above', () {
        when(() => dio.getUri(uri)).thenThrow(Exception());
        expect(
          () => subject.getToken(username: username, password: password),
          throwsA(isA<Exception>()),
        );
      });

      test(
          'throws PindoUnexpectedResponseError when the token is not '
          'found in the response body', () {
        when(() => dio.getUri(any())).thenAnswer(
          (_) async => Response<Map<String, dynamic>>(
            requestOptions: reqOptions,
            data: {'not-token': 'i am a token bro, trust me🤫️'},
          ),
        );
        expect(
          () => subject.getToken(username: username, password: password),
          throwsA(isA<PindoUnexpectedResponseError>()),
        );
      });
    });

// PIndoClient -> refreshToken
    group('refreshToken', () {
      const path = '/users/refresh/token';
      const token = 'token';
      const username = 'password'; // Don't do this at home
      const password = 'password'; // Don't do this at home
      final uri = Uri.https(PindoClient.authority, path);
      final reqOptions = RequestOptions(
        path: path,
        baseUrl: PindoClient.authority,
      );
      setUp(() {
        when(() => dio.getUri(any())).thenAnswer(
          (_) async => Response<Map<String, dynamic>>(
            data: {'token': token},
            statusCode: 200,
            requestOptions: reqOptions,
          ),
        );
      });

      test('calls dio.getUri', () async {
        await subject.refreshToken(username: username, password: password);
        verify(() => dio.getUri(uri)).called(1);
      });

      test('throws a PindoError when a DioError is thrown by dio', () {
        when(() => dio.getUri(any())).thenThrow(
          DioError(
              response: Response(
                requestOptions: reqOptions,
                data: {'message': 'not found', 'status': 404},
              ),
              requestOptions: reqOptions),
        );
        expect(
          () => subject.refreshToken(username: username, password: password),
          throwsA(isA<PindoError>()),
        );
      });

      test('throws PindoCastingError when the response is not a Map', () {
        when(() => dio.getUri(any())).thenAnswer(
          (_) async => Response(
            data: [],
            statusCode: 200,
            requestOptions: reqOptions,
          ),
        );
        expect(
          () => subject.refreshToken(username: username, password: password),
          throwsA(isA<PindoCastingError>()),
        );
      });

      test('rethrows an Exception when it\'s none of the above', () {
        when(() => dio.getUri(uri)).thenThrow(Exception());
        expect(
          () => subject.refreshToken(username: username, password: password),
          throwsA(isA<Exception>()),
        );
      });

      test(
          'throws PindoUnexpectedResponseError when the token is not '
          'found in the response body', () {
        when(() => dio.getUri(any())).thenAnswer(
          (_) async => Response<Map<String, dynamic>>(
            requestOptions: reqOptions,
            data: {'not-token': 'i am a token bro, trust me🤫️'},
          ),
        );
        expect(
          () => subject.refreshToken(username: username, password: password),
          throwsA(isA<PindoUnexpectedResponseError>()),
        );
      });
    });

// PindoClient -> register
    group('register', () {
      const path = '/users/register';
      const profileURL = 'https://pindo.io/awesome-tester';
      const username = 'password';
      const password = 'password';
      const email = 'pindo@test.com';
      final reqOptions = RequestOptions(
        path: path,
        baseUrl: PindoClient.authority,
      );
      setUp(() {
        when(() => dio.postUri(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response<Map<String, dynamic>>(
            data: {'self_url': profileURL},
            statusCode: 200,
            requestOptions: reqOptions,
          ),
        );
      });
      test('calls dio.postUri', () async {
        await subject.register(
          username: username,
          email: email,
          password: password,
        );
        verify(
          () => dio.postUri(Uri.https(PindoClient.authority, path),
              data: any(named: 'data')),
        ).called(1);
      });

      test('throws a PindoError when a DioError is thrown by dio', () {
        when(() => dio.postUri(any(), data: any(named: 'data'))).thenThrow(
          DioError(
              response: Response(
                statusCode: 404,
                requestOptions: reqOptions,
                data: {'message': 'not found', 'status': 404},
              ),
              requestOptions: reqOptions),
        );
        expect(
          () => subject.register(
            username: username,
            email: email,
            password: password,
          ),
          throwsA(isA<PindoError>()),
        );
      });

      test('throws PindoCastingError when the response is not a Map', () {
        when(() => dio.postUri(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response(
            data: [],
            statusCode: 200,
            requestOptions: reqOptions,
          ),
        );
        expect(
          () => subject.register(
            username: username,
            email: email,
            password: password,
          ),
          throwsA(isA<PindoCastingError>()),
        );
      });

      test('rethrows an Exception when it\'s none of the above', () {
        when(() => dio.postUri(any(), data: any(named: 'data')))
            .thenThrow(Exception());
        expect(
          () => subject.register(
            username: username,
            email: email,
            password: password,
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

// PindoClient -> balance
    group('balance', () {
      const token = 'token';
      const balance = 0.53;
      const path = '/wallets/self';
      final reqOptions = RequestOptions(
        path: path,
        baseUrl: PindoClient.authority,
      );
      const headers = {'Authorization': 'Bearer $token'};

      setUp(() {
        dio.options.headers = headers;
        when(
          () => dio.getUri(any(), options: any(named: 'options')),
        ).thenAnswer(
          (_) async => Response<Map<String, dynamic>>(
            data: {'amount': balance},
            statusCode: 200,
            requestOptions: reqOptions,
          ),
        );
      });
      test('calls dio.getUri', () async {
        await subject.balance(token: token);
        dio.options.headers['Authorization'] = 'Bearer $token';
        verify(
          () => dio.getUri(
            Uri.https(PindoClient.authority, path),
          ),
        ).called(1);
      });

      test('throws a PindoError when a DioError is thrown by dio', () {
        when(() => dio.getUri(any())).thenThrow(
          DioError(
            response: Response(
              requestOptions: reqOptions,
              data: {'message': 'not found', 'status': 404},
            ),
            requestOptions: reqOptions,
          ),
        );
        expect(
          () => subject.balance(token: token),
          throwsA(isA<PindoError>()),
        );
      });

      test('throws PindoCastingError when the response is not a Map', () {
        when(() => dio.getUri(any())).thenAnswer(
          (_) async => Response(
            data: [],
            statusCode: 200,
            requestOptions: reqOptions,
          ),
        );
        expect(
          () => subject.balance(token: token),
          throwsA(isA<PindoCastingError>()),
        );
      });
      test('rethrows an Exception when it\'s none of the above', () {
        when(() => dio.getUri(any())).thenThrow(Exception());
        expect(() => subject.balance(token: token), throwsA(isA<Exception>()));
      });
      test(
          'throws PindoUnexpectedResponseError when the amount is not '
          'found in the response body', () {
        when(() => dio.getUri(any())).thenAnswer(
          (_) async => Response<Map<String, dynamic>>(
            requestOptions: reqOptions,
            data: {'not-amount': 'i am amount bro, trust me🤫️'},
          ),
        );
        expect(
          () => subject.balance(token: token),
          throwsA(isA<PindoUnexpectedResponseError>()),
        );
      });
    });

// PindoClient -> sendSMS
    group('sendSMS', () {
      const path = 'v1/sms/';
      const token = 'token';
      const text = 'pindo is awesome';
      const from = 'Pindo';
      const to = '+250789159557';
      const balance = 0.45;
      final reqOptions = RequestOptions(
        path: path,
        baseUrl: PindoClient.authority,
      );
      final payload = {
        'to': to,
        'sender': from,
        'text': text,
      };
      setUp(() {
        dio.options.headers['Authorization'] = 'Bearer $token';
        when(() => dio.postUri(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response<Map<String, dynamic>>(
            statusCode: 200,
            data: {'remaining_balance': balance},
            requestOptions: RequestOptions(
              path: path,
              baseUrl: PindoClient.authority,
            ),
          ),
        );
      });

      test('calls dio.postUri', () async {
        await subject.sendSMS(
          token: token,
          from: from,
          to: to,
          text: text,
        );
        dio.options.headers['Authorization'] = 'Bearer $token';
        verify(
          () => dio.postUri(
            Uri.https(PindoClient.authority, path),
            data: payload,
          ),
        ).called(1);
      });

      test('throws PindoError a DioError is thrown', () {
        when(
          () => dio.postUri(any(), data: any(named: 'data')),
        ).thenThrow(DioError(
          response: Response(
            statusCode: 404,
            requestOptions: reqOptions,
            data: {'message': 'not found', 'status': 404},
          ),
          requestOptions: reqOptions,
        ));
        expect(
          () => subject.sendSMS(
            token: token,
            from: from,
            to: to,
            text: text,
          ),
          throwsA(isA<PindoError>()),
        );
      });

      test('rethrows an Exception when it\'s none of the above', () {
        when(() => dio.postUri(any(), data: any(named: 'data'))).thenThrow(
          Exception(),
        );
        expect(
          () => subject.sendSMS(token: token, to: to, from: from, text: text),
          throwsA(isA<Exception>()),
        );
      });

      test('throws PindoCastingError when the response is not a Map', () {
        when(() => dio.postUri(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response(
            data: [],
            statusCode: 200,
            requestOptions: reqOptions,
          ),
        );
        expect(
          () => subject.sendSMS(token: token, to: to, from: from, text: text),
          throwsA(isA<PindoCastingError>()),
        );
      });

      test(
          'throws PindoUnexpectedResponseError when the '
          'remaining_balance is not found in the response body', () {
        when(() => dio.postUri(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response<Map<String, dynamic>>(
            requestOptions: reqOptions,
            data: {'not-remaining-balance': 'i your balance bro, trust me🤫️'},
          ),
        );
        expect(
          () => subject.sendSMS(token: token, to: to, from: from, text: text),
          throwsA(isA<PindoUnexpectedResponseError>()),
        );
      });
    });

// PindoClient -> organization
    group('organization', () {
      const token = 'token';
      const name = 'awesomest organization in the world';
      const webHookURL = 'https://example.com/awesomest-org';
      const path = '/orgs/self';
      const retriesCount = 7;
      final reqOptions = RequestOptions(
        path: path,
        baseUrl: PindoClient.authority,
      );
      final payload = {
        'name': name,
        'webhook_url': webHookURL,
        'sms_retries': retriesCount
      };

      setUp(() {
        dio.options.headers['Authorization'] = 'Bearer $token';
        when(() => dio.putUri(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response<Map<String, dynamic>>(
            statusCode: 200,
            data: {'self_url': 'https://pindo.io'},
            requestOptions: reqOptions,
          ),
        );
      });
      test('calls dio.putUri', () async {
        await subject.organization(
          token: token,
          name: name,
          webHookURL: webHookURL,
          retriesCount: retriesCount,
        );
        dio.options.headers['Authorization'] = 'Bearer $token';
        verify(
          () => dio.putUri(
            Uri.https(PindoClient.authority, path),
            data: payload,
          ),
        ).called(1);
      });
      test('throws PindoError when DioError is thrown', () {
        when(
          () => dio.putUri(any(), data: any(named: 'data')),
        ).thenThrow(DioError(
          response: Response(
            statusCode: 404,
            requestOptions: reqOptions,
            data: {'message': 'not found', 'status': 404},
          ),
          requestOptions: reqOptions,
        ));
        expect(
          () => subject.organization(
            token: token,
            name: name,
            webHookURL: webHookURL,
            retriesCount: retriesCount,
          ),
          throwsA(isA<PindoError>()),
        );
      });

      test('throws PindoCastingError when the response is not a Map', () {
        when(() => dio.putUri(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response(
            data: [],
            statusCode: 200,
            requestOptions: reqOptions,
          ),
        );
        expect(
          () => subject.organization(
            token: token,
            name: name,
            webHookURL: webHookURL,
            retriesCount: retriesCount,
          ),
          throwsA(isA<PindoCastingError>()),
        );
      });
      test('rethrows an exception that occurs and is not onw of two above', () {
        when(() => dio.putUri(any(), data: any(named: 'data'))).thenThrow(
          Exception(),
        );
        expect(
          () => subject.organization(
              token: token,
              name: name,
              webHookURL: webHookURL,
              retriesCount: retriesCount),
          throwsA(isA<Exception>()),
        );
      });

      test(
          'throws PindoUnexpectedResponseError when the '
          'self_url is not found in the response body', () {
        when(() => dio.putUri(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response<Map<String, dynamic>>(
            requestOptions: reqOptions,
            data: {'not_self_url': 'i am self_url bro, trust me🤫️'},
          ),
        );
        expect(
          () => subject.organization(
            token: token,
            name: name,
            webHookURL: webHookURL,
            retriesCount: retriesCount,
          ),
          throwsA(isA<PindoUnexpectedResponseError>()),
        );
      });
    });
  });

// PindoClient -> forgotPassword
  group('forgotPassword', () {
    const path = '/users/forgot';
    const email = 'pindo@test.com';
    final reqOptions = RequestOptions(
      path: path,
      baseUrl: PindoClient.authority,
    );
    setUp(() {
      when(() => dio.postUri(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          data: {'message': 'A recovery link has been sent via email'},
          statusCode: 200,
          requestOptions: reqOptions,
        ),
      );
    });
    test('calls dio.postUri', () async {
      await subject.forgotPassword(email: email);
      verify(
        () => dio.postUri(Uri.https(PindoClient.authority, path),
            data: any(named: 'data')),
      ).called(1);
    });

    test('throws a PindoError when a DioError is thrown by dio', () {
      when(() => dio.postUri(any(), data: any(named: 'data'))).thenThrow(
        DioError(
            response: Response(
              statusCode: 404,
              requestOptions: reqOptions,
              data: {'message': 'not found', 'status': 404},
            ),
            requestOptions: reqOptions),
      );
      expect(
        () => subject.forgotPassword(email: email),
        throwsA(isA<PindoError>()),
      );
    });

    test('throws PindoCastingError when the response is not a Map', () {
      when(() => dio.postUri(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          data: [],
          statusCode: 200,
          requestOptions: reqOptions,
        ),
      );
      expect(
        () => subject.forgotPassword(email: email),
        throwsA(isA<PindoCastingError>()),
      );
    });

    test('rethrows an Exception when it\'s none of the above', () {
      when(() => dio.postUri(any(), data: any(named: 'data')))
          .thenThrow(Exception());
      expect(
        () => subject.forgotPassword(email: email),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('DioErrorTypeExtension', () {
    const value = DioErrorType.response;

    test('returns the value of DioErroType as a string without the prefix', () {
      expect(value.valueToString, equals('response'));
    });
  });
}
