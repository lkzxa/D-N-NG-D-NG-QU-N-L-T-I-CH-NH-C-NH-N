import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';
import 'package:path/path.dart';
import '../models/transaction_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  //lấy database ra dùng nếu chưa có (null) thì tạo mới, có rồi thì trả về
  Future<Database> get database async {
    if (_database != null) return _database!;

    //nếu chưa có thì khởi tạo
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    //1 tìm đuognừ dẫn an toàn trên đt để lưu file
    String path = join(await getDatabasesPath(), 'thuchi.db');

    //2 mở database
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate, // gọi hàm bên dưới
    );
  }

  //hàm tạo bảng
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        amount REAL,
        date TEXT,
        isExpense INTEGER
      )
    ''');
  }

  //CÁC HÀM XỬ LÍ DỮ LIỆU
  //1. THÊM GIAO DỊCH MỚI
  Future<int> insertTransaction(TransactionModel transaction) async {
    Database db = await database; //lấy kêt nối
    //gọi lenehjj insert , chuyển object -> map để lưuu
    return await db.insert('transactions', transaction.toMap());
  }

  //2 lấy toàn bộ danh sách giao dịch
  Future<List<TransactionModel>> getTransactions() async {
    Database db = await database;

    //lấy dữ liệu và sắp xếp theo ngày giảm dần
    final List<Map<String, dynamic>> maps = await db.query('transactions',orderBy:'date DESC');
    
    //chuyển đổi ngược lại từ list<map>sang list<transactionModel>
    return List.generate(maps.length, (i){
      return TransactionModel.fromMap(maps[i]);
    });
  }
  //3 xóa giao dịch
  Future<int> deleteTransaction(int id) async{
    Database db = await database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  // 4. Cập nhật giao dịch (Sửa)
  Future<int> updateTransaction(TransactionModel transaction) async {
    Database db = await database;
    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }
}
