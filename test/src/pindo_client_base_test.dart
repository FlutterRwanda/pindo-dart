// import 'package:dio/dio.dart';
// import 'package:pindo_client/src/pindo_client_base.dart';
// import 'package:test/test.dart';
// import 'package:mocktail/mocktail.dart';

// class MockDio extends Mock implements Dio {
//   MockDio([BaseOptions? options]) : _options = options ?? BaseOptions();
//   final BaseOptions _options;
//   @override
//   BaseOptions get options => _options;
// }

// void main() {
//   group('PindoClient', () {
//     late Dio dio;
//     late PindoClient subject;
//     const token = 'test-token';
//     const profileURL = 'https://github.com/silverhairs';
//     const balance = 0.50;
//     const username = 'silverhairs';
//     const password = 'password';
//     const email = 'mail@me.com';
//     final phoneNumbers = List.generate(2, (i) => '+25078915955$i');

//     setUp(() {
//       dio = MockDio();
//       subject = PindoClient(dio: dio);
//     });

//     setUpAll(() {
//       registerFallbackValue<Uri>(Uri());
//     });

//     test('returns constructor normally', () {
//       expect(() => PindoClient(), returnsNormally);
//     });

//     // PindoClient -> getToken
//     group('getToken', () {
//       setUp(() {
//         when(() => dio.getUri(any())).thenAnswer(
//           (_) async => Response<Map<String, dynamic>>(
//             data: {'token': token},
//             statusCode: 200,
//             requestOptions: RequestOptions(
//               path: '/users/token',
//               baseUrl: PindoClient.authority,
//             ),
//           ),
//         );
//       });

//       test('calls dio.getUri', () async {
//         await subject.getToken(username: username, password: password);
//         verify(
//           () => dio.getUri(Uri.https(PindoClient.authority, '/users/token')),
//         ).called(1);
//       });

//       test('throws HttpFailure when http request fails', () {
//         when(() => dio.getUri(any())).thenThrow(Exception());
//         expect(
//           () => subject.getToken(username: username, password: password),
//           throwsA(isA<HttRequestError>()),
//         );
//       });

//       test(
//           'throws JSONDecodeFailure when the request '
//           'succeeds but the response body is not of the expected format', () {
//         when(() => dio.getUri(any())).thenAnswer(
//           (_) async => Response<Map<String, dynamic>>(
//             data: {},
//             statusCode: 200,
//             requestOptions: RequestOptions(
//               path: '/users/token',
//               baseUrl: PindoClient.authority,
//             ),
//           ),
//         );

//         expect(
//           () => subject.getToken(username: username, password: password),
//           throwsA(isA<JSONDecodeFailure>()),
//         );
//       });

//       test(
//           'throws ExpectedResultFailure if the response body '
//           'does not contain the key`token`', () {
//         when(() => dio.getUri(any())).thenAnswer(
//           (_) async => Response<Map<String, dynamic>>(
//             data: {
//               'not-token': 'i am a token🤫️',
//             },
//             statusCode: 200,
//             requestOptions: RequestOptions(
//               path: '/users/token',
//               baseUrl: PindoClient.authority,
//             ),
//           ),
//         );
//         expect(
//           () => subject.getToken(username: username, password: password),
//           throwsA(isA<UnexpectedResponseError>()),
//         );
//       });
//     });

// // PindoClient -> register
//     group('register', () {
//       const path = '/users/register';
//       setUp(() {
//         when(() => dio.postUri(any(), data: any(named: 'data'))).thenAnswer(
//           (_) async => Response<Map<String, dynamic>>(
//             data: {'self_url': profileURL},
//             statusCode: 200,
//             requestOptions: RequestOptions(
//               path: path,
//               baseUrl: PindoClient.authority,
//             ),
//           ),
//         );
//       });

//       test('calls dio.postUri', () async {
//         await subject.register(
//           username: username,
//           email: email,
//           password: password,
//         );
//         verify(
//           () => dio.postUri(Uri.https(PindoClient.authority, path),
//               data: any(named: 'data')),
//         ).called(1);
//       });

//       test('throws HttpFailure when http request fails', () {
//         when(() => dio.postUri(any(), data: any(named: 'data')))
//             .thenThrow(Exception());
//         expect(
//           () => subject.register(
//             username: username,
//             email: email,
//             password: password,
//           ),
//           throwsA(isA<HttRequestError>()),
//         );
//       });

//       test(
//         'throws HttpRequestFailure when http succeeds '
//         'but the response has the key `error` in the json',
//         () {
//           when(() => dio.postUri(any(), data: any(named: 'data'))).thenAnswer(
//             (_) async => Response<Map<String, dynamic>>(
//               data: {
//                 'error': 'failed',
//                 'status': 404,
//                 'message': 'An error occured'
//               },
//               statusCode: 200,
//               requestOptions: RequestOptions(
//                 path: path,
//                 baseUrl: PindoClient.authority,
//               ),
//             ),
//           );
//           expect(
//             () => subject.register(
//               username: username,
//               email: email,
//               password: password,
//             ),
//             throwsA(isA<HttpRequestFailure>()),
//           );
//         },
//       );

//       test(
//           'throws JSONDecodeFailure when the request '
//           'succeeds but the response body is not of the expected format', () {
//         when(() => dio.postUri(any(), data: any(named: 'data'))).thenAnswer(
//           (_) async => Response<Map<String, dynamic>>(
//             data: {},
//             statusCode: 200,
//             requestOptions: RequestOptions(
//               path: path,
//               baseUrl: PindoClient.authority,
//             ),
//           ),
//         );

//         expect(
//           () => subject.refreshToken(
//             username: username,
//             password: password,
//           ),
//           throwsA(isA<JSONDecodeFailure>()),
//         );
//       });

//       test(
//           'throws ExpectedResultFailure if the response body '
//           'does not contain the key`self_url`', () {
//         when(() => dio.postUri(any(), data: any(named: 'data'))).thenAnswer(
//           (_) async => Response<Map<String, dynamic>>(
//             data: {
//               'not-token': 'i am a token🤫️',
//             },
//             statusCode: 200,
//             requestOptions: RequestOptions(
//               path: path,
//               baseUrl: PindoClient.authority,
//             ),
//           ),
//         );
//         expect(
//           () => subject.register(
//             username: username,
//             email: email,
//             password: password,
//           ),
//           throwsA(isA<UnexpectedResponseError>()),
//         );
//       });
//     });

// // PindoClient -> refreshToken()
//     group('refreshToken', () {
//       setUp(() {
//         when(() => dio.getUri(any())).thenAnswer(
//           (_) async => Response<Map<String, dynamic>>(
//             data: {'token': token},
//             statusCode: 200,
//             requestOptions: RequestOptions(
//               path: '/users/refresh/token',
//               baseUrl: PindoClient.authority,
//             ),
//           ),
//         );
//       });

//       test('calls dio.getUri', () async {
//         await subject.refreshToken(
//           username: username,
//           password: password,
//         );
//         verify(
//           () => dio
//               .getUri(Uri.https(PindoClient.authority, '/users/refresh/token')),
//         ).called(1);
//       });

//       test('throws HttpFailure when http request fails', () {
//         when(() => dio.getUri(any())).thenThrow(Exception());
//         expect(
//           () => subject.refreshToken(
//             username: username,
//             password: password,
//           ),
//           throwsA(isA<HttRequestError>()),
//         );
//       });

//       test(
//         'throws HttpRequestFailure when http succeeds '
//         'but the response has the key `error` in the json',
//         () {
//           when(() => dio.getUri(any())).thenAnswer(
//             (_) async => Response<Map<String, dynamic>>(
//               data: {
//                 'error': 'failed',
//                 'status': 404,
//                 'message': 'An error occured'
//               },
//               statusCode: 200,
//               requestOptions: RequestOptions(
//                 path: '/users/refresh/token',
//                 baseUrl: PindoClient.authority,
//               ),
//             ),
//           );
//           expect(
//             () => subject.refreshToken(
//               username: username,
//               password: password,
//             ),
//             throwsA(isA<HttpRequestFailure>()),
//           );
//         },
//       );

//       test(
//           'throws JSONDecodeFailure when the request '
//           'succeeds but the response body is not of the expected format', () {
//         when(() => dio.getUri(any())).thenAnswer(
//           (_) async => Response<Map<String, dynamic>>(
//             data: {},
//             statusCode: 200,
//             requestOptions: RequestOptions(
//               path: '/users/refresh/token',
//               baseUrl: PindoClient.authority,
//             ),
//           ),
//         );

//         expect(
//           () => subject.refreshToken(
//             username: username,
//             password: password,
//           ),
//           throwsA(isA<JSONDecodeFailure>()),
//         );
//       });

//       test(
//           'throws ExpectedResultFailure if the response body '
//           'does not contain the key`token`', () {
//         when(() => dio.getUri(any())).thenAnswer(
//           (_) async => Response<Map<String, dynamic>>(
//             data: {
//               'not-token': 'i am a token🤫️',
//             },
//             statusCode: 200,
//             requestOptions: RequestOptions(
//               path: '/users/refresh/token',
//               baseUrl: PindoClient.authority,
//             ),
//           ),
//         );
//         expect(
//           () => subject.refreshToken(
//             username: username,
//             password: password,
//           ),
//           throwsA(isA<UnexpectedResponseError>()),
//         );
//       });
//     });

// // PindoClient -> balance
//     group('balance', () {
//       const headers = {'Authorization': 'Bearer $token'};

//       setUp(() {
//         dio.options.headers = headers;
//         when(
//           () => dio.getUri(any(), options: any(named: 'options')),
//         ).thenAnswer(
//           (_) async => Response<Map<String, dynamic>>(
//             data: {'amount': balance},
//             statusCode: 200,
//             requestOptions: RequestOptions(
//               path: '/wallets/self',
//               baseUrl: PindoClient.authority,
//             ),
//           ),
//         );
//       });

//       test('calls dio.getUri', () async {
//         await subject.balance(token: token);
//         dio.options.headers['Authorization'] = 'Bearer $token';
//         verify(
//           () => dio.getUri(
//             Uri.https(PindoClient.authority, '/wallets/self'),
//           ),
//         ).called(1);
//       });

//       test('throws HttpFailure when http request fails', () {
//         when(() => dio.getUri(any())).thenThrow(Exception());
//         expect(
//           () => subject.balance(token: token),
//           throwsA(isA<HttRequestError>()),
//         );
//       });

//       test(
//         'throws HttpRequestFailure when http succeeds '
//         'but the response has the key `error` in the json',
//         () {
//           when(() => dio.getUri(any())).thenAnswer(
//             (_) async => Response<Map<String, dynamic>>(
//               data: {
//                 'error': 'failed',
//                 'status': 404,
//                 'message': 'An error occured'
//               },
//               statusCode: 200,
//               requestOptions: RequestOptions(
//                 path: '/wallets/self',
//                 baseUrl: PindoClient.authority,
//               ),
//             ),
//           );
//           expect(
//             () => subject.balance(token: token),
//             throwsA(isA<HttpRequestFailure>()),
//           );
//         },
//       );

//       test(
//           'throws JSONDecodeFailure when the request '
//           'succeeds but the response body is not of the expected format', () {
//         when(() => dio.getUri(any())).thenAnswer(
//           (_) async => Response<Map<String, dynamic>>(
//             data: null,
//             statusCode: 200,
//             requestOptions: RequestOptions(
//               path: '/wallets/self',
//               baseUrl: PindoClient.authority,
//             ),
//           ),
//         );

//         expect(
//           () => subject.balance(token: token),
//           throwsA(isA<JSONDecodeFailure>()),
//         );
//       });

//       test(
//           'throws ExpectedResultFailure if the response body '
//           'does not contain the key`amount`', () {
//         when(() => dio.getUri(any())).thenAnswer(
//           (_) async => Response<Map<String, dynamic>>(
//             data: {
//               'not-amount': 'i am an amount🤫️',
//             },
//             statusCode: 200,
//             requestOptions: RequestOptions(
//               path: '/wallets/self',
//               baseUrl: PindoClient.authority,
//             ),
//           ),
//         );
//         expect(
//           () => subject.balance(token: token),
//           throwsA(isA<UnexpectedResponseError>()),
//         );
//       });
//     });

// // PindoClient -> sendSMS
//     group('sendSMS', () {
//       const text = 'boris is awesome';
//       const path = '/v1/sms/';
//       final from = phoneNumbers[1], to = phoneNumbers[0];
//       final payload = {
//         'to': phoneNumbers[1],
//         'sender': phoneNumbers[0],
//         'text': text,
//       };

//       setUp(() {
//         dio.options.headers['Authorization'] = 'Bearer $token';
//         when(() => dio.postUri(any(), data: any(named: 'data'))).thenAnswer(
//           (_) async => Response<Map<String, dynamic>>(
//             statusCode: 200,
//             data: {'status': 'sent'},
//             requestOptions: RequestOptions(
//               path: path,
//               baseUrl: PindoClient.authority,
//             ),
//           ),
//         );
//       });

//       test('calls dio.getUri', () async {
//         await subject.sendSMS(
//           token: token,
//           from: phoneNumbers[0],
//           to: phoneNumbers[1],
//           text: text,
//         );
//         dio.options.headers['Authorization'] = 'Bearer $token';
//         verify(
//           () => dio.postUri(
//             Uri.https(PindoClient.authority, path),
//             data: payload,
//           ),
//         ).called(1);
//       });

//       test('throws HttpFailure when http request fails', () {
//         when(
//           () => dio.postUri(any(), data: any(named: 'data')),
//         ).thenThrow(Exception());
//         expect(
//           () => subject.sendSMS(
//             token: token,
//             from: from,
//             to: to,
//             text: text,
//           ),
//           throwsA(isA<HttRequestError>()),
//         );
//       });

//       test(
//         'throws HttpRequestFailure when http succeeds '
//         'but the response has the key `error` in the json',
//         () {
//           when(() => dio.postUri(any(), data: any(named: 'data'))).thenAnswer(
//             (_) async => Response<Map<String, dynamic>>(
//               data: {
//                 'error': 'failed',
//                 'status': 404,
//                 'message': 'An error occured'
//               },
//               statusCode: 200,
//               requestOptions: RequestOptions(
//                 path: path,
//                 baseUrl: PindoClient.authority,
//               ),
//             ),
//           );
//           expect(
//             () => subject.sendSMS(token: token, to: to, from: from, text: text),
//             throwsA(isA<HttpRequestFailure>()),
//           );
//         },
//       );

//       test(
//           'throws JSONDecodeFailure when the request '
//           'succeeds but the response body is not of the expected format', () {
//         when(() => dio.postUri(any(), data: any(named: 'data'))).thenAnswer(
//           (_) async => Response<Map<String, dynamic>>(
//             data: null,
//             statusCode: 200,
//             requestOptions: RequestOptions(
//               path: path,
//               baseUrl: PindoClient.authority,
//             ),
//           ),
//         );

//         expect(
//           () => subject.sendSMS(token: token, to: to, from: from, text: text),
//           throwsA(isA<JSONDecodeFailure>()),
//         );
//       });

//       test(
//           'throws ExpectedResultFailure if the response body '
//           'does not contain the key`status`', () {
//         when(() => dio.postUri(any(), data: any(named: 'data'))).thenAnswer(
//           (_) async => Response<Map<String, dynamic>>(
//             data: {
//               'not-status': 'i am status🤫️',
//             },
//             statusCode: 200,
//             requestOptions: RequestOptions(
//               path: path,
//               baseUrl: PindoClient.authority,
//             ),
//           ),
//         );
//         expect(
//           () => subject.sendSMS(token: token, to: to, from: from, text: text),
//           throwsA(isA<UnexpectedResponseError>()),
//         );
//       });
//     });

// // PindoClient -> organization
//     group('sendSMS', () {
//       const path = '/orgs/self';
//       const webHookURL = 'https://example.com';
//       const name = 'Awesomeness';
//       const retriesCount = 1;

//       final payload = {
//         'name': name,
//         'webhook_url': webHookURL,
//         'sms_retries': retriesCount
//       };

//       setUp(() {
//         dio.options.headers['Authorization'] = 'Bearer $token';
//         when(() => dio.putUri(any(), data: any(named: 'data'))).thenAnswer(
//           (_) async => Response<Map<String, dynamic>>(
//             statusCode: 200,
//             data: {'self_url': 'https://pindo.io'},
//             requestOptions: RequestOptions(
//               path: path,
//               baseUrl: PindoClient.authority,
//             ),
//           ),
//         );
//       });

//       test('calls dio.putUri', () async {
//         await subject.organization(
//           token: token,
//           name: name,
//           webHookURL: webHookURL,
//           retriesCount: retriesCount,
//         );
//         dio.options.headers['Authorization'] = 'Bearer $token';
//         verify(
//           () => dio.putUri(
//             Uri.https(PindoClient.authority, path),
//             data: payload,
//           ),
//         ).called(1);
//       });

//       // test('throws HttpFailure when http request fails', () {
//       //   when(
//       //     () => dio.putUri(any(), data: any(named: 'data')),
//       //   ).thenThrow(Exception());
//       //   expect(
//       //     () => subject.organization(
//       //       token: token,
//       //       name: name,
//       //       webHookURL: webHookURL,
//       //       retriesCount: retriesCount,
//       //     ),
//       //     throwsA(isA<HttpFailure>()),
//       //   );
//       // });

//       // test(
//       //   'throws HttpRequestFailure when http succeeds '
//       //   'but the response has the key `error` in the json',
//       //   () {
//       //     when(() => dio.putUri(any(), data: any(named: 'data'))).thenAnswer(
//       //       (_) async => Response<Map<String,dynamic>>(
//       //         data: {
//       //           'error': 'failed',
//       //           'status': 404,
//       //           'message': 'An error occured'
//       //         },
//       //         statusCode: 200,
//       //         requestOptions: RequestOptions(
//       //           path: path,
//       //           baseUrl: PindoClient.authority,
//       //         ),
//       //       ),
//       //     );
//       //     expect(
//       //       () => subject.organization(
//       //         token: token,
//       //         name: name,
//       //         webHookURL: webHookURL,
//       //         retriesCount: retriesCount,
//       //       ),
//       //       throwsA(isA<HttpRequestFailure>()),
//       //     );
//       //   },
//       // );

//       // test(
//       //     'throws JSONDecodeFailure when the request '
//       //     'succeeds but the response body is not of the expected format', () {
//       //   when(() => dio.postUri(any(), data: any(named: 'data'))).thenAnswer(
//       //     (_) async => Response<Map<String,dynamic>>(
//       //       data: null,
//       //       statusCode: 200,
//       //       requestOptions: RequestOptions(
//       //         path: path,
//       //         baseUrl: PindoClient.authority,
//       //       ),
//       //     ),
//       //   );

//       //   expect(
//       //     () => subject.organization(
//       //       token: token,
//       //       name: name,
//       //       webHookURL: webHookURL,
//       //       retriesCount: retriesCount,
//       //     ),
//       //     throwsA(isA<JSONDecodeFailure>()),
//       //   );
//       // });

//       // test(
//       //     'throws ExpectedResultFailure if the response body '
//       //     'does not contain the key`self_url`', () {
//       //   when(() => dio.postUri(any(), data: any(named: 'data'))).thenAnswer(
//       //     (_) async => Response<Map<String,dynamic>>(
//       //       data: {
//       //         'not-status': 'i am status🤫️',
//       //       },
//       //       statusCode: 200,
//       //       requestOptions: RequestOptions(
//       //         path: path,
//       //         baseUrl: PindoClient.authority,
//       //       ),
//       //     ),
//       //   );
//       //   expect(
//       //     () => subject.organization(
//       //       token: token,
//       //       name: name,
//       //       webHookURL: webHookURL,
//       //       retriesCount: retriesCount,
//       //     ),
//       //     throwsA(isA<ExpectedResultFailure>()),
//       //   );
//       // });
//     });
//   });

//   group('HttpFailure', () {
//     test('has concise toString', () {
//       expect(
//         const HttRequestError('failed').toString(),
//         equals('HttpFailure: failed'),
//       );
//     });
//   });

//   group('HttpRequestFailure', () {
//     test('has concise toString', () {
//       expect(
//         const HttpRequestFailure(statusCode: 404, type: 'not found').toString(),
//         equals('HttpRequestFailure(404, not found)'),
//       );
//     });
//   });
// }
