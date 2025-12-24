import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../APP_QUANLICHITIEU/lib/providers/transaction_provider.dart';
import '../APP_QUANLICHITIEU/lib/screens/home_screen.dart';
import '../APP_QUANLICHITIEU/lib/screens/add_transaction_screen.dart';
void main() async {
  // đảm bảo mọi thứ được khởi tạo trước khi chạy
  WidgetsFlutterBinding.ensureInitialized();

  //khởi tạo định dạng ngày tháng
  await initializeDateFormatting('vi_VN',null);
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      // Dùng Consumer để lắng nghe thay đổi chế độ Sáng/Tối
      child: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Quản Lý Thu Chi',

            // Cấu hình chế độ Sáng/Tối
            themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,

            // 1. Giao diện Sáng (Light Mode)
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.light),
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFFC8E6C9), // Xanh nhạt
                foregroundColor: Colors.black, // Chữ đen
              ),
            ),

            // 2. Giao diện Tối (Dark Mode)
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.dark),
              useMaterial3: true,
              scaffoldBackgroundColor: const Color(0xFF121212), // Nền đen dịu
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF1E1E1E), // Đen xám
                foregroundColor: Colors.white, // Chữ trắng
              ),

            ),

            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}