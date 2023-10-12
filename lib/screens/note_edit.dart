// ignore_for_file: prefer_const_constructors, unused_field

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:data_sql/screens/note_edit.dart';
import 'package:data_sql/models/note.dart';
import 'package:data_sql/utils/database_utils.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget {
  late String appBarTitle;
  final Note note;
  NoteDetail(this.note, this.appBarTitle);

  @override
  State<NoteDetail> createState() =>
      _NoteDetailState(this.note, this.appBarTitle);
}

class _NoteDetailState extends State<NoteDetail> {
  late String appBarTitle;

  static var _priorities = ['High', 'Low'];
  DatabaseHelper helper = DatabaseHelper();
  Note? note;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  _NoteDetailState(this.note, this.appBarTitle);
  @override
  Widget build(BuildContext context) {
    titleController.text = note!.title;
    descriptionController.text = note!.description;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_left)),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: [
              ListTile(
                title: DropdownButton(
                  items: _priorities.map((e) {
                    return DropdownMenuItem(
                      child: Text(e),
                      value: e,
                    );
                  }).toList(),
                  value: getpriority(note!.priority),
                  onChanged: (value) {
                    setState(() {
                      debugPrint('User selected $value ');
                      updatePriority(value!);
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: TextField(
                  controller: titleController,
                  onChanged: (value) {
                    debugPrint("something enterd");
                    updateTitle();
                  },
                  decoration: InputDecoration(
                      labelText: "Title",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: TextField(
                  controller: descriptionController,
                  onChanged: (value) {
                    debugPrint("something description enterd");
                    updateDescription();
                  },
                  decoration: InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              _save();
                            },
                            child: Text('save'))),
                    Container(
                      width: 5.0,
                    ),
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              _delete();
                            },
                            child: Text('delete')))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void movetolast() {
    Navigator.pop(context, true);
  }

  void updatePriority(String value) {
    switch (value) {
      case 'High':
        note!.priority = 1;
        break;
      case 'Low':
        note!.priority = 2;
        break;
    }
  }

  String getpriority(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0];

        break;
      case 2:
        priority = _priorities[1];
        break;
      default:
        priority = "High";
    }
    return priority;
  }

  void updateTitle() {
    note!.title = titleController.text;
  }

  void updateDescription() {
    note!.description = descriptionController.text;
  }

  void _delete() async {
  
    if (note!.id == null) {
      _showAlterDialog("status", "No Note was deleted");
      return;
    }
    int? result = await helper.deleteNote(note!.id);
    if (result != 0) {
      _showAlterDialog("status", " Note was deleted");
    } else {
      _showAlterDialog("status", "Error while deleting");
    }
      movetolast();
  }

  void _save() async {
    note!.date = DateFormat.yMMMd().format(DateTime.now());
    int? result;
    if (note!.id != null) {
      result = await helper.updateNote(note!);
    } else {
      result = await helper.insertNote(note!);
    }
    if (result != 0) {
      _showAlterDialog('status', 'Note saved Successuffly');
    } else {
      _showAlterDialog('status', 'Problems saving Note');
    }
    movetolast();
  }

  void _showAlterDialog(String title, String Message) {
    AlertDialog aldialog = AlertDialog(
      title: Text(title),
      content: Text(Message),
    );
    showDialog(context: context, builder: (_) => aldialog);
  }
}
