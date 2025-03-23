import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Về Chúng Tôi'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner hình ảnh
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              child: Image.network(
                'http://localhost:3000/images/about.jpg',
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 220,
                  color: Colors.pink[100],
                  child: Center(
                    child: Icon(
                      Icons.local_florist,
                      size: 80,
                      color: Colors.pink[300],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Tên cửa hàng
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Hoa Yêu Thương',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink[800],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            // Slogan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                'Mang vẻ đẹp thiên nhiên đến ngôi nhà của bạn',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.pink[400],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Divider(thickness: 1, color: Colors.pink[200]),
            ),
            
            const SizedBox(height: 16),
            
            // Giới thiệu
            InfoSection(
              title: 'Giới Thiệu',
              content: 'Được thành lập vào năm 2010, Hoa Yêu Thương là cửa hàng hoa tươi hàng đầu tại Việt Nam. '
                  'Chúng tôi tự hào mang đến những bó hoa tươi nhất, đẹp nhất từ những nhà vườn chất lượng cao. '
                  'Mỗi thiết kế hoa của chúng tôi đều được chăm chút tỉ mỉ để tạo nên những tác phẩm nghệ thuật đầy ý nghĩa.',
              icon: Icons.info_outline,
            ),
            
            // Sứ mệnh
            InfoSection(
              title: 'Sứ Mệnh',
              content: 'Sứ mệnh của chúng tôi là kết nối con người thông qua vẻ đẹp của hoa tươi. '
                  'Chúng tôi tin rằng mỗi bó hoa đều mang theo những thông điệp tình cảm đặc biệt, '
                  'và chúng tôi cam kết giúp bạn truyền tải những tình cảm đó một cách trọn vẹn nhất.',
              icon: Icons.volunteer_activism,
            ),
            
            // Dịch vụ
            InfoSection(
              title: 'Dịch Vụ',
              content: '• Hoa tươi theo mùa\n'
                  '• Hoa cưới và sự kiện\n'
                  '• Thiết kế hoa nghệ thuật\n'
                  '• Giao hoa tận nơi\n'
                  '• Đặt hoa trực tuyến 24/7\n'
                  '• Tư vấn thiết kế không gian hoa',
              icon: Icons.miscellaneous_services,
            ),
            
            // Thông tin liên hệ
            Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.pink[50],
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Liên Hệ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Địa chỉ
                  ContactInfo(
                    icon: Icons.location_on,
                    text: '123 Đường Hoa Hồng, Quận 1, TP. Hồ Chí Minh',
                  ),
                  
                  // Số điện thoại
                  ContactInfo(
                    icon: Icons.phone,
                    text: '(028) 1234 5678',
                  ),
                  
                  // Email
                  ContactInfo(
                    icon: Icons.email,
                    text: 'info@hoayeuthuong.com',
                  ),
                  
                  // Giờ mở cửa
                  ContactInfo(
                    icon: Icons.access_time,
                    text: 'Mở cửa: 8:00 - 20:00 (Thứ 2 - Chủ Nhật)',
                  ),
                ],
              ),
            ),
            
            
            // Copyright
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: Colors.pink[50],
            ),
          ],
        ),
      ),
    );
  }
}

// Phần thông tin
class InfoSection extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const InfoSection({
    Key? key,
    required this.title,
    required this.content,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.pink[400],
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 34),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Colors.grey[800],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// Phần thông tin liên hệ
class ContactInfo extends StatelessWidget {
  final IconData icon;
  final String text;

  const ContactInfo({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.pink[400],
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Nút icon mạng xã hội
class SocialIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;

  const SocialIconButton({
    Key? key,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}