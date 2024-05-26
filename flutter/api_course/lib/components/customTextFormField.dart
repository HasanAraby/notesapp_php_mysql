import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hint;
  final String? Function(String?) valid;
  final TextEditingController myController;
  const CustomTextFormField(
      {super.key,
      required this.hint,
      required this.myController,
      required this.valid});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: TextFormField(
        validator: valid,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          hintText: hint,
        ),
        controller: myController,
      ),
    );
  }
}
