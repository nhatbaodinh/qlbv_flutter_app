import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'tickets_model.dart';
import 'product_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Tickets> tickets = [];
  bool isLoading = true; // Loading state flag
  String errorMessage = ''; // Error message holder

  @override
  void initState() {
    super.initState();
    fetchTickets();
  }

  // Fetch tickets from the database
  Future<void> fetchTickets() async {
    try {
      final response = await supabase.from('Ve').select('*').eq('TrangThai', true); // Only get active tickets
      if (response != null && response is List) {
        final List<Tickets> fetchedTickets = response.map((e) => Tickets.fromMap(e)).toList();
        setState(() {
          tickets = fetchedTickets;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load tickets: Invalid response';
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load tickets: $error';
        isLoading = false;
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
              'Vé Bán Chạy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          // Displaying popular tickets
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red)))
              : Column(
            children: tickets.map((ticket) {
              return TicketCard(ticket: ticket);
            }).toList(),
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
}

class TicketCard extends StatelessWidget {
  final Tickets ticket;

  const TicketCard({required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image.network(
          ticket.anh ?? 'https://via.placeholder.com/150', // fallback image
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.image, size: 50); // Fallback icon if image fails
          },
        ),
        title: Text(ticket.ten),
        subtitle: Text(ticket.loaiVe ?? 'Chưa có loại vé'),
        trailing: Text('${ticket.gia} VND'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailPage(ticket: ticket),
            ),
          );
        },
      ),
    );
  }
}