  import 'package:supabase_flutter/supabase_flutter.dart';

  class Users {
    String email;
    String fullname;
    bool sex;
    String address;
    String phoneNumber;
    String role;

    Users({
      required this.email,
      required this.fullname,
      required this.sex,
      required this.address,
      required this.phoneNumber,
      required this.role,
    });

    // Hàm tạo đối tượng từ Map
    factory Users.fromMap(Map<String, dynamic> map) {
      return Users(
        email: map['Email'] as String,
        fullname: map['FullName'] as String,
        sex: map['Sex'] as bool,
        address: map['Address'] as String,
        phoneNumber: map['PhoneNumber'] as String,
        role: map['Role'] as String,
      );
    }

    // Hàm chuyển đối tượng thành Map (để lưu vào Supabase)
    Map<String, dynamic> toMap() {
      return {
        'Email': email,
        'FullName': fullname,
        'Sex': sex,
        'Address': address,
        'PhoneNumber': phoneNumber,
        'Role': role,
      };
    }

    // Phương thức để thêm người dùng vào cơ sở dữ liệu
    static Future<void> insert(Users newUser) async {
      final supabase = Supabase.instance.client;
      try {
        await supabase.from('Users').insert(newUser.toMap());
      } catch (e) {
        print('Error inserting user: $e');
      }
    }

    // Phương thức để lấy tất cả người dùng từ cơ sở dữ liệu
    static Future<List<Users>> getAll() async {
      final supabase = Supabase.instance.client;
      try {
        final response = await supabase.from('Users').select();
        if (response is List) {
          return response.map((e) => Users.fromMap(e)).toList();
        }
        return [];
      } catch (e) {
        print('Error fetching users: $e');
        return [];
      }
    }

    // Phương thức để cập nhật thông tin người dùng trong cơ sở dữ liệu
    Future<void> update(Users updatedUser) async {
      final supabase = Supabase.instance.client;
      try {
        await supabase
            .from('Users')
            .update(updatedUser.toMap())
            .eq('Email', email);  // Giả sử 'Email' là khóa chính
      } catch (e) {
        print('Error updating user: $e');
      }
    }

    // Phương thức để xóa người dùng khỏi cơ sở dữ liệu
    Future<void> delete() async {
      final supabase = Supabase.instance.client;
      try {
        await supabase.from('Users').delete().eq('Email', email);  // Xóa theo email
      } catch (e) {
        print('Error deleting user: $e');
      }
    }
  }
