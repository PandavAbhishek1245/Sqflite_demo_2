
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_demo2/Model.dart';
import 'package:sqflite_demo2/constant.dart';
import 'package:path/path.dart';

class FirstScreenController extends GetxController{

  var model =<Modelclass>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    creatDatebase();
    super.onInit();
  }

  Future<void>creatDatebase()async {
    var databasespath = await getDatabasesPath();
    String path = join(databasespath , "${databaseName}");
    await openDatabase(path,version: version,
    onCreate: (Database db,int version)async{
      printInfo(info: "db:"+db.toString());
      await db.execute("CREATE TABLE  $tblName("
          "$columnId TEXT PRIMARY KEY,"
           "$columnImage TEXT NOT NULL,"
          "$columnName TEXT NOT NULL,"
          "$columnDescription TEXT NOT NULL,"
          "$columnDate  TEXT NOT NULL"
      ")");
    });
    getTodo();
  }


  void adddata({
    required String image,
  required String name,
  required String  desc,
  required String date,
}){
    var todo = Modelclass(
      id: (model.length+1).toString(),
      image : image,
      name: name,
      desc: desc,
      date: date,
    );
    insertData(todo);
  }

  Future<void>insertData(Modelclass todo)async{
    var databasespath = await getDatabasesPath();
    String path =join(databasespath , "${databaseName}");
    final db = await openDatabase(path);

    print("Hello"+todo.toJson().toString());
    await db.insert(tblName, todo.toJson());

    getTodo();
  }


  Future<void>getTodo()async{
    model.clear();
    var datebasespath = await getDatabasesPath();
    String path = join(datebasespath,"${databaseName}");
    final db = await openDatabase(path, version: version);

    final List<Map<String,dynamic>>maps=await db.query(tblName);
    model.addAll(maps.map((value) => Modelclass.fromJson(value)).toList());
    print("LENGHT::::${model.length}");

  }

  updateTodo(Modelclass todo) async {
    print(todo.id);
    var datebasesPath = await getDatabasesPath();
    String path= join(datebasesPath,"${databaseName}");
    final db= await openDatabase(path);

    await db.update(tblName,
    todo.toJson(),
      where: "$columnId=?",
      whereArgs: [todo.id],
    );
    getTodo();
    return todo;

  }

  deleteTodo({String? id}) async {
    var datebasesPath = await getDatabasesPath();
    String path= join(datebasesPath,"${databaseName}");
    final db = await openDatabase(path);

    getTodo();
    return await db.delete(tblName,where: "$columnId = ? ",whereArgs: [id]);
  }


}