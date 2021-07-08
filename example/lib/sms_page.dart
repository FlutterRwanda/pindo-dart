import 'package:flutter/material.dart';
import 'package:pindo_client/pindo_client.dart';

class SMSPage extends StatefulWidget {
  const SMSPage({Key? key}) : super(key: key);

  @override
  _SMSPageState createState() => _SMSPageState();
}

class _SMSPageState extends State<SMSPage> {
  late TextEditingController _recipientNumber;
  late TextEditingController _author;
  late TextEditingController _token;
  late TextEditingController _text;

  final _pindo = PindoClient();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _recipientNumber = TextEditingController();
    _author = TextEditingController();
    _token = TextEditingController();
    _text = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SMS')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _recipientNumber,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Sending to'),
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return 'This field cannot be empty';
                  }
                  if (!RegExp(r'^\+250.*$').hasMatch(input)) {
                    return 'Please enter a Rwandan phone number\n'
                        '(Starts with +250)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                autocorrect: true,
                keyboardType: TextInputType.text,
                controller: _text,
                maxLines: 7,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(),
                ),
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return 'This field cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _author,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(labelText: 'Sender Name'),
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return 'This field cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _token,
                decoration: const InputDecoration(labelText: 'Token'),
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return 'This field cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _pindo
                        .sendSMS(
                          token: _token.text.trim(),
                          to: _recipientNumber.text.trim(),
                          from: _author.text,
                          text: _text.text,
                        )
                        .then(
                          (balance) => showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Message sent!'),
                                  content: Text(
                                    'Remaining balance: $balance',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5!
                                        .copyWith(color: Colors.green),
                                  ),
                                );
                              })
                            ..onError(
                              (error, stackTrace) {
                                var msg = 'request failed';
                                if (error is PindoError) msg = error.message!;

                                return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          'SMS Not Sent',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        content: Text(msg),
                                      );
                                    });
                              },
                            ),
                        );
                  }
                },
                child: const Text('Send SMS'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _author.dispose();
    _recipientNumber.dispose();
    _token.dispose();
    _text.dispose();
    super.dispose();
  }
}
