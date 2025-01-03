import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qlbv_flutter_app/home_page.dart';
import 'package:qlbv_flutter_app/main.dart';
import 'package:qlbv_flutter_app/main_layout.dart';
import 'package:qlbv_flutter_app/products_page.dart';
import 'package:qlbv_flutter_app/register_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'cart_controller.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Hàm xử lý đăng nhập (tạm thời chỉ in thông tin)
  void handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final CartController cartController = Get.find<CartController>();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin!')),
      );
      return;
    }

    try {
      // Đăng nhập vào Supabase
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // Kiểm tra kết quả đăng nhập
      if (response.session != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng nhập thành công!')),
        );
        cartController.clearCart();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainLayout(
            pages: const [
              HomePage(),
              ProductsPage(),
              LoginPage()
            ],
            navItems: [
              const BottomNavigationBarItem(
                label: "Trang chủ",
                icon: Icon(Icons.home),
              ),
              const BottomNavigationBarItem(
                label: "Sản phẩm",
                icon: Icon(Icons.shopping_cart),
              ),
              BottomNavigationBarItem(
                label: "Đăng nhập",
                icon: Icon(Icons.login),
              ),
            ],
          )),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tài khoản không tồn tại hoặc mật khẩu sai!')),
        );
      }
    } on AuthException catch (e) {
      // Lỗi xác thực từ Supabase
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng nhập thất bại: ${e.message}')),
      );
    } catch (e) {
      // Lỗi khác
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Có lỗi xảy ra. Vui lòng thử lại sau!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tiêu đề trang đăng nhập
            const Text(
              'Đăng Nhập',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Input Email
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Input Mật khẩu
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Mật khẩu',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),

            // Nút Đăng nhập
            ElevatedButton(
              onPressed: handleLogin,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Đăng Nhập', style: TextStyle(fontSize: 18)),
            ),

            // Nút Đăng ký
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Text('Chưa có tài khoản? Đăng ký ngay!'),
            ),
          ],
        ),
      ),
    );
  }
}