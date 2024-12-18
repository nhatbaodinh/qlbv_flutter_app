
import 'package:supabase_flutter/supabase_flutter.dart';

class Tickets {
  String idVe;
  String ten;
  String? loaiVe;
  int? giaVe;
  int? soLuongVe;
  bool? trangThai;
  String? anh;

  Tickets({
    required this.idVe,
    required this.ten,
    this.loaiVe,
    this.giaVe,
    this.soLuongVe,
    this.trangThai,
    this.anh,
  });
  factory Tickets.fromMap(Map<String,dynamic> map){
    return Tickets(idVe: map['idVe'] as String,
        ten: map['ten'] as String,
        loaiVe: map['loaiVe'] as String,
        giaVe: map['giaVe'] as int,
        soLuongVe: map['soLuongVe'] as int,
        trangThai: map['trangThai'] as bool,
        anh: map['anh'] as String,
    );
  }
  Map<String,dynamic> toMap(){
    return{
      'idVe':this.idVe,
      'ten':this.ten,
      'loaiVe': this.loaiVe,
      'giaVe': this.giaVe,
      'soLuongVe': this.soLuongVe,
      'trangThai': this.trangThai,
      'anh': this.anh,
    };
  }

}


class Tickets_Snapshot {
  Tickets tickets;

  Tickets_Snapshot({required this.tickets});

  Future<void> delete() async {
    final supabase = Supabase.instance.client;
    await supabase.from("ticketProducts").delete().eq("idVe", tickets.idVe);
  }

  Future<void> update(Tickets nVe) async {
    final supabase = Supabase.instance.client;
    await supabase.from("ticketProducts").update(nVe.toMap()).eq(
        "idVe", tickets.idVe);
  }

  static Future<void> insert(Tickets nVe) async {
    final supabase = Supabase.instance.client;
    await supabase.from("ticketProducts").insert(nVe.toMap());
  }
  static Future<List<Tickets_Snapshot>> getAll()async{
    final supabase=Supabase.instance.client;
    var data=await supabase.from("ticketProducts").select();
    return data.map((e)=>Tickets_Snapshot(tickets: Tickets.fromMap(e),)).toList();
  }
}



