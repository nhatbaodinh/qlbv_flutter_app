import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'home_controller.dart';
import 'products_model.dart';
import 'product_detail_page.dart';
import 'events_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String formatCurrency(int amount) {
    final formatter = NumberFormat.decimalPattern(); // Định dạng theo hệ thập phân
    return "${formatter.format(amount)} VND";
  }

  final HomeController _controller = HomeController();
  List<Products> products = [];
  bool isLoading = true;
  String errorMessage = '';

  List<Event> events = [];
  bool isEventsLoading = true;
  String eventsErrorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchProducts();
    fetchEvents();
  }

  // Fetch products using HomeController
  Future<void> fetchProducts() async {
    try {
      final fetchedProducts = await _controller.fetchProducts();
      setState(() {
        products = fetchedProducts;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
    }
  }

  // Fetch events using HomeController
  Future<void> fetchEvents() async {
    try {
      final fetchedEvents = await _controller.fetchEvents();
      setState(() {
        events = fetchedEvents;
        isEventsLoading = false;
      });
    } catch (error) {
      setState(() {
        eventsErrorMessage = error.toString();
        isEventsLoading = false;
      });
    }
  }

  // Hàm gọi điện
  void callSupport() async {
    const phoneNumber = '0909123456';
    final success = await launchUrlString('tel:$phoneNumber');
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể thực hiện cuộc gọi')),
      );
    }
  }

  // Hàm gửi email
  void emailSupport() async {
    const email = 'hotro@mail.com';
    final success = await launchUrlString('mailto:$email');
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể mở ứng dụng email')),
      );
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
              return _buildProductCard(product);
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
              ? const Center(child: CircularProgressIndicator())
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
            onTap: () {
              callSupport();
            },
          ),
          ListTile(
            leading: const Icon(Icons.email, color: Colors.blue),
            title: const Text('Email: hotro@website.com'),
            onTap: () {
              emailSupport();
            },
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

  Widget _buildProductCard(Products product) {
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
        trailing:Text(formatCurrency(product.gia)),
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

  Widget _buildEventCard(String title, String date, String location, String imageUrl) {
    DateTime eventDate = DateTime.parse(date);
    String formattedDate = DateFormat('dd/MM/yyyy').format(eventDate);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0), // Apply borderRadius here
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image, size: 40);
                },
              ),
            ),
            Text(
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              '$formattedDate - $location'
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  // Handle event detail navigation
                },
                child:
                const Text(
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    'Chi tiết'
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(String name, String review) {
    return Container(
      width: double.infinity,
      child: Card(
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
      ),
    );
  }
}