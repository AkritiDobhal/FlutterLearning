import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_firebase/screens/auth_screen.dart';
import 'package:todo_firebase/screens/home.dart';

//void main() => runApp(MyApp());

bool shouldUseFirebaseEmulator = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.purple,
          colorScheme: ColorScheme.dark(
            surface: Colors.purple,
          ),
        ),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final user = FirebaseAuth.instance.currentUser;
                if (user != '') {
                  return Home();
                } else {
                  return AuthScreen();
                }
              } else {
                return AuthScreen();
              }
            }));
  }
}
