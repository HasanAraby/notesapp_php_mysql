import 'package:api_course/components/crud.dart';
import 'package:api_course/components/customTextFormField.dart';
import 'package:api_course/components/valid.dart';
import 'package:api_course/constant/linkApi.dart';
import 'package:api_course/main.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;

  Crud _crud = Crud();
  login() async {
    if (formState.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var response = await _crud.postRequest(linkLogIn, {
        'email': email.text,
        'password': password.text,
      });
      isLoading = false;
      setState(() {});

      if (response['status'] == 'success') {
        sharedPref.setString('id', response['data']['id'].toString());
        sharedPref.setString(
            'username', response['data']['username'].toString());
        sharedPref.setString('email', response['data']['email'].toString());
        Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
      } else {
        AwesomeDialog(
          context: context,
          title: 'warning',
          body: Text('email or password is wrong'),
        )..show();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: [
                  Form(
                      key: formState,
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            height: 200,
                            width: 200,
                          ),
                          CustomTextFormField(
                              hint: 'email',
                              myController: email,
                              valid: (val) {
                                return ValidInput(val!, 3, 20);
                              }),
                          CustomTextFormField(
                              hint: 'password',
                              myController: password,
                              valid: (val) {
                                return ValidInput(val!, 3, 10);
                              }),
                          MaterialButton(
                            color: Colors.blue,
                            textColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 70, vertical: 10),
                            child: Text('Login'),
                            onPressed: () async {
                              await login();
                            },
                          ),
                          Container(height: 10),
                          InkWell(
                            child: Text('Sign Up'),
                            onTap: () {
                              Navigator.of(context).pushNamed('signUp');
                            },
                          ),
                        ],
                      ))
                ],
              ),
      ),
    );
  }
}
