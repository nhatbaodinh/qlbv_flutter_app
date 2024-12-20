import 'package:flutter/material.dart';
import 'package:qlbv_flutter_app/main.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  // Hàm xử lý đăng ký (tạm thời chỉ in thông tin)
  void handleRegister() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final username = usernameController.text.trim();

    if (email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin!')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu và xác nhận mật khẩu không khớp!')),
      );
      return;
    }

    try {
      // Gửi yêu cầu đăng ký tới Supabase
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Lưu tên người dùng vào bảng dữ liệu (nếu có bảng tùy chỉnh)
        final profileResponse = await supabase.from('profiles').insert({
          'id': response.user!.id, // Ensure the user ID is not null
          'username': username,
          'email': email,
        });

        if (profileResponse.error == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đăng ký thành công!')),
          );

          // Điều hướng quay lại trang đăng nhập
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lưu thông tin thất bại')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng ký thất bại')),
        );
      }
    }
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng ký thất bại: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
          'Đăng Ký',
          style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Input Tên người dùng
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Tên người dùng',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),

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

              // Input Xác nhận mật khẩu
              TextField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Xác nhận mật khẩu',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),

              // Nút Đăng ký
              ElevatedButton(
                onPressed: handleRegister,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text('Đăng Ký', style: TextStyle(fontSize: 18)),
              ),

              // Nút Quay lại Đăng nhập
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Quay lại trang đăng nhập
                },
                child: const Text('Đã có tài khoản? Đăng nhập ngay!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}