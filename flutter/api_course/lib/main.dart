import 'package:api_course/app/auth/logIn.dart';
import 'package:api_course/app/auth/signUp.dart';
import 'package:api_course/app/auth/success.dart';
import 'package:api_course/app/home.dart';
import 'package:api_course/app/notes/add.dart';
import 'package:api_course/app/notes/edit.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPref;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPref = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: sharedPref.getString('id') == null ? 'logIn' : 'home',
      routes: {
        'home': (context) => Home(),
        'logIn': (context) => LogIn(),
        'signUp': (context) => SignUp(),
        'success': (context) => Success(),
        'addNotes': (context) => AddNotes(),
        'editNotes': (context) => EditNotes(),
      },
      theme: ThemeData(
          appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue,
      )),
    );
  }
}
