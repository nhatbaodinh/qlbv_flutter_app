import 'package:supabase_flutter/supabase_flutter.dart';

class Tickets {
  int id;
  String ten;
  String? loaiVe;
  int gia;
  int soLuong;
  bool trangThai;
  String? anh;

  Tickets({
    required this.id,
    required this.ten,
    required this.loaiVe,
    required this.gia,
    required this.soLuong,
    required this.trangThai,
    this.anh,
  });

  // Hàm tạo đối tượng từ Map (chuyển đổi dữ liệu từ Supabase)
  factory Tickets.fromMap(Map<String, dynamic> map) {
    return Tickets(
      id: map['Id'] as int,
      ten: map['Ten'] as String,
      loaiVe: map['LoaiVe'] as String?,
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
      'LoaiVe': this.loaiVe,
      'Gia': this.gia,
      'SoLuong': this.soLuong,
      'TrangThai': this.trangThai,
      'Anh': this.anh,
    };
  }
}

class Tickets_Snapshot {
  Tickets tickets;

  Tickets_Snapshot({required this.tickets});

  // Xóa vé trong cơ sở dữ liệu
  Future<void> delete() async {
    final supabase = Supabase.instance.client;
    await supabase.from("Ve").delete().eq("Id", tickets.id);
  }

  // Cập nhật vé trong cơ sở dữ liệu
  Future<void> update(Tickets newTicket) async {
    final supabase = Supabase.instance.client;
    await supabase.from("Ve").update(newTicket.toMap()).eq("Id", tickets.id);
  }

  // Chèn vé mới vào cơ sở dữ liệu
  static Future<void> insert(Tickets newTicket) async {
    final supabase = Supabase.instance.client;
    await supabase.from("Ve").insert(newTicket.toMap());
  }

  // Lấy tất cả vé từ cơ sở dữ liệu
  static Future<List<Tickets_Snapshot>> getAll() async {
    final supabase = Supabase.instance.client;
    final response = await supabase.from("Ve").select();

    // Kiểm tra kết quả trả về và chuyển đổi thành danh sách vé
    if (response is List) {
      return response
          .map((e) => Tickets_Snapshot(tickets: Tickets.fromMap(e)))
          .toList();
    } else {
      return [];
    }
  }
}