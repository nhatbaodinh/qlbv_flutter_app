import 'package:supabase_flutter/supabase_flutter.dart';

class Event {
  final int id;
  final String ten;
  final DateTime ngayDienRa;
  final String? diaDiem;
  final bool trangThai;
  final String? anh;

  Event({
    required this.id,
    required this.ten,
    required this.ngayDienRa,
    this.diaDiem,
    this.trangThai = true,
    this.anh,
  });

  // Hàm tạo đối tượng từ Map (chuyển đổi dữ liệu từ Supabase)
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] as int,
      ten: map['Ten'] as String,
      ngayDienRa: DateTime.parse(map['NgayDienRa'] as String),
      diaDiem: map['DiaDiem'] as String?,
      trangThai: map['TrangThai'] ?? true,
      anh: map['Anh'] as String?,
    );
  }

  // Hàm chuyển đối tượng thành Map (chuyển đối tượng thành dữ liệu để lưu vào Supabase)
  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'Ten': this.ten,
      'NgayDienRa': this.ngayDienRa.toIso8601String(),
      'DiaDiem': this.diaDiem,
      'TrangThai': this.trangThai,
      'Anh': this.anh,
    };
  }
}

class Event_Snapshot {
  Event event;

  Event_Snapshot({required this.event});

  // Xóa sự kiện trong cơ sở dữ liệu
  Future<void> delete() async {
    final supabase = Supabase.instance.client;
    await supabase.from("SuKien").delete().eq("id", event.id);
  }

  // Cập nhật sự kiện trong cơ sở dữ liệu
  Future<void> update(Event newEvent) async {
    final supabase = Supabase.instance.client;
    await supabase.from("SuKien").update(newEvent.toMap()).eq("id", event.id);
  }

  // Chèn sự kiện mới vào cơ sở dữ liệu
  static Future<void> insert(Event newEvent) async {
    final supabase = Supabase.instance.client;
    await supabase.from("SuKien").insert(newEvent.toMap());
  }

  // Lấy tất cả sự kiện từ cơ sở dữ liệu
  static Future<List<Event_Snapshot>> getAll() async {
    final supabase = Supabase.instance.client;
    final response = await supabase.from("SuKien").select();

    // Kiểm tra kết quả trả về và chuyển đổi thành danh sách sự kiện
    if (response is List) {
      return response
          .map((e) => Event_Snapshot(event: Event.fromMap(e)))
          .toList();
    } else {
      return [];
    }
  }
}