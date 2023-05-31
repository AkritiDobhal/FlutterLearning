import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_firebase/screens/auth_screen.dart';
import 'package:todo_firebase/screens/home.dart';

class FirebaseUtilityServices {
  FirebaseAuth _auth = FirebaseAuth.instance;

  //User Register in Firebase
  Future userRegister(
      String email, String pass, String username, BuildContext context) async {
    _auth
        .createUserWithEmailAndPassword(email: email, password: pass)
        .then((value) {
      final user = _auth.currentUser?.uid;
      FirebaseFirestore.instance
          .collection('Users')
          .doc(user)
          .set({"username": username, "email": email, "password": pass});
      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => const Home())));
    }).onError((error, stackTrace) {
      errorMsg((error as FirebaseAuthException).message.toString(), context);
    }).catchError((error) {
      errorMsg((error as FirebaseAuthException).message.toString(), context);
    });
  }

  Future login(String email, String pass, BuildContext context) async {
    await _auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((value) {
      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => Home())));
    }).onError((error, stackTrace) {
      errorMsg((error as FirebaseAuthException).message.toString(), context);
    }).catchError((error) {
      errorMsg((error as FirebaseAuthException).message.toString(), context);
    });
  }

  Future logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: ((context) => AuthScreen())));
  }

  //Showing Error Message
  errorMsg(String message, BuildContext context) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.black45,
    );
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  addTask(String title, String description, BuildContext context) async {
    final user = await _auth.currentUser?.uid;
    var dateTime = DateTime.now();
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(user)
        .collection('mytask')
        .doc(dateTime.toString())
        .set({
      'title': title,
      'description': description,
      'time': dateTime.toString(),
      'timestamp': dateTime
    });
    final snackBar = SnackBar(
      content: Text(
        "Data saved successfully",
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.black45,
    );
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
