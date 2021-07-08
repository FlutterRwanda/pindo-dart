# Pindo Client

## [![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)

This is a **non-official** wrapper for the [Pindo](pindo.io) API written in Dart.

Click [here](https://www.pindo.io) to learn more about Pindo.

## Getting Started

---

Add the dependency

```
dependendies:
  pindo_client: ^1.0.0
```

## Usage

---

You need a `PindoClient()` object to use all the functionalities offered by the API.
Pindo Client uses [Dio](https://pub.dev/packages/dio) under the hood to handle http requests. If you are using Dio in your app and already have a Dio object initialized, reusing it is recommended but not required while initializing a new `PindoClient()`.

```
final pindo = PindoClient();
```

### Registration

To create a new Pindo account, use the function `register` that takes a username, an email and a password as parameters (all of them are as strings and required).

```
import 'package:pindo_client/pindo_client.dart';
Future<void> main() async{
    final pindo = PindoClient();
    await pindo.register(
      username:'pindo',
      email:'pindo@test.com',
      password: 'awesome-password'
    ).then((_)=>print('Logged in')).onError((e,s)=>print(e));
}
```

### Token

To get the user's token, use the function `getToken` that takes a username and a password (all as string and required); and returns the token(string).

```
import 'package:pindo_client/pindo_client.dart';
Future<void> main() async{
  final pindo = PindoClient();
  await pindo.getToken(
    username:'pindo',
    password:'awesome-password'
  ).then((token)=>print(token)).onError((e,s)=>print(e));
}
```

### Refresh Token

To refresh the user's token, use the function `refreshToken` that takes a username and a password(all as string and required); and returns the refreshed token(string).

```
import 'package:pindo_client/pindo_client.dart';
Future<void> main() async{
  final pindo = PindoClient();
  await pindo.refreshToken(
    username:'pindo',
    password:'awesome-password'
  ).then((token)=>print(token)).onError((e,s)=>print(e));
}
```

### Balance

To get the user's balance, use the function `balance` that takes the user's token and returns their balance(double).

```
import 'package:pindo_client/pindo_client.dart';
Future<void> main() async{
  final pindo = PindoClient();
  await pindo.balance(
    token:'awesomest-token-in-the-entire-world',
  ).then((balance)=>print('$balance')).onError((e,s)=>print(e));
}
```

### SMS

To send an SMS, use the function`sendSMS` that takes the parameters: token(sender's token), to(the receiver's phone number), from(the sender's name), and text(the sms body) all of them as strings. This function returns the user's remaining balance after they have sent the SMS.<br/>
**Note: Only works with Rwandan 🇷🇼 phone numbers**

```
import 'package:pindo_client/pindo_client.dart';
Future<void> main() async{
  final pindo = PindoClient();
  await pindo.sendSMS(
    token:'awesomest-token-in-the-entire-world',
    to: '+250789159557', // Please don't spam me!
    from: 'Pindo',
    text: 'Hello Pindo',
  ).then((balance)=>print('$balance')).onError((e,s)=>print(e));
}
```

---

## Contribution

Please make sure your code is tested before pushing

## About Pindo

Visit the website [here](https://pindo.io); or check the [Pindo on Github](https://github.com/pindoio).

## Author

[Boris Kayi](https://github.com/silverhairs)
