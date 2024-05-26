import 'package:api_course/constant/linkApi.dart';
import 'package:api_course/model/noteModel.dart';
import 'package:flutter/material.dart';

class CardNote extends StatelessWidget {
  final void Function()? ontap;
  final void Function()? delNote;
  final NoteModel noteModel;
  const CardNote(
      {super.key,
      required this.ontap,
      required this.noteModel,
      required this.delNote});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                flex: 1,
                child: Image.network(
                  '${linkImageRoot}/${noteModel.imageId}',
                  height: 100,
                  width: 100,
                  fit: BoxFit.fill,
                )),
            Expanded(
                flex: 2,
                child: ListTile(
                  title: Text(noteModel.notesTitle!),
                  subtitle: Text(noteModel.notesContent!),
                  trailing: IconButton(
                    onPressed: delNote,
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
