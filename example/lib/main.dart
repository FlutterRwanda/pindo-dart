import 'package:example/balance_page.dart';
import 'package:example/register_page.dart';
import 'package:example/sms_page.dart';
import 'package:example/token_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (states) => Colors.blue,
            ),
            foregroundColor: MaterialStateProperty.resolveWith<Color>(
              (states) => Colors.white,
            ),
          ),
        ),
      ),
      home: AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pindo Client Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => BalancePage())),
              child: Text('Balance'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => RegisterPage())),
              child: Text('Register'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => TokenPage())),
              child: Text('Token'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => SMSPage())),
              child: Text('SMS'),
            ),
          ],
        ),
      ),
    );
  }
}
