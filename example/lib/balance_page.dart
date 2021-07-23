import 'package:flutter/material.dart';
import 'package:pindo/pindo.dart';

class BalancePage extends StatefulWidget {
  const BalancePage({Key? key}) : super(key: key);

  @override
  _BalancePageState createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  late TextEditingController _controller;
  final _pindo = Pindo();
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
              decoration: const InputDecoration(labelText: 'Token'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                await _pindo
                    .balance(token: _controller.text.trim())
                    .then((value) => showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Your balance is'),
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
                            title: const Text(
                              'Failed',
                              style: TextStyle(color: Colors.red),
                            ),
                            content: Text(msg),
                          );
                        });
                  },
                );
              },
              child: const Text('Get Balance'),
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
