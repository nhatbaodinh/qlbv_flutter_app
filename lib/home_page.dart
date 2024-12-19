import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'products_model.dart';
import 'product_detail_page.dart';
import 'events_model.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Products> products = [];
  bool isLoading = true; // Loading state flag
  String errorMessage = ''; // Error message holder

  @override
  void initState() {
    super.initState();
    fetchProducts();
    fetchEvents();
  }

  // Fetch tickets from the database
  Future<void> fetchProducts() async {
    try {
      // Lấy 3 sản phẩm có số lượng thấp nhất
      final response = await supabase
          .from('SanPham')
          .select('*')
          .eq('TrangThai', true) // Chỉ lấy sản phẩm còn hoạt động
          .order('SoLuong', ascending: true) // Sắp xếp theo số lượng tăng dần
          .limit(3); // Giới hạn 3 sản phẩm

      if (response != null && response is List) {
        final List<Products> fetchedProducts =
        response.map((e) => Products.fromMap(e)).toList();
        setState(() {
          products = fetchedProducts;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load products: Invalid response';
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load products: $error';
        isLoading = false;
      });
    }
  }

  List<Event> events = [];
  bool isEventsLoading = true;
  String eventsErrorMessage = '';

  // Fetch events from the database
  Future<void> fetchEvents() async {
    try {
      // Lấy sự kiện từ bảng 'Events'
      final response = await supabase
          .from('SuKien') // Sử dụng bảng 'Events' thay vì 'SanPham'
          .select('*')
          .eq('TrangThai', true) // Có thể thêm điều kiện nếu cần
          .order('NgayDienRa', ascending: true); // Sắp xếp theo ngày diễn ra sự kiện

      if (response != null && response is List) {
        final List<Event> fetchedEvents = response.map((e) => Event.fromMap(e)).toList();
        setState(() {
          events = fetchedEvents;
          isEventsLoading = false;
        });
      } else {
        setState(() {
          eventsErrorMessage = 'Failed to load events: Invalid response';
          isEventsLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        eventsErrorMessage = 'Failed to load events: $error';
        isEventsLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          // Carousel section (slider)
          CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              viewportFraction: 1.0,
            ),
            items: [
              _buildBanner(
                imageUrl: 'https://nhatbaodinh.xyz/wp-content/uploads/2024/11/studenttao-cho-toi-mot-hinh-anh-nhu-vay-nhung-voi-tone-mau-xam.png',
                title: 'CHÀO MỪNG ĐẾN VỚI',
                subtitle: 'VIỆN HẢI DƯƠNG HỌC NHA TRANG',
                onPressed: () {
                  // Handle the banner click
                },
              ),
              _buildBanner(
                imageUrl: 'https://nhatbaodinh.xyz/wp-content/uploads/2024/11/pngtree-d-illustration-of-a-stunning-underwater-blue-background-with-volume-light-image_13567751.png',
                title: 'GIÁ VÉ ƯU ĐÃI',
                subtitle: 'DÀNH CHO HỌC SINH, SINH VIÊN',
                onPressed: () {
                  // Handle the banner click
                },
              ),
            ],
          ),

          // "Vé Bán Chạy" section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Sản Phẩm Bán Chạy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          // Hiển thị danh sách sản phẩm bán chạy
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red)))
              : Column(
            children: products.map((product) {
              return ProductCard(product: product);
            }).toList(),
          ),

          // Thông tin sự kiện nổi bật
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Sự Kiện Nổi Bật',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          // Hiển thị sự kiện
          isEventsLoading
              ? const Center(child: CircularProgressIndicator()) // Hiển thị loading khi sự kiện đang được tải
              : eventsErrorMessage.isNotEmpty
              ? Center(child: Text(eventsErrorMessage, style: const TextStyle(color: Colors.red)))
              : CarouselSlider(
            options: CarouselOptions(height: 250, autoPlay: true),
            items: events.map((event) {
              return _buildEventCard(
                event.ten,
                event.ngayDienRa.toString(),
                event.diaDiem ?? 'Địa điểm chưa có',
                event.anh ?? 'https://via.placeholder.com/150',
              );
            }).toList(),
          ),

          // Đánh giá từ khách hàng
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Đánh Giá Từ Khách Hàng',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          CarouselSlider(
            options: CarouselOptions(height: 150, autoPlay: true),
            items: [
              _buildReviewCard('Nguyễn Văn A', 'Vé rất rẻ và dịch vụ tuyệt vời!'),
              _buildReviewCard('Trần Thị B', 'Trải nghiệm đáng nhớ, mình rất thích.'),
            ],
          ),

          // Hỗ trợ khách hàng
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Hỗ Trợ Khách Hàng',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.phone, color: Colors.blue),
            title: const Text('Liên hệ: 0909 123 456'),
          ),
          ListTile(
            leading: const Icon(Icons.email, color: Colors.blue),
            title: const Text('Email: hotro@website.com'),
          ),

          // Blog hoặc tin tức
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Tin Tức & Blog',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.article, color: Colors.blue),
            title: const Text('Hướng dẫn đặt vé online'),
            onTap: () {
              // Điều hướng đến bài viết chi tiết
            },
          ),
          ListTile(
            leading: const Icon(Icons.article, color: Colors.blue),
            title: const Text('Top sự kiện không thể bỏ qua mùa hè này'),
            onTap: () {
              // Điều hướng đến bài viết chi tiết
            },
          ),
        ],
      ),
    );
  }

  // Widget to build a banner with background image and text
  Widget _buildBanner({
    required String imageUrl,
    required String title,
    required String subtitle,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 250,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to build an event card
  Widget _buildEventCard(String title, String date, String location, String imageUrl) {
    DateTime eventDate = DateTime.parse(date);
    String formattedDate = DateFormat('dd/MM/yyyy').format(eventDate);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tên sự kiện
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8), // Khoảng cách giữa tên sự kiện và hình ảnh

            // Hình ảnh dưới tên sự kiện
            Image.network(
              imageUrl,
              width: double.infinity, // Chiếm hết chiều rộng của card
              height: 120, // Đặt chiều cao hình ảnh
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image, size: 40); // Nếu hình ảnh không có
              },
            ),

            // Ngày và địa điểm
            Text('$formattedDate - $location'),

            // Dùng Expanded hoặc Spacer để đẩy nút xuống dưới cùng
            Spacer(),

            // Nút chi tiết ở dưới cùng bên phải
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  // Điều hướng đến trang mua vé
                },
                child: const Text('Chi tiết'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(String name, String review) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(review),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Products product;

  const ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image.network(
          product.anh ?? 'https://via.placeholder.com/150', // fallback image
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.image, size: 50); // Fallback icon if image fails
          },
        ),
        title: Text(product.ten),
        subtitle: Text(product.loai ?? 'Chưa có loại'),
        trailing: Text('${product.gia} VND'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailPage(product: product),
            ),
          );
        },
      ),
    );
  }
}