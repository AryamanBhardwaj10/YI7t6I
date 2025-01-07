import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:internshala_assignment/firebase_options.dart';
import 'package:internshala_assignment/home_page.dart';
import 'package:internshala_assignment/theme/my_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: HomePage(),
    );
  }
}
