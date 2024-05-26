import 'dart:io';

import 'package:api_course/components/customTextFormField.dart';
import 'package:api_course/components/valid.dart';
import 'package:api_course/constant/linkApi.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../components/crud.dart';

class EditNotes extends StatefulWidget {
  final notes;
  const EditNotes({super.key, this.notes});

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  File? myfile;
  bool isLoading = false;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  Crud crud = Crud();

  editNotes() async {
    if (formState.currentState!.validate()) {
      isLoading = true;
      setState(() {});

      var response;

      if (myfile == null) {
        response = await crud.postRequest(linkEditNotes, {
          'id': widget.notes['notes_id'].toString(),
          'title': title.text,
          'content': content.text,
          'imagename': widget.notes['image_id'].toString(),
        });
      } else {
        response = await crud.postRequestFile(
            linkEditNotes,
            {
              'id': widget.notes['notes_id'].toString(),
              'title': title.text,
              'content': content.text,
              'imagename': widget.notes['image_id'].toString(),
            },
            myfile!);
      }

      isLoading = false;
      setState(() {});
      if (response['status'] == 'success') {
        Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          body: Text('check your connection'),
        )..show();
      }
    }
  }

  @override
  void initState() {
    title.text = widget.notes['notes_title'];
    content.text = widget.notes['notes_content'];
    super.initState();
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
      appBar: AppBar(title: Text('Edit Note')),
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
                      child: Text('Save'),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: () async {
                        await editNotes();
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
