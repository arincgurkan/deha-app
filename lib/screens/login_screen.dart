import 'dart:convert';

import 'package:deha/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../provider/auth.dart';
import '../widgets/title_widget.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  var phoneNumber;
  var verificationCode;
  var fullName;
  var verId;

  var isLoading = false;
  var isLoadingButton = false;
  var codeSended = false;

  var isAlreadyUser;

  dynamic dropdownValue;

  String fcmToken;

  List cityCodes = [];

  void getPermission() async {
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  void initState() {
    super.initState();

    Future.delayed(Duration.zero, ()  {
      getPermission();
    });

    getCities();
    getDeviceToken();
  }

  Future<void> getDeviceToken() async {
    String _fcmToken = await messaging.getToken();
    setState(() {
      fcmToken = _fcmToken;
    });
    print('Token is $fcmToken');
  }

  Future<void> getCities() async {
    final url = 'https://deha-api.herokuapp.com/auth/onboarding';

    try {
      final response = await http.get(Uri.parse(url));

      for (final e in json.decode(response.body)['locations']) {
        cityCodes.add({'code': e['code'], 'name': e['name']});
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> verifyPhone() async {
    setState(() {
      isLoadingButton = true;
    });
    await _auth
        .verifyPhoneNumber(
            phoneNumber: phoneNumber,
            verificationCompleted: (AuthCredential credential) async {
              await _auth.signInWithCredential(credential).then((value) async {
                if (value.user != null) {
                  Navigator.pushReplacementNamed(
                      context, SignUpScreen.routeName);
                }
                print('DONE');
              });
            },
            verificationFailed: (FirebaseAuthException e) {
              print('Verification failed' + e.code);
            },
            codeSent: (String verificationId, [int forceResendingToken]) {
              setState(() {
                verId = verificationId;
                codeSended = true;
              });
            },
            codeAutoRetrievalTimeout: (String verificationID) {
              setState(() {
                verId = verificationID;
              });
            },
            timeout: Duration(seconds: 120))
        .then((value) => {
              setState(() {
                isLoadingButton = false;
              }),
            });
  }

  Future<void> signUp() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }

    signInWithPhoneNumber();
  }

  Future<void> signInWithPhoneNumber() async {
    final registerUrl = 'https://deha-api.herokuapp.com/auth/register';

    PhoneAuthCredential authCred = PhoneAuthProvider.credential(
        verificationId: verId, smsCode: verificationCode);

    print(verificationCode);
    print(verId);

    print('sing in with phone number called');

    setState(() {
      isLoadingButton = true;
    });

    await FirebaseAuth.instance
        .signInWithCredential(authCred)
        .then((value) async {
      if (isAlreadyUser == true) {
        try {
          await Provider.of<Auth>(context, listen: false)
              .logIn(phoneNumber.substring(3), fcmToken);
        } catch (error) {
          print(error);
        }
      } else {
        try {
          final response = await http.post(
            Uri.parse(registerUrl),
            headers: {"Content-type": "application/json"},
            body: json.encode(
              {
                'name': fullName,
                'locationCode': dropdownValue,
                'phone': phoneNumber.substring(3)
              },
            ),
          );

          await Provider.of<Auth>(context, listen: false)
              .logIn(phoneNumber.substring(3), fcmToken);

          print(json.decode(response.body));
        } catch (error) {
          print(error.toString());
        }
      }
      print('Doneeeee');
      // Route to home page
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      isLoadingButton = true;
    });

    final url = 'https://deha-api.herokuapp.com/auth/register/test';

    try {
      final response = await http.post(Uri.parse(url),
          headers: {"Content-type": "application/json"},
          body: json.encode({'phone': phoneNumber.substring(3)}));

      print(json.decode(response.body)['isValid']);

      await verifyPhone();

      setState(() {
        json.decode(response.body)['isValid']
            ? isAlreadyUser = false
            : isAlreadyUser = true;
        isLoadingButton = false;
      });
    } catch (error) {
      print(error.toString());
    }
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
                      Container(
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
                                return 'Please Enter Your Phone Number';
                              } else if (value.length < 13 ||
                                  value.length > 13) {
                                return 'Phone Number Must Be 10 Character Long';
                              } else {
                                setState(() {
                                  phoneNumber = value;
                                });
                                // _authData['email'] = value;
                              }
                              return null;
                            },
                            initialValue: "+90",
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              labelText: 'Phone Number',
                              labelStyle: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            onSaved: (value) {
                              print(value);
                              setState(() {
                                phoneNumber = value;
                              });
                              // _authData['email'] = value;
                            },
                          ),
                        ),
                      ),
                      isAlreadyUser == null
                          ? SizedBox.shrink()
                          : isAlreadyUser == true
                              ? SizedBox.shrink()
                              : Container(
                                  padding: const EdgeInsets.only(
                                    top: 25,
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
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
                                          return 'Please Enter Your Full Name';
                                        } else {
                                          // _authData['email'] = value;
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          fullName = value;
                                        });
                                      },
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        labelText: 'Full Name',
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
                                ),
                      isAlreadyUser == null
                          ? SizedBox.shrink()
                          : isAlreadyUser == false
                              ? Container(
                                  margin: EdgeInsets.only(
                                    top: 20,
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: DropdownButtonFormField<dynamic>(
                                      hint: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 8.0,
                                        ),
                                        child: Text(
                                          'Please Select Your City',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(15, 31, 40, 1),
                                          ),
                                        ),
                                      ),
                                      validator: (value) => value == null
                                          ? 'Please Select Your City'
                                          : null,
                                      value: dropdownValue,
                                      // icon: const Icon(
                                      //   Icons.arrow_downward,
                                      //   textDirection: TextDirection.rtl,
                                      // ),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: const TextStyle(
                                        color: Color.fromRGBO(15, 31, 40, 1),
                                      ),
                                      // underline: Container(
                                      //   height: 2,
                                      //   width:
                                      //       MediaQuery.of(context).size.width *
                                      //           0.8,
                                      //   color: Colors.white,
                                      // ),
                                      onChanged: (dynamic newValue) {
                                        setState(() {
                                          dropdownValue = newValue;
                                        });
                                      },
                                      items: cityCodes.map((map) {
                                        return DropdownMenuItem(
                                          child: Text(
                                            map['name'].toString(),
                                          ),
                                          value: map['code'],
                                        );
                                      }).toList()),
                                )
                              : Container(
                                  padding: const EdgeInsets.only(
                                    top: 25,
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
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
                                          return 'Please Enter Your Verification Code';
                                        } else {
                                          setState(() {
                                            verificationCode = value;
                                          });
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        labelText: 'Verification Code',
                                        labelStyle: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          verificationCode = value;
                                        });
                                      },
                                      onSaved: (value) {
                                        print(value);
                                        setState(() {
                                          verificationCode = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                      isAlreadyUser == null
                          ? SizedBox.shrink()
                          : !isAlreadyUser
                              ? codeSended
                                  ? Container(
                                      padding: const EdgeInsets.only(
                                        top: 25,
                                      ),
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
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
                                              return 'Please Enter Your Verification Code';
                                            } else {
                                              setState(() {
                                                verificationCode = value;
                                              });
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.text,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            labelText: 'Verification Code',
                                            labelStyle: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              verificationCode = value;
                                            });
                                          },
                                          onSaved: (value) {
                                            print(value);
                                            setState(() {
                                              verificationCode = value;
                                            });
                                          },
                                        ),
                                      ),
                                    )
                                  : SizedBox.shrink()
                              : SizedBox.shrink(),
                      SizedBox(
                        height: 90,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(254, 71, 56, 1),
                        ),
                        child: isLoadingButton
                            ? Center(
                                child: CircularProgressIndicator(
                                  backgroundColor:
                                      Color.fromRGBO(254, 71, 56, 1),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color.fromRGBO(15, 31, 40, 1),
                                  ),
                                ),
                              )
                            : isAlreadyUser == null
                                ? GestureDetector(
                                    child: Center(
                                      child: Text(
                                        'NEXT',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    onTap: _submit,
                                  )
                                : isAlreadyUser == true
                                    ? GestureDetector(
                                        child: Center(
                                          child: Text(
                                            'Log In',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        onTap: signInWithPhoneNumber)
                                    : !codeSended
                                        ? GestureDetector(
                                            child: Center(
                                              child: Text(
                                                'Get Verification Code',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            onTap: verifyPhone)
                                        : GestureDetector(
                                            child: Center(
                                              child: Text(
                                                'Sign Up',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            onTap: signUp),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget inputFields(validator, inputType, bool isObsecure,
      TextInputType textInputType, inputName) {
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
