import 'package:flutter/material.dart';
import 'package:hello_me/passwordConfirmation.dart';
import 'package:provider/provider.dart';
import 'authNotifier.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Welcome to Startup Names Generator, please log in below',
                style: TextStyle(fontSize: 16),
              ),
              TextField(
                controller: _email,
                decoration: InputDecoration(hintText: 'Email'),
                onChanged: (_) => setState(() {}),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
                onChanged: (_) => setState(() {}),
              ),
              Container(
                width: double.infinity,
                child: Consumer<AuthNotifier>(
                  builder: (context, auth, _) {
                    return ElevatedButton(
                      onPressed: auth.status == Status.Authenticating
                          ? null
                          : () async {
                              if (await auth.signIn(_email.text, _password.text)) {
                                Navigator.pop(context);
                              } else {
                                final snackBar = SnackBar(
                                    content: Text('There was an error logging into the app'));
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                            },
                      child: Text('Log in'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('New user? Click to sign up'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: _email.text.isEmpty || _password.text.isEmpty
                      ? null
                      : () {
                          showModalBottomSheet<void>(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return PasswordConfirmation(_email.text, _password.text);
                            },
                          );
                        },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
