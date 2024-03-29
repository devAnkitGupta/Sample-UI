

import 'dart:core';

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:foods1/help/notes.dart';
import 'dart:developer';

class DatabaseHelper{
  static DatabaseHelper _databaseHelper;
  static Database _database;
  String noteTable = 'note_table';
  String colId = 'id';
  String colname = 'name'; String colprice = 'price';
   String  colcounter = 'counter';

   DatabaseHelper._createInstance();
   factory DatabaseHelper(){
     if(_databaseHelper==null){
       _databaseHelper =DatabaseHelper._createInstance();
     }
     return _databaseHelper;
   }
   Future<Database> get database async{
     if (_database==null){
       _database= await initializeDatabase();
            }
            return _database;
          }
       
   Future<Database> initializeDatabase()async{
     Directory directory = await getApplicationDocumentsDirectory();
     String path = directory.path+'notes.db';
     var notesDatabase =await openDatabase(path,version: 1,onCreate:_createDb);
     return notesDatabase;
   }    
   void _createDb(Database db, int newVersion) async{
     await db.execute('CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colname TEXT,'
     '$colprice INTEGER ,$colcounter INTEGER) ');
   } 
   Future <List<Map<String,dynamic>>> getNoteMapList() async {
     Database db =await this.database;
     var result =await db.query(noteTable,orderBy: '$colId ASC');
     log('data: result');
     return result;

   }

   Future<int> insertNote(Notes note)async{
     Database  db = await this.database;
     var result =await db.insert(noteTable,note.toMap());
     return result;
   }






   Future<int> updateNote(Notes note) async {
     var db =await this.database;
     var result =await db.update(noteTable, note.toMap(),where: "$colId=?",whereArgs: [note.id]);
      return result;
   }
   Future<int> deleteNote (int id) async
{
  var db =await this.database;
  int result =await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
  return result;
}   
Future<int>getCount()async{
  Database db =await this.database;
  List<Map<String,dynamic>> x =await db.rawQuery('SELECT COUNT (*) from $noteTable');
  int result = Sqflite.firstIntValue(x);
  return result;
}
Future<List<Notes>> getNoteList() async {
  var noteMapList =await getNoteMapList();
  int count = noteMapList.length;
  List<Notes> notelist =List<Notes>();
  for(int i=0;i<count;i++){
    notelist.add(Notes.fromMapObjects(noteMapList[i]));
  }
  return notelist;
}





}