import 'dart:io';

import 'package:api_course/components/customTextFormField.dart';
import 'package:api_course/components/valid.dart';
import 'package:api_course/constant/linkApi.dart';
import 'package:api_course/main.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../components/crud.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  bool isLoading = false;
  File? myfile = null;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  Crud crud = Crud();

  addNotes() async {
    if (myfile == null)
      return showDialog(
          context: context,
          builder: (context) {
            return BottomSheet(
              builder: (context) => Container(
                alignment: Alignment.center,
                child: Text('please, choose an image'),
                width: double.infinity,
                height: 100,
              ),
              onClosing: () {},
            );
          });

    if (formState.currentState!.validate()) {
      isLoading = true;
      setState(() {});

      var response = await crud.postRequestFile(
          linkAddNotes,
          {
            'id': sharedPref.getString('id'),
            'title': title.text,
            'content': content.text,
          },
          myfile!);
      isLoading = false;
      setState(() {});
      if (response['status'] == 'success') {
        Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
      } else {}
    }
  }

  @override
  void dispose() {
    title.dispose();
    content.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Note')),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(10),
              child: Form(
                key: formState,
                child: ListView(
                  children: [
                    CustomTextFormField(
                      hint: 'Title',
                      myController: title,
                      valid: (val) {
                        return ValidInput(val!, 1, 20);
                      },
                    ),
                    SizedBox(height: 15),
                    CustomTextFormField(
                      hint: 'Content',
                      myController: content,
                      valid: (val) {
                        return ValidInput(val!, 1, 255);
                      },
                    ),
                    SizedBox(height: 15),
                    MaterialButton(
                      child: Text('Choose Image'),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: () async {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => Container(
                                  height: 100,
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          XFile? xfile = await ImagePicker()
                                              .pickImage(
                                                  source: ImageSource.gallery);
                                          Navigator.of(context).pop();

                                          if (xfile != null) {
                                            myfile = File(xfile.path);
                                          }
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: double.infinity,
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            'Gallery',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          XFile? xfile = await ImagePicker()
                                              .pickImage(
                                                  source: ImageSource.camera);
                                          Navigator.of(context).pop();

                                          if (xfile != null) {
                                            myfile = File(xfile.path);
                                          }
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: double.infinity,
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            'Camera',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                      },
                    ),
                    SizedBox(height: 15),
                    MaterialButton(
                      child: Text('Add'),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: () async {
                        await addNotes();
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
