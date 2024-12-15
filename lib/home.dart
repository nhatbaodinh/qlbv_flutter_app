import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          // Mục Slider (carousel)
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
                  // Xử lý khi nhấn vào banner
                },
              ),
              _buildBanner(
                imageUrl: 'https://nhatbaodinh.xyz/wp-content/uploads/2024/11/an-Image-describe-about-discount-the-ticket-for-student.png',
                title: 'GIÁ VÉ ƯU ĐÃI DÀNH CHO HỌC SINH, SINH VIÊN',
                subtitle: 'Đặt vé ngay',
                onPressed: () {
                  // Xử lý khi nhấn vào banner
                },
              ),
              _buildBanner(
                imageUrl: 'https://nhatbaodinh.xyz/wp-content/uploads/2024/11/ve-dep-loi-cuon-cua-vien-hai-duong-hoc-nha-trang.jpg',
                title: 'VIỆN HẢI DƯƠNG HỌC NHA TRANG CÓ GÌ MỚI ?',
                subtitle: 'Khám phá ngay',
                onPressed: () {
                  // Xử lý khi nhấn vào banner
                },
              ),
            ],
          ),

          // Mục Vé Bán Chạy
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Vé Bán Chạy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          // Danh sách vé bán chạy
          _buildPopularTicket(
            ticketName: 'Vé Tham Quan Viện Hải Dương Học',
            ticketPrice: 120000,
            imageUrl: 'https://nhatbaodinh.xyz/wp-content/uploads/2024/11/studenttao-cho-toi-mot-hinh-anh-nhu-vay-nhung-voi-tone-mau-xam.png',
            onPressed: () {
              // Xử lý khi nhấn vào nút "Mua ngay"
            },
          ),

          _buildPopularTicket(
            ticketName: 'Combo Vé Tham Quan Cho Học Sinh',
            ticketPrice: 90000,
            imageUrl: 'https://nhatbaodinh.xyz/wp-content/uploads/2024/11/an-Image-describe-about-discount-the-ticket-for-student.png',
            onPressed: () {
              // Xử lý khi nhấn vào nút "Mua ngay"
            },
          ),

          _buildPopularTicket(
            ticketName: 'Vé Tham Quan Giá Rẻ',
            ticketPrice: 150000,
            imageUrl: 'https://nhatbaodinh.xyz/wp-content/uploads/2024/11/ve-dep-loi-cuon-cua-vien-hai-duong-hoc-nha-trang.jpg',
            onPressed: () {
              // Xử lý khi nhấn vào nút "Mua ngay"
            },
          ),
        ],
      ),
    );
  }

  // Widget hiển thị vé bán chạy
  Widget _buildPopularTicket({
    required String ticketName,
    required double ticketPrice,
    required String imageUrl,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
        child: Row(
          children: [
            // Ảnh vé
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            // Thông tin vé
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticketName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Giá: ${ticketPrice.toStringAsFixed(0)} VND',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: onPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('Mua ngay'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget để xây dựng banner với ảnh nền và văn bản
  Widget _buildBanner({required String imageUrl, required String title, required String subtitle, required VoidCallback onPressed}) {
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
          color: Colors.black.withOpacity(0.5), // Lớp phủ màu tối để làm nổi bật chữ
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
}