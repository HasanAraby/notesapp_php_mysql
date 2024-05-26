import 'package:flutter/material.dart';

class Success extends StatefulWidget {
  const Success({super.key});

  @override
  State<Success> createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Center(
          child: Text('you have signed up successfully'),
        ),
        MaterialButton(
            child: Text('Login'),
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, 'logIn', (route) => false);
            }),
      ]),
    );
  }
}
