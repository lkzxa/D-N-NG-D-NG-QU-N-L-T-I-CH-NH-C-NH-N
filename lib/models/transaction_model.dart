import 'package:sqflite/sqflite.dart';

class TransactionModel {
  final int? id; // ID riêng của gaio dịch
  final String title; // Tên giao dịch
  final double amount; // Sô tiền
  final DateTime date; // ngày tháng giao dịch
  final bool isExpense; // chi thay thu (true = CHI false = thu)

  //hàm khởi tạo ( constructor)--- để khởi tạo 1 giao dịch mới
  TransactionModel(
      {this.id, required this.title, required this.amount, required this.date, required this.isExpense});

  // hàm 1 đóng gói( dùng khi lưu database
// Database SQLite chỉ hiểu: Số và Chữ. Nó không hiểu "DateTime" hay "Object".
// Hàm này giúp biến đổi dữ liệu phức tạp thành dạng Map (giống file Excel) để Database hiểu.}
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      // đổi ngày tháng thành chữ
      'isExpense': isExpense ? 1 : 0,
    };
  }

//hàm 2 mở gói( khi ly từ databa ra)
// Hàm 2: Mở gói (Sửa lại đoạn này)
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      title: map['title'],

      // Sửa 1: Dùng (map['amount'] as num).toDouble() để tránh lỗi nếu số tiền là số chẵn
      amount: (map['amount'] as num).toDouble(),

      date: DateTime.parse(map['date']),

      // Sửa 2 (QUAN TRỌNG NHẤT): Thêm "== 1" để đổi số 1 thành True
      isExpense: map['isExpense'] == 1,
    );
  }
}