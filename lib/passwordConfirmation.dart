import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authNotifier.dart';

class PasswordConfirmation extends StatefulWidget {
  final String _email;
  final String _password;

  PasswordConfirmation(this._email, this._password);

  @override
  _PasswordConfirmationState createState() => _PasswordConfirmationState();
}

class _PasswordConfirmationState extends State<PasswordConfirmation> {
  bool _valid = true;
  final _confirm = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.3,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Please confirm your password",
              style: TextStyle(fontSize: 16),
            ),
            Divider(),
            TextField(
              controller: _confirm,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: _valid ? null : 'Passwords must match',
                errorStyle: TextStyle(fontSize: 16),
              ),
            ),
            Divider(),
            Consumer<AuthNotifier>(builder: (context, auth, child) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal,
                ),
                child: Text(
                  "Confirm",
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: auth.status == Status.Authenticating
                    ? null
                    : () async {
                        if (_confirm.text != widget._password) {
                          setState(() => _valid = false);
                        } else {
                          if (await auth.signUp(widget._email, widget._password) != null) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }
                        }
                      },
              );
            }),
          ],
        ),
      ),
    );
  }
}
