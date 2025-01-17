import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import './register_screen.dart';
import './products_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final registerUrl = 'http://10.0.2.2:1337/auth/local/';

  var _isSubmitting, _obscureText = true;

  String _email, _password;

  Widget _showTitle(BuildContext ctx) => Text(
        'Login',
        style: Theme.of(ctx).textTheme.headline1,
      );

  Widget _showEmailInput() => Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: TextFormField(
          onSaved: (val) => _email = val,
          // validator: (val) => !val.contains('@') ? 'Invalid Email' : null,
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
          validator: (val) => val.length < 6 ? 'Password too short' : null,
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
            _isSubmitting == true
                ? CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation(Theme.of(context).accentColor),
                  )
                : RaisedButton(
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
      _registerUser();
    } else {}
  }

  Future<void> _registerUser() async {
    setState(() {
      _isSubmitting = true;
    });
    http.Response response = await http.post(
      registerUrl,
      body: {
        "identifier": _email.trim(),
        "password": _password,
      },
    );
    final respData = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        _isSubmitting = false;
      });
      _storeUserData(respData);
      _showSnack('${_email.trim()} successfully logged in');
      _redirectUser();
    } else {
      setState(() {
        _isSubmitting = false;
      });
      final String errorMsg = respData['message'][0]['messages'][0]['message'];
      _showSnack(errorMsg, false);
    }
  }

  Future<void> _storeUserData(responseData) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> user = responseData['user'];
    user.putIfAbsent('jwt', () => responseData['jwt']);
    prefs.setString('user', json.encode(user));
    prefs.setString('cardToken', user['card_token']);
  }

  void _showSnack(String text, [bool success = true]) {
    final snackbar = SnackBar(
      content: Text(
        // 'User $_username successfully created',
        text,
        style: TextStyle(color: success ? Colors.green : Colors.red),
      ),
      backgroundColor: Colors.grey[900],
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
    if (success) {
      _formKey.currentState.reset();
    } else {
      throw Exception('Error logging in: $text');
    }
  }

  void _redirectUser() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, ProductsScreen.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        // title: Text('Login'),
        backgroundColor: Colors.transparent,
        elevation: 0, iconTheme: IconThemeData(color: Colors.white),
      ),
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
