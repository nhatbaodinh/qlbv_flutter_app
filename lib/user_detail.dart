import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlbv_flutter_app/user_model.dart';


class UserDetailPage extends StatelessWidget {
  final Users user;

  UserDetailPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông Tin Người Dùng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị tên đầy đủ
            Text(
              'Tên: ${user.fullname}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Hiển thị email
            Text(
              'Email: ${user.email}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),

            // Hiển thị giới tính
            Text(
              'Giới tính: ${user.sex ? 'Nam' : 'Nữ'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),

            // Hiển thị địa chỉ
            Text(
              'Địa chỉ: ${user.address}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),

            // Hiển thị số điện thoại
            Text(
              'Số điện thoại: ${user.phoneNumber}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),

            // Hiển thị vai trò
            Text(
              'Vai trò: ${user.role}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Nút để sửa thông tin người dùng
            ElevatedButton(
              onPressed: () {
                // Mở trang sửa thông tin người dùng (ví dụ: UserEditPage)
                Get.to(UserEditPage(user: user));
              },
              child: const Text('Sửa Thông Tin'),
            ),
          ],
        ),
      ),
    );
  }
}

// Ví dụ về trang chỉnh sửa thông tin người dùng (UserEditPage)
class UserEditPage extends StatefulWidget {
  final Users user;

  UserEditPage({Key? key, required this.user}) : super(key: key);

  @override
  _UserEditPageState createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullnameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _roleController;

  @override
  void initState() {
    super.initState();
    // Khởi tạo các controller với giá trị ban đầu là thông tin người dùng
    _fullnameController = TextEditingController(text: widget.user.fullname);
    _addressController = TextEditingController(text: widget.user.address);
    _phoneController = TextEditingController(text: widget.user.phoneNumber);
    _roleController = TextEditingController(text: widget.user.role);
  }

  @override
  void dispose() {
    // Hủy các controller khi không còn sử dụng
    _fullnameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh Sửa Thông Tin Người Dùng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Trường nhập tên người dùng
              TextFormField(
                controller: _fullnameController,
                decoration: const InputDecoration(labelText: 'Tên'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Trường nhập địa chỉ
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Địa chỉ'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập địa chỉ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Trường nhập số điện thoại
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số điện thoại';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Trường nhập vai trò
              TextFormField(
                controller: _roleController,
                decoration: const InputDecoration(labelText: 'Vai trò'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập vai trò';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Nút lưu thông tin người dùng
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final updatedUser = Users(
                      email: widget.user.email,
                      fullname: _fullnameController.text,
                      sex: widget.user.sex,
                      address: _addressController.text,
                      phoneNumber: _phoneController.text,
                      role: _roleController.text,
                    );
                    updatedUser.update(updatedUser);
                    Get.snackbar('Thông báo', 'Cập nhật thông tin thành công');
                    Get.back(); // Quay lại trang chi tiết người dùng
                  }
                },
                child: const Text('Lưu Thông Tin'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
