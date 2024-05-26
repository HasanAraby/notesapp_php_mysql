import 'package:api_course/app/notes/edit.dart';
import 'package:api_course/components/cardNote.dart';
import 'package:api_course/components/crud.dart';
import 'package:api_course/constant/linkApi.dart';
import 'package:api_course/main.dart';
import 'package:api_course/model/noteModel.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Crud crud = Crud();
  getNotes() async {
    var response = await crud.postRequest(linkViewNotes, {
      'id': sharedPref.getString('id'),
    });
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home'),
        actions: [
          IconButton(
              onPressed: () {
                sharedPref.clear();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('logIn', (route) => false);
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('addNotes');
        },
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(children: [
          FutureBuilder(
            future: getNotes(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                // if no items
                if (snapshot.data['status'] == 'fail')
                  return Center(
                    child: Text('no data, empty'),
                  );
                return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data['data'].length,
                    itemBuilder: (context, i) {
                      return CardNote(
                          ontap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditNotes(
                                    notes: snapshot.data['data'][i])));
                          },
                          noteModel:
                              NoteModel.fromJson(snapshot.data['data'][i]),
                          delNote: () async {
                            var response =
                                await crud.postRequest(linkDeleteNotes, {
                              'id': snapshot.data['data'][i]['notes_id']
                                  .toString(),
                              'imagename': snapshot.data['data'][i]['image_id']
                                  .toString(),
                            });
                            if (response['status'] == 'success') {
                              Navigator.of(context)
                                  .pushReplacementNamed('home');
                            } else {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                body: Text('check your connection'),
                              )..show();
                            }
                          });
                    });
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Text('Loading...'),
                );
              }
              return Center(
                child: Text('Loading...'),
              );
            },
          ),
        ]),
      ),
    );
  }
}
