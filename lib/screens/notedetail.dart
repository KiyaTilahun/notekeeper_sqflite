// ignore_for_file: prefer_const_constructors, prefer_conditional_assignment

import 'package:flutter/material.dart';
import 'package:data_sql/screens/note_edit.dart';
import 'package:data_sql/models/note.dart';
import 'package:data_sql/utils/database_utils.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {
  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note>? noteList;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = <Note>[];
      updateListView();
    }

    return Scaffold(
        appBar: AppBar(title: Text("Notes")),
        body: getNoteListView(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigatorDetail(Note('', '', 2, ''), "Add note");
          },
          child: Icon(Icons.add),
        ));
  }

  ListView getNoteListView(BuildContext context) {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                  backgroundColor:
                      getpriority(this.noteList![position].priority)),
              title: Text(this.noteList![position].title),
              subtitle: Text(this.noteList![position].date),
              trailing: GestureDetector(
                  child: Icon(Icons.delete, color: Colors.grey)),
              onTap: () {
                _delete(context, noteList![position]);
              },
            ),
          );
        });
  }

  // returns the priority color
  Color getpriority(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;
    }
  }

  Icon returnIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;
      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  // delete method
  void _delete(BuildContext context, Note note) async {
    int? result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showsnackbar(context, 'Note Deleted Successfuly');
      updateListView();
    }
  }

  void _showsnackbar(BuildContext context, String message) {
    final snack = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  void navigatorDetail(Note note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));
    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((value) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((value) {
        setState(() {
          this.noteList = value;
          this.count = value.length;
        });
      });
    });
  }
}
