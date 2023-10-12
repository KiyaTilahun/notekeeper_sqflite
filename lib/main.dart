import 'package:flutter/material.dart';
import 'package:data_sql/screens/note_edit.dart';
import 'package:data_sql/screens/notedetail.dart';

void main() {
  runApp( MaterialApp( 
    debugShowCheckedModeBanner: false,
    home: NoteList(),
  ));
}
