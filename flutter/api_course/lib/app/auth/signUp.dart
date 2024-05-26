import 'package:api_course/components/crud.dart';
import 'package:api_course/components/customTextFormField.dart';
import 'package:api_course/components/valid.dart';
import 'package:api_course/constant/linkApi.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController userName = TextEditingController();
  bool isLoading = false;
  Crud _crud = Crud();
  signUp() async {
    if (formState.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var response = await _crud.postRequest(linkSignUp, {
        "username": userName.text,
        "email": email.text,
        "password": password.text
      });
      isLoading = false;
      setState(() {});
      if (response['status'] == 'success') {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('success', (route) => false);
      } else {
        print("sign up failed");
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(10),
              child: ListView(
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
                              hint: 'userName',
                              myController: userName,
                              valid: (val) {
                                return ValidInput(val!, 3, 20);
                              }),
                          CustomTextFormField(
                              hint: 'email',
                              myController: email,
                              valid: (val) {
                                return ValidInput(val!, 5, 40);
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
                            child: Text('Sign Up'),
                            onPressed: () async {
                              await signUp();
                            },
                          ),
                          Container(height: 10),
                          InkWell(
                            child: Text('Login'),
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacementNamed('logIn');
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
