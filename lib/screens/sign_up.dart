import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

FirebaseAuth _firebase = FirebaseAuth.instance;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  RegExp passValid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");

  String fullName = '';
  String email = '';
  String username = '';
  String password = '';
  bool isLogin = true;

  final _formKey = GlobalKey<FormState>();

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
                'Sign in to Chit Chat',
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
                      CommonTextFormField(
                        hintText: 'Full Name',
                        textCapitalization: TextCapitalization.characters,
                        textInputType: TextInputType.name,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              value != value.toUpperCase()) {
                            return 'name cannot be blank & lowercase';
                          }

                          return null;
                        },
                        onSaved: (name) {
                          fullName = name!;
                        },
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      CommonTextFormField(
                        hintText: 'Email Address',
                        textCapitalization: TextCapitalization.none,
                        textInputType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              !value.contains('@')) {
                            return 'entered invalid email address';
                          }
                          return null;
                        },
                        onSaved: (emailAddress) {
                          email = emailAddress!;
                        },
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      CommonTextFormField(
                        hintText: 'Username',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'name field cannot be blank';
                          }
                          return null;
                        },
                        onSaved: (user) {
                          username = user!;
                        },
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          // controller: passwordController,
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
                            hintText: 'Password',
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
                              ),
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
                              'Sign in',
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
                    text: 'You have an account?',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff888888),
                      fontSize: 14.0,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' Log In',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xff1DA1F2),
                            fontSize: 14.0,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              setState(() {
                                // _isLogin = !_isLogin;
                                // passwordController.clear();
                                // emailController.clear();
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (context) => const SignupScreen(),
                                ));
                              });
                            })
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }

  void _submit() async {
    bool isValid = _formKey.currentState!.validate();

    try {
      if (isValid) {
        _formKey.currentState!.save();
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        debugPrint(userCredentials.toString());
        debugPrint(email);
        debugPrint(password);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'fullname': fullName,
          'username': username,
          'email': email,
          'image': 'imageurl',
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        //...
      }

      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'Authentication Failed'),
          ),
        );
      }
    }
  }
}

class CommonTextFormField extends StatelessWidget {
  final String hintText;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;
  final TextInputType? textInputType;
  final TextCapitalization? textCapitalization;
  const CommonTextFormField({
    super.key,
    required this.hintText,
    this.validator,
    this.onSaved,
    this.textInputType,
    this.textCapitalization,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: TextFormField(
        validator: validator,
        onSaved: onSaved,
        keyboardType: textInputType,
        autocorrect: false,
        textCapitalization: TextCapitalization.none,
        decoration: InputDecoration(
          hintText: hintText,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.black),
            borderRadius: BorderRadius.all(
              Radius.circular(100),
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.black),
            borderRadius: BorderRadius.all(
              Radius.circular(100),
            ),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.black),
            borderRadius: BorderRadius.all(
              Radius.circular(100),
            ),
          ),
        ),
      ),
    );
  }
}
