import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  RegExp passValid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");

  String email = '';
  String password = '';

  void _submit() {
    bool isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
    debugPrint(email);
    debugPrint(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  left: 20,
                  bottom: 20,
                  right: 20,
                ),
                // width: 200,
                child: DefaultTextStyle(
                  style: const TextStyle(
                      fontSize: 48.0,
                      color: Color(0xff1DA1F2),
                      fontWeight: FontWeight.w900),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      WavyAnimatedText('Chit Chat'),
                    ],
                    isRepeatingAnimation: true,
                  ),
                ),
              ),
              const Text(
                'Log in to Chit Chat',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 48,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return 'entered invalid email address';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            email = newValue!;
                          },
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          decoration: const InputDecoration(
                            hintText: 'Email Address',
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.black),
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.black),
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.black),
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.trim().length < 6) {
                              return 'password should contain atleast 6 characters';
                            }
                            if (!value.trim().contains(passValid)) {
                              return 'password should contain special characters';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            password = newValue!;
                          },
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Enter Your Password',
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.black),
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.black,
                              ), //<-- SEE HERE
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.black),
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Text(
                        'Forgotten Password?',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1DA1F2),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: _submit,
                        child: Container(
                          height: 50,
                          width: 300,
                          decoration: BoxDecoration(
                              color: const Color(0xff1DA1F2),
                              borderRadius: BorderRadius.circular(100)),
                          child: const Center(
                            child: Text(
                              'Log in',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              RichText(
                text: TextSpan(
                    text: 'Don’t have an account?',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff888888),
                      fontSize: 14.0,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' Sign Up',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xff1DA1F2),
                            fontSize: 14.0,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              //Navigator.pushNamed(context, MyRoute.signUpRoute);
                            })
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
