import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'products_model.dart';
import 'events_model.dart';

class HomeController {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Products>> fetchProducts() async {
    try {
      final response = await supabase
          .from('SanPham')
          .select('*')
          .eq('TrangThai', true)
          .order('SoLuong', ascending: true)
          .limit(3);

      if (response is List) {
        return response.map((e) => Products.fromMap(e)).toList();
      } else {
        throw Exception('Invalid product response');
      }
    } catch (error) {
      throw Exception('Failed to load products: $error');
    }
  }

  Future<List<Event>> fetchEvents() async {
    try {
      final response = await supabase
          .from('SuKien')
          .select('*')
          .eq('TrangThai', true)
          .order('NgayDienRa', ascending: true);

      if (response is List) {
        return response.map((e) => Event.fromMap(e)).toList();
      } else {
        throw Exception('Invalid event response');
      }
    } catch (error) {
      throw Exception('Failed to load events: $error');
    }
  }
}