import 'package:flutter/material.dart';
import 'package:todo_firebase/screens/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_firebase/services/utility_services.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _pass = "";

  FirebaseUtilityServices utility = FirebaseUtilityServices();

  authLogin() {
    final validity = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    if (validity != null && validity) {
      _formKey.currentState?.save();
      utility.login(_email, _pass, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Login"), automaticallyImplyLeading: false),
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
                            borderSide: BorderSide()),
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
                            borderSide: BorderSide()),
                        filled: true,
                        alignLabelWithHint: true),
                  ),
                  const SizedBox(height: 10),
                  Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50)),
                      child: ElevatedButton(
                        onPressed: () {
                          authLogin();
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      )),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Not a Member'),
                      TextButton(
                          child: const Text('Register'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AuthForm()));
                          }),
                    ],
                  )
                ],
              )),
        ));
  }
}
