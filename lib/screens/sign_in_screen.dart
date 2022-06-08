import 'package:announcements_app/data_models_and_providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _form = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _isSignUpMode = false;
  bool _isLoading = false;

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An Error Occured!'),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Okay'),
                )
              ],
            ));
  }

  Future<void> _submitForm() async {
    if (!_form.currentState!.validate()) {
      return;
    }

    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_isSignUpMode) {
        await Provider.of<AuthProvider>(context, listen: false).singup(
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        await Provider.of<AuthProvider>(context, listen: false).login(
          _authData['email']!,
          _authData['password']!,
        );
      }
    } catch (error) {
      var errorMessage = 'Could not authenticate you. Please try again later.';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password';
      }
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizeOfDevice = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome!',
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              color: Colors.black54,
              child: Center(
                child: AnimatedContainer(
                  curve: Curves.easeIn,
                  duration: Duration(milliseconds: 500),
                  width: sizeOfDevice.width * (3 / 4),
                  height: _isSignUpMode
                      ? sizeOfDevice.height * (13 / 22)
                      : sizeOfDevice.height * (13 / 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Form(
                    key: _form,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            _isSignUpMode ? 'Sign up' : 'Sign in',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 30,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                TextFormField(
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    focusColor: Colors.white,
                                    label: Text(
                                      'Email',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                  ),
                                  onSaved: (value) {
                                    _authData['email'] = value!;
                                  },
                                  validator: (value) {
                                    bool isEmailValid = RegExp(
                                            r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                        .hasMatch(value!);
                                    if (!isEmailValid) {
                                      return 'Please provide valid e-mail';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  obscureText: true,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    label: Text(
                                      'Password',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 5) {
                                      return 'Password is too short!';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _authData['password'] = value!;
                                  },
                                ),
                                _isSignUpMode
                                    ? TextFormField(
                                        validator: _isSignUpMode
                                            ? (value) {
                                                if (value !=
                                                    _passwordController.text) {
                                                  return 'Passwords do not match!';
                                                }
                                              }
                                            : null,
                                        obscureText: true,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          label: Text(
                                            'Repeat Password',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  onPressed: _submitForm,
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    child: Text(
                                      _isSignUpMode ? 'Sing up' : 'Sign in',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                TextButton(
                                  style: ButtonStyle(),
                                  onPressed: () {
                                    setState(() {
                                      _isSignUpMode = !_isSignUpMode;
                                    });
                                  },
                                  child: Text(
                                    _isSignUpMode ? 'Sing in' : 'Sign up',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.secondary,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
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
