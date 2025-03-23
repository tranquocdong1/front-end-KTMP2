import 'package:flutter/material.dart';
import '../services/contact_service.dart';
import '../models/contact_model.dart';

class ContactScreen extends StatefulWidget {
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  final _subjectController = TextEditingController();

  Future<void> _sendMessage() async {
    final contact = ContactMessage(
      name: _nameController.text,
      email: _emailController.text,
      subject: _subjectController.text,
      message: _messageController.text,
    );

    bool success = await ContactService.submitContact(contact);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? "Gửi thành công!" : "Gửi thất bại, vui lòng thử lại.",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: success ? Colors.green : Colors.red,
        duration: Duration(seconds: 2),
      ),
    );

    if (success) {
      _nameController.clear();
      _emailController.clear();
      _subjectController.clear();
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Liên Hệ Với Flower Shop",
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 24,
            color: Colors.pink[800],
          ),
        ),
        backgroundColor: Colors.pink[50],
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.pink[400]),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                "Gửi Tin Nhắn Cho Chúng Tôi",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink[800],
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Chúng tôi rất vui được hỗ trợ bạn!",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20),

              // Form fields
              _buildTextField(
                controller: _nameController,
                label: "Họ và tên",
                icon: Icons.person,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _emailController,
                label: "Email",
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _subjectController,
                label: "Chủ đề",
                icon: Icons.subject,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _messageController,
                label: "Tin nhắn",
                icon: Icons.message,
                maxLines: 5,
              ),
              SizedBox(height: 30),

              // Nút gửi
              Center(
                child: ElevatedButton(
                  onPressed: _sendMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[400],
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    "Gửi Tin Nhắn",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // Thông tin liên hệ bổ sung
              SizedBox(height: 30),
              Center(
                child: Column(
                  children: [
                    Text(
                      "Hoặc liên hệ trực tiếp:",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone, color: Colors.pink[400], size: 20),
                        SizedBox(width: 8),
                        Text(
                          "Hotline: 0123-456-789",
                          style: TextStyle(fontSize: 16, color: Colors.pink[800]),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.email, color: Colors.pink[400], size: 20),
                        SizedBox(width: 8),
                        Text(
                          "Email: flowershop@example.com",
                          style: TextStyle(fontSize: 16, color: Colors.pink[800]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm tạo TextField với thiết kế đẹp
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.pink[400]),
        prefixIcon: Icon(icon, color: Colors.pink[400]),
        filled: true,
        fillColor: Colors.pink[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.pink[400]!, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}