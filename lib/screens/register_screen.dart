import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final registerUrl = 'http://10.0.2.2:1337/auth/local/register';

  var _obscureText = true;
  String _username, _email, _password;

  Widget _showTitle(BuildContext ctx) => Text(
        'Register',
        style: Theme.of(ctx).textTheme.headline1,
      );

  Widget _showUsernameInput() => Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: TextFormField(
          onSaved: (val) => _username = val,
          validator: (val) => val.length < 6 ? 'Username too short' : null,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Username',
            hintText: 'Enter username, min length 6',
            icon: Icon(
              Icons.face,
              color: Colors.grey,
            ),
          ),
        ),
      );

  Widget _showEmailInput() => Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: TextFormField(
          onSaved: (val) => _email = val,
          validator: (val) => !val.contains('@') ? 'Invalid Email' : null,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Email',
            hintText: 'Enter a valid email',
            icon: Icon(
              Icons.mail,
              color: Colors.grey,
            ),
          ),
        ),
      );

  Widget _showPasswordInput() => Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: TextFormField(
          onSaved: (val) => _password = val,
          validator: (val) => val.length < 6 ? 'Username too short' : null,
          obscureText: _obscureText,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Password',
            hintText: 'Enter password, min length 6',
            icon: Icon(
              Icons.lock,
              color: Colors.grey,
            ),
            suffixIcon: GestureDetector(
              child:
                  Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          ),
        ),
      );

  Widget _showFormActions() => Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: _submit,
              child: Text(
                'Submit',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Colors.black,
                    ),
              ),
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              color: Theme.of(context).primaryColor,
            ),
            FlatButton(
              child: Text('Existing user? Login'),
              onPressed: () => Navigator.pushReplacementNamed(
                context,
                LoginScreen.routeName,
              ),
            )
          ],
        ),
      );

  void _submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _registerUser();
    } else {
      print("Form Invalid");
    }
  }

  Future<void> _registerUser() async {
    http.Response response = await http.post(
      registerUrl,
      body: {
        "username": _username,
        "email": _email,
        "password": _password,
      },
    );
    final respData = json.decode(response.body);
    print(respData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Register'),
      //   // leading: Icon(Icons.arrow_back_ios),
      // ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _showTitle(context),
                    _showUsernameInput(),
                    _showEmailInput(),
                    _showPasswordInput(),
                    _showFormActions(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
