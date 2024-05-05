import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_app/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyDXGnwOCXWV89Rby_98uFcuHYUUwSEee9c",
              appId: "1:331194089369:android:fe349635f45992452c5d08",
              messagingSenderId: "331194089369",
              projectId: "todo-list-flutter-8251c",
              storageBucket: "todo-list-flutter-8251c.appspot.com"))
      : await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(MaterialApp(
    home: MyHome(),
    debugShowCheckedModeBanner: false,
  ));
}
