import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  // Thêm biến này để nhận dữ liệu cũ nếu là chế độ Sửa
  final TransactionModel? transaction;

  const AddTransactionScreen({super.key, this.transaction});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  String _enteredTitle = '';
  String _enteredAmount = '';
  DateTime _selectedDate = DateTime.now();
  bool _isExpense = true;
  final _titleController = TextEditingController(); // Controller cho ô nhập
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Nếu có dữ liệu truyền vào -> Đây là chế độ SỬA -> Điền sẵn dữ liệu cũ
    if (widget.transaction != null) {
      _enteredTitle = widget.transaction!.title;
      _enteredAmount = widget.transaction!.amount.toInt().toString();
      _selectedDate = widget.transaction!.date;
      _isExpense = widget.transaction!.isExpense;

      // Gán vào controller để hiện lên ô nhập
      _titleController.text = _enteredTitle;
      _amountController.text = _enteredAmount;
    }
  }

  void _submitData() {
    if (_enteredTitle.isEmpty) return;
    final enteredAmount = double.tryParse(_enteredAmount) ?? 0;
    if (enteredAmount <= 0) return;

    final provider = Provider.of<TransactionProvider>(context, listen: false);

    if (widget.transaction == null) {
      // --- THÊM MỚI ---
      provider.addTransaction(TransactionModel(
        title: _enteredTitle,
        amount: enteredAmount,
        date: _selectedDate,
        isExpense: _isExpense,
      ));
    } else {
      // --- CẬP NHẬT (SỬA) ---
      // Giữ nguyên ID cũ
      provider.updateTransaction(TransactionModel(
        id: widget.transaction!.id,
        title: _enteredTitle,
        amount: enteredAmount,
        date: _selectedDate,
        isExpense: _isExpense,
      ));
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        // Đổi tiêu đề tùy theo chế độ
        title: Text(widget.transaction == null ? "Thêm Giao Dịch" : "Sửa Giao Dịch"),
        backgroundColor: _isExpense ? Colors.red.shade100 : Colors.green.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Autocomplete<String>(
              optionsBuilder: (v) => v.text.isEmpty ? [] : provider.titleSuggestions.where((e) => e.toLowerCase().contains(v.text.toLowerCase())),
              onSelected: (val) => _enteredTitle = val,
              fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                // Nếu là lần đầu mở form sửa, dùng controller riêng để hiện text cũ
                if (controller.text.isEmpty && _enteredTitle.isNotEmpty) {
                  controller.text = _enteredTitle;
                }
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(labelText: 'Tiêu đề'),
                  onChanged: (val) => _enteredTitle = val,
                );
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Số tiền'),
              keyboardType: TextInputType.number,
              onChanged: (val) => _enteredAmount = val,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text("Loại: "),
                Switch(
                  value: _isExpense,
                  activeColor: Colors.red,
                  inactiveThumbColor: Colors.green,
                  onChanged: (val) => setState(() => _isExpense = val),
                ),
                Text(_isExpense ? "Chi Tiêu" : "Thu Nhập", style: TextStyle(color: _isExpense ? Colors.red : Colors.green, fontWeight: FontWeight.bold)),
                const Spacer(),
                TextButton.icon(
                  onPressed: () async {
                    final picked = await showDatePicker(
                        context: context, initialDate: _selectedDate, firstDate: DateTime(2020), lastDate: DateTime.now()
                    );
                    if (picked != null) setState(() => _selectedDate = picked);
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submitData,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor, padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50)),
              child: Text(
                widget.transaction == null ? "LƯU" : "CẬP NHẬT", // Đổi tên nút
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}