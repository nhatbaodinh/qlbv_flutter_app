import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_page.dart';
import 'products_page.dart';
import 'login_page.dart';

import 'main_layout.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://yynjhshdaxzftlfafsko.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl5bmpoc2hkYXh6ZnRsZmFmc2tvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzIyMzY2MTQsImV4cCI6MjA0NzgxMjYxNH0.dlcJbqSCR75g0sgr7CLdtjNN_keldOJyebnX-cC1ka4',
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainLayout(
        pages: [
          HomePage(),
          ProductsPage(),
          LoginPage(),
        ],
        navItems: [
          BottomNavigationBarItem(
            label: "Trang chủ",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "Vé",
            icon: Icon(Icons.airplane_ticket),
          ),
          BottomNavigationBarItem(
            label: "Đăng nhập",
            icon: Icon(Icons.login),
          ),
        ],
      ),
    );
  }
}
