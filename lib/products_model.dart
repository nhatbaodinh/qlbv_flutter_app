import 'package:supabase_flutter/supabase_flutter.dart';

class Products {
  int id;
  String ten;
  String? loai;
  int gia;
  int soLuong;
  bool trangThai;
  String? anh;

  Products({
    required this.id,
    required this.ten,
    required this.loai,
    required this.gia,
    required this.soLuong,
    required this.trangThai,
    this.anh,
  });

  // Hàm tạo đối tượng từ Map (chuyển đổi dữ liệu từ Supabase)
  factory Products.fromMap(Map<String, dynamic> map) {
    return Products(
      id: map['Id'] as int,
      ten: map['Ten'] as String,
      loai: map['Loai'] as String?,
      gia: map['Gia'] as int,
      soLuong: map['SoLuong'] as int,
      trangThai: map['TrangThai'] as bool,
      anh: map['Anh'] as String?,
    );
  }

  // Hàm chuyển đối tượng thành Map (chuyển đối tượng thành dữ liệu để lưu vào Supabase)
  Map<String, dynamic> toMap() {
    return {
      'Id': this.id,
      'Ten': this.ten,
      'Loai': this.loai,
      'Gia': this.gia,
      'SoLuong': this.soLuong,
      'TrangThai': this.trangThai,
      'Anh': this.anh,
    };
  }
}

class Products_Snapshot {
  Products products;

  Products_Snapshot({required this.products});

  // Xóa vé trong cơ sở dữ liệu
  Future<void> delete() async {
    final supabase = Supabase.instance.client;
    await supabase.from("SanPham").delete().eq("Id", products.id);
  }

  // Cập nhật vé trong cơ sở dữ liệu
  Future<void> update(Products newProduct) async {
    final supabase = Supabase.instance.client;
    await supabase.from("SanPham").update(newProduct.toMap()).eq("Id", products.id);
  }

  // Chèn vé mới vào cơ sở dữ liệu
  static Future<void> insert(Products newProduct) async {
    final supabase = Supabase.instance.client;
    await supabase.from("SanPham").insert(newProduct.toMap());
  }

  // Lấy tất cả vé từ cơ sở dữ liệu
  static Future<List<Products_Snapshot>> getAll() async {
    final supabase = Supabase.instance.client;
    final response = await supabase.from("SanPham").select();

    // Kiểm tra kết quả trả về và chuyển đổi thành danh sách vé
    if (response is List) {
      return response
          .map((e) => Products_Snapshot(products: Products.fromMap(e)))
          .toList();
    } else {
      return [];
    }
  }
}