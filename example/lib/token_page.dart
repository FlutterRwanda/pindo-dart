import 'package:flutter/material.dart';
import 'package:pindo_client/pindo_client.dart';

class TokenPage extends StatefulWidget {
  const TokenPage({Key? key}) : super(key: key);

  @override
  _TokenPageState createState() => _TokenPageState();
}

class _TokenPageState extends State<TokenPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _tokenController;
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  final _pindo = PindoClient();

  @override
  void initState() {
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _tokenController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Token')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return 'Username cannot be empty';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                obscureText: !_isPasswordVisible,
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffix: IconButton(
                    icon: _isPasswordVisible
                        ? Icon(Icons.remove_red_eye_rounded)
                        : Icon(
                            Icons.remove_red_eye_outlined,
                            color: Colors.blue,
                          ),
                    onPressed: () => setState(
                      () => _isPasswordVisible = !_isPasswordVisible,
                    ),
                  ),
                ),
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return 'Password cannot be empty';
                  } else if (input.length < 6) {
                    return 'Password must be longer than 5 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextButton(
                child: Text('Get Token'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _pindo
                        .getToken(
                      username: _usernameController.text.trim(),
                      password: _passwordController.text,
                    )
                        .then((value) {
                      setState(() => _tokenController.text = value);
                    }).onError(
                      (error, stackTrace) {
                        var msg = 'request failed';
                        if (error is PindoError) {
                          msg = error.message!;
                        }

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
                  }
                },
              ),
              SizedBox(height: 20),
              TextButton(
                child: Text('Refresh Token'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final username = _usernameController.text;
                    final pw = _passwordController.text;
                    await _pindo
                        .refreshToken(username: username, password: pw)
                        .then((value) => setState(() {
                              _tokenController.text = value;
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
                  }
                },
              ),
              SizedBox(height: 20),
              TextField(
                maxLines: 5,
                controller: _tokenController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Your Pindo Token',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _tokenController.dispose();
    super.dispose();
  }
}
