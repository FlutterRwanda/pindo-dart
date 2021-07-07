import 'package:flutter/material.dart';
import 'package:pindo_client/pindo_client.dart';

class BalancePage extends StatefulWidget {
  const BalancePage({Key? key}) : super(key: key);

  @override
  _BalancePageState createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  late TextEditingController _controller;
  final _pindo = PindoClient();
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Balance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Token'),
            ),
            SizedBox(height: 20),
            TextButton(
              child: const Text('Get Balance'),
              onPressed: () async {
                await _pindo
                    .balance(token: _controller.text.trim())
                    .then((value) => showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Your balance is'),
                            content: Text(
                              value.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(color: Colors.green),
                            ),
                          );
                        }))
                    .onError(
                  (error, stackTrace) {
                    var msg = 'request failed';
                    if (error is PindoError) msg = error.message!;

                    return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              'Failed',
                              style: TextStyle(color: Colors.red),
                            ),
                            content: Text(msg),
                          );
                        });
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
