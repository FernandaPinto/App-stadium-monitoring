import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:stadium_monitoring/login.dart';

Future<String> readData(String sensor) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref("components/$sensor");

  Stream<DatabaseEvent> stream = ref.onValue;

  Completer<String> completer = Completer<String>();

  stream.listen((DatabaseEvent event) {
    print('Event Type: ${event.type}'); // DatabaseEventType.value;
    print('Snapshot: ${event.snapshot.value}'); // DataSnapshot
    completer.complete(event.snapshot.value.toString());
  });
  return completer.future;
}

Future<void> sendData(String sensor, int value) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref("components/$sensor");
  try {
    await ref.set(value);
    print("Data sent successfully: $value");
  } catch (e) {
    print("Failed to send data: $e");
  }
}

Future<void> registerUser(BuildContext context, String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginApp()),
    );
  } on FirebaseAuthException catch (e) {
    QuickAlert.show(
      context: context,
      borderRadius: 2,
      type: QuickAlertType.error,
      title: 'Oops...',
      text: 'Error creating account',
    );
  } catch (e) {
    QuickAlert.show(
      context: context,
      borderRadius: 2,
      type: QuickAlertType.error,
      title: 'Oops...',
      text: 'An unexpected error occurred',
    );
    print(e);
  }
}
