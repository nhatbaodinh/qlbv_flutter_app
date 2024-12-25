import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:qlbv_flutter_app/product_detail_page.dart';
import 'package:qlbv_flutter_app/register_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'cart_controller.dart';
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
final user = Supabase.instance.client.auth.currentUser;
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      initialBinding: CartBinding() ,
      debugShowCheckedModeBanner: false,
      home: const MainLayout(
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
            label: "Sản phẩm",
            icon: Icon(Icons.shopping_cart),
          ),
          BottomNavigationBarItem(
            label: "Đăng nhập" ,
            icon:  Icon(Icons.login),
          ),
        ],
      ),
    );
  }
}
