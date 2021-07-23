import 'package:flutter/material.dart';
import 'package:pindo_client/pindo_client.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();
  final _pindo = PindoClient();

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email address'),
                validator: (input) {
                  final pattern = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                  );
                  if (input == null || input.isEmpty) {
                    return 'Email cannot be empty';
                  } else if (!pattern.hasMatch(input)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _pindo
                        .forgotPassword(
                          email: _emailController.text.trim(),
                        )
                        .then((_) => showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Check your emails'),
                                content: Text(
                                  'Password recovery URL sent',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(color: Colors.green),
                                ),
                              );
                            }))
                        .onError(
                      (error, stackTrace) {
                        var msg = 'Failed';
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
                  }
                },
                child: const Text('Reset My Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
