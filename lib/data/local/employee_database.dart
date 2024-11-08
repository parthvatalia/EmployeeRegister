import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/employee.dart';

class EmployeeDatabase {
  static final EmployeeDatabase instance = EmployeeDatabase._init();

  static Database? _database;

  EmployeeDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('employees.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE employees (
        id $idType,
        name $textType,
        position $textType,
        joiningDate $textType,
        leavingDate TEXT
      )
    ''');
  }

  Future<int> addEmployee(Employee employee) async {
    final db = await instance.database;
    return await db.insert('employees', employee.toJson());
  }

  Future<List<Employee>> fetchEmployees() async {
    final db = await instance.database;
    final result = await db.query('employees');
    return result.map((json) => Employee.fromJson(json)).toList();
  }

  Future<int> updateEmployee(Employee employee) async {
    final db = await instance.database;
    return await db.update('employees', employee.toJson(),
        where: 'id = ?', whereArgs: [employee.id]);
  }

  Future<int> deleteEmployee(int id) async {
    final db = await instance.database;
    return await db.delete('employees', where: 'id = ?', whereArgs: [id]);
  }
}
