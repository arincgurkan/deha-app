import 'package:flutter/material.dart';

import '../widgets/title_widget.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signup-screen';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  var isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      isLoading = true;
    });
    // try {
    //   await Provider.of<Auth>(context, listen: false)
    //       .logIn(_authData['email'], _authData['password']);
    // } catch (error) {
    //   var errorMessage = 'Giriş Yapılamadı';
    //   if (error.toString().contains('EMAIL_EXISTS')) {
    //     errorMessage = 'This email address is already in use.';
    //   } else if (error.toString().contains('INVALID_EMAIL')) {
    //     errorMessage = 'This is not a valid email address';
    //   } else if (error.toString().contains('WEAK_PASSWORD')) {
    //     errorMessage = 'This password is too weak';
    //   } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
    //     errorMessage = 'Could not find a user with that email.';
    //   } else if (error.toString().contains('INVALID_PASSWORD')) {
    //     errorMessage = 'Invalid password.';
    //   }
    //   _showErrorDialog(errorMessage);
    // }

    // setState(() {
    //   isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(15, 31, 40, 1),
      body: Center(
        child: isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Color.fromRGBO(254, 71, 56, 1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromRGBO(15, 31, 40, 1),
                    ),
                  ),
                ),
                height: double.infinity,
                width: double.infinity,
              )
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TitleWidget(),
                      inputFields('Please Enter Your Full Name', 'Full Name', false, TextInputType.text, 'name'),
                      inputFields('Please Enter Your Phone Number', 'Phone Number', false, TextInputType.phone, 'phoneNumber'),
                      inputFields('Please Enter Your Password', 'Password', true, TextInputType.text, 'password'),
                      
                      SizedBox(
                        height: 90,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(254, 71, 56, 1),
                        ),
                        child: GestureDetector(
                          child: Center(
                            child: Text(
                              'Register',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onTap: _submit,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'OR',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(254, 71, 56, 1),
                        ),
                        child: GestureDetector(
                          child: Center(
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onTap: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget inputFields(validator, inputType, bool isObsecure, TextInputType textInputType, inputName) {
    return Container(
      padding: const EdgeInsets.only(
        top: 25,
      ),
      width: MediaQuery.of(context).size.width * 0.8,
      child: Container(
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        color: Colors.white,
        child: TextFormField(
          style: TextStyle(color: Colors.black),
          validator: (value) {
            if (value.isEmpty) {
              return validator;
            } else {
              // _authData['email'] = value;
            }
            return null;
          },
          obscureText: isObsecure,
          keyboardType: textInputType,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            labelText: inputType,
            labelStyle: TextStyle(
              color: Colors.black,
            ),
          ),
          onSaved: (value) {
            print(value);
            // _authData['email'] = value;
          },
        ),
      ),
    );
  }
}
