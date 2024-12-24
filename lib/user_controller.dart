import 'package:supabase_flutter/supabase_flutter.dart';

class User {
  String email;
  String fullName;
  bool sex;
  String role;
  String address;
  String phoneNumber;

  User({
    required this.email,
    required this.fullName,
    required this.sex,
    required this.address,
    required this.phoneNumber,
    required this.role,
  });

  // Hàm tạo đối tượng từ Map (chuyển đổi dữ liệu từ Supabase)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['Email'] as String,
      fullName: map['FullName'] as String,
      sex: map['Sex'] as bool,
      role: map['Role'] as String,
      address: map['address'] as String,
      phoneNumber: map['phoneNumber'] as String,

    );
  }

  // Hàm chuyển đối tượng thành Map (chuyển đối tượng thành dữ liệu để lưu vào Supabase)
  Map<String, dynamic> toMap() {
    return {
      'Email': this.email,
      'FullName': this.fullName,
      'Sex': this.sex,
      'Role':this.role,
      'address': this.address,
      'phoneNumber': this.phoneNumber,
    };
  }
}

class User_Snapshot {
  User user;

  User_Snapshot({required this.user});

  // Xóa người dùng trong cơ sở dữ liệu
  Future<void> delete() async {
    final supabase = Supabase.instance.client;
    await supabase.from("Users").delete().eq("Email", user.email);
  }

  // Cập nhật người dùng trong cơ sở dữ liệu
  Future<void> update(User newUser) async {
    final supabase = Supabase.instance.client;
    await supabase.from("Users").update(newUser.toMap()).eq("Email", user.email);
  }

  // Chèn người dùng mới vào cơ sở dữ liệu
  static Future<void> insert(User newUser) async {
    final supabase = Supabase.instance.client;
    await supabase.from("Users").insert(newUser.toMap());
  }

  // Lấy tất cả người dùng từ cơ sở dữ liệu
  static Future<List<User_Snapshot>> getAll() async {
    final supabase = Supabase.instance.client;
    final response = await supabase.from("Users").select();

    // Kiểm tra kết quả trả về và chuyển đổi thành danh sách người dùng
    if (response is List) {
      return response
          .map((e) => User_Snapshot(user: User.fromMap(e)))
          .toList();
    } else {
      return [];
    }
  }

  // Lấy thông tin người dùng theo email từ cơ sở dữ liệu
  static Future<User_Snapshot?> getByEmail(String email) async {
    final supabase = Supabase.instance.client;
    final response = await supabase.from("User").select().eq("Email", email).single();

    if (response != null) {
      return User_Snapshot(user: User.fromMap(response));
    } else {
      return null;
    }
  }
}
