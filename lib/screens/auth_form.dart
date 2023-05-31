import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/utility_services.dart';
import 'auth_screen.dart';

class AuthForm extends StatefulWidget {
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  final _formKey = GlobalKey<FormState>();
  String _username = "";
  String _email = "";
  String _pass = "";
  FirebaseUtilityServices services = FirebaseUtilityServices();

  authRegister() async {
    final validity = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    if (validity != null && validity) {
      _formKey.currentState?.save();
      await services.userRegister(_email, _pass, _username, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Register'), automaticallyImplyLeading: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter Username";
                    }
                  },
                  onSaved: (value) {
                    _username = value!;
                  },
                  decoration: InputDecoration(
                      hintText: "User Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide()),
                      filled: true,
                      alignLabelWithHint: true),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter Email";
                    } else if (!value.contains('@')) {
                      return "Please enter valid Email";
                    }
                  },
                  onSaved: (value) {
                    _email = value!;
                  },
                  decoration: InputDecoration(
                      hintText: "Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide()),
                      filled: true,
                      alignLabelWithHint: true),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter Password";
                    }
                  },
                  onSaved: (value) {
                    _pass = value!;
                  },
                  decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide()),
                      filled: true,
                      alignLabelWithHint: true),
                ),
                const SizedBox(height: 10),
                Container(
                    width: double.infinity,
                    height: 50,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(50)),
                    child: ElevatedButton(
                      onPressed: onPressed,
                      child: const Text(
                        'Register',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    )),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already a Member'),
                    TextButton(
                        child: const Text('Login'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AuthScreen()));
                        }),
                  ],
                )
              ],
            )),
      ),
    );
  }

  onPressed() async {
    // ignore: void_checks
    await authRegister();
  }
}
