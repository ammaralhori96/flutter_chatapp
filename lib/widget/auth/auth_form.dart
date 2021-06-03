import 'dart:io';

import '/widget/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String password, String username,
      File image, bool isLogin, BuildContext ctx) submitFn;
  final bool _isLoading;
  AuthForm(this.submitFn, this._isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = "";
  String _password = "";
  String _username = "";
  File _userImageFile;

  void _pickedImage(File pickedImage) {
    _userImageFile = pickedImage;
  }

  void _sumbit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Please Pick an Image"),
        backgroundColor: Theme.of(context).errorColor,
      ));

      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(_email.trim(), _password.trim(), _username.trim(),
          _userImageFile, _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    autocorrect: false,
                    enableSuggestions: false,
                    textCapitalization: TextCapitalization.none,
                    key: ValueKey('email'),
                    validator: (val) {
                      if (val.isEmpty || !val.contains('@')) {
                        return "Please enter a valid email adress";
                      }
                      return null;
                    },
                    onSaved: (val) => _email = val,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: "Email Address"),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      autocorrect: true,
                      enableSuggestions: false,
                      textCapitalization: TextCapitalization.words,
                      key: ValueKey('username'),
                      validator: (val) {
                        if (val.isEmpty || val.length < 4) {
                          return "Please enter at least 4 charcters";
                        }
                        return null;
                      },
                      onSaved: (val) => _username = val,
                      decoration: InputDecoration(labelText: "username"),
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (val) {
                      if (val.isEmpty || val.length < 7) {
                        return "Password must be at least 7 charcters";
                      }
                      return null;
                    },
                    onSaved: (val) => _password = val,
                    decoration: InputDecoration(labelText: "password"),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget._isLoading) CircularProgressIndicator(),
                  if (!widget._isLoading)
                    RaisedButton(
                      child: Text(_isLogin ? 'Login' : 'sign Up'),
                      onPressed: _sumbit,
                    ),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(_isLogin
                        ? 'Create new account'
                        : 'I already have an account'),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
