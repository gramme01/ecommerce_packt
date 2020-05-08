import 'package:flutter/material.dart';

import './register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;

  String _email, _password;

  Widget _showTitle(BuildContext ctx) => Text(
        'Login',
        style: Theme.of(ctx).textTheme.headline1,
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
                child: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off),
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )),
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
              color: Theme.of(context).accentColor,
            ),
            FlatButton(
              child: Text('New user? Register'),
              onPressed: () => Navigator.pushReplacementNamed(
                context,
                RegisterScreen.routeName,
              ),
            )
          ],
        ),
      );

  void _submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      print('Email: $_email, Password: $_password');
    } else {
      print("Form Invalid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Login'),
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
