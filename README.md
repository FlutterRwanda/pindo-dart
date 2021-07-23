# Pindo Client

![Pindo Client](https://github.com/silverhairs/pindo_client/actions/workflows/main.yml/badge.svg)
[![codecov](https://codecov.io/gh/silverhairs/pindo_client/branch/main/graph/badge.svg)](https://codecov.io/gh/silverhairs/pindo_client)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This is a **non-official** wrapper for the [Pindo](pindo.io) API written in Dart.

Click [here](https://www.pindo.io) to learn more about Pindo.

To see the example app, open https://pindo-client.netlify.app

## Getting Started

---

Add the dependency

```dart
dependendies:
  pindo_client: ^1.0.2
```

## Usage

---

You need a `PindoClient()` object to use all the functionalities offered by the API.
Pindo Client uses [Dio](https://pub.dev/packages/dio) under the hood to handle http requests. If you are using Dio in your app and already have a Dio object initialized, reusing it is recommended but not required while initializing a new `PindoClient()`.

```dart
final pindo = PindoClient();
```

### Registration

To create a new Pindo account, use the function `register` that takes a username, an email and a password as parameters (all of them are as strings and required).

```dart
import 'package:pindo_client/pindo_client.dart';
Future<void> main() async{
    final pindo = PindoClient();
    await pindo.register(
      username:'pindo',
      email:'pindo@test.com',
      password: 'awesome-password'
    ).then((_)=>print('Logged in')).onError((e,s)=>print('$e'));
}
```

### Token

To get the user's token, use the function `getToken` that takes a username and a password (all as string and required); and returns the token(string).

```dart
import 'package:pindo_client/pindo_client.dart';
Future<void> main() async{
  final pindo = PindoClient();
  await pindo.getToken(
    username:'pindo',
    password:'awesome-password'
  ).then((token)=>print(token)).onError((e,s)=>print('$e'));
}
```

### Refresh Token

To refresh the user's token, use the function `refreshToken` that takes a username and a password(all as string and required); and returns the refreshed token(string).

```dart
import 'package:pindo_client/pindo_client.dart';
Future<void> main() async{
  final pindo = PindoClient();
  await pindo.refreshToken(
    username:'pindo',
    password:'awesome-password'
  ).then((token)=>print(token)).onError((e,s)=>print('$e'));
}
```

### Balance

To get the user's balance, use the function `balance` that takes the user's token and returns their balance(double).

```dart
import 'package:pindo_client/pindo_client.dart';
Future<void> main() async{
  final pindo = PindoClient();
  await pindo.balance(
    token:'awesomest-token-in-the-entire-world',
  ).then((balance)=>print('$balance')).onError((e,s)=>print('$e'));
}
```

### SMS

To send an SMS, use the function `sendSMS` that takes the parameters: token(sender's token), to(the receiver's phone number), from(the sender's name), and text(the sms body) all of them as strings. This function returns the user's remaining balance after they have sent the SMS.

**Note: Only works with Rwandan 🇷🇼 phone numbers**

```dart
import 'package:pindo_client/pindo_client.dart';
Future<void> main() async{
  final pindo = PindoClient();
  await pindo.sendSMS(
    token:'<my-token>',
    to: '<my-phone-number>',
    from: 'Pindo',
    text: 'Hello Pindo',
  ).then((balance)=>print('$balance')).onError((e,s)=>print('$e'));
}
```

### Organization

To update a pindo organization, use the function `organization` which takes four parameters: a token(String), the organization name(String), a webhook url(String) and the number of retries(int). This function returns the organization's URL.

```dart
Future<void> main() async{
  final pindo = PindoClient();
  await pindo.organization(
    token: '<my-token>',
    name: '<org-name>',
    webHookURL: 'https://example.com/hook',
    retriesCount: 7,
    ).then((url)=>print(url)).onError((e,s)=>print('$e'));
}
```

### Forgot Password

To send the user an email to reset their password, use the function `forgotPassword` which takes one parameter: the user's email addrres.

```dart
  Future<void> main()async{
    final pindo = PindoClient();
    await pindo.forgotPassword(email: 'tester@test.com').then(
    (_)=>print('Email sent')).onError((e,s)=>print('$e'));
  }
```

## Contribution

Please make sure your code is tested before pushing

## About Pindo

Visit the website [here](https://pindo.io); or check the [Pindo on Github](https://github.com/pindoio).

## Author

[Boris Kayi](https://github.com/silverhairs)
