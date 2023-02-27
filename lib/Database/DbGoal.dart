import 'dart:io';
import 'package:money_bank/Model/Goal.dart';
import 'package:money_bank/Model/History.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SqlHelper{

  static SqlHelper? sqlHelper;
  static Database? _database;

  SqlHelper._createInstance();

  factory SqlHelper(){
    if(sqlHelper==null){
      sqlHelper=SqlHelper._createInstance();
    }
    return sqlHelper!;
  }

  final String GoalS="Goal";
  final String HistoryS="History";
  void createTables(Database db, int version)async{
    await db.execute("CREATE TABLE $GoalS(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, goal REAL, currentGoal REAL, date TEXT)");
    await db.execute("CREATE TABLE $HistoryS(id INTEGER PRIMARY KEY AUTOINCREMENT, goalId INTEGER, date TEXT, deposit REAL)");
  }
  
  Future<Database> initDatabase()async{
    Directory directory=await getApplicationDocumentsDirectory();
    String path=directory.path+"goals.db";
    var goalDatabase=await openDatabase(path, version: 1, onCreate: createTables);
    return goalDatabase;
  }
  
  Future<Database> get database async{
    if(_database==null){
      _database=await initDatabase();
    }
    return _database!;
  }
  
  Future<List<Map<String, dynamic>>> getGoalMapList() async{
    Database db=await this.database;
    var result=await db.rawQuery("SELECT * FROM $GoalS ORDER BY id ASC");
    return result;
  }
  
  Future<int> insertGoal(Goal goal)async{
    Database db=await this.database;
    var result = await db.insert(GoalS, goal.toMap());
    return result;
  }
  Future<int> updateGoal(Goal goal)async{
    Database db=await this.database;
    int result = await db.update(GoalS, goal.toMap(), where: "id = ?", whereArgs: [goal.id]);
    return result;
  }
  Future<int> deleteGoal(int id)async{
    Database db=await this.database;
    int result=await db.rawDelete("DELETE FROM $GoalS WHERE id = $id");
    return result;
  }
  Future<int?> getCount()async{
    Database db=await this.database;
    List<Map<String, dynamic>> all=await db.rawQuery("SELECT COUNT (*) FROM $GoalS");
    int? result=Sqflite.firstIntValue(all);
    return result;
  }

  Future<List<Goal>> getGoalList()async{
    var goalMapList=await getGoalMapList();
    int count = goalMapList.length;
    List<Goal> goals=<Goal>[];
    for(int x =0; x<count; x++){
      goals.add(Goal.getMap(goalMapList[x]));
    }
    return goals;
  }


  Future<List<Map<String, dynamic>>> getHistoryMapList(int id) async {
    Database db = await this.database;
    var result =  await db.rawQuery("SELECT * FROM $HistoryS WHERE goalId = $id ORDER BY id ASC");
    return result;
  }
  Future<int> insertHistory(History history)async{
    var db=await this.database;
    var result=db.insert(HistoryS, history.toMap());
    return result;
  }
  Future<int> deleteHistory(int id)async{
    Database db=await this.database;
    int result=await db.rawDelete("DELETE FROM $HistoryS WHERE id = $id");
    return result;
  }
  Future<int> deleteAllHistory(int GoalId)async{
    Database db=await this.database;
    int result=await db.rawDelete("DELETE FROM $HistoryS WHERE goalId = $GoalId");
    return result;
  }
  Future<List<History>> getHistoryList(int GoalId) async{

    var historyMapList = await getHistoryMapList(GoalId);
    int count = historyMapList.length;
    List<History> students = <History>[];
    for (int i = 0; i <= count -1; i++){
      students.add(History.getMap(historyMapList[i]));
    }
    return students;
  }

}