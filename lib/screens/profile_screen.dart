import 'package:flutter/material.dart';
import 'package:front_end_ktpm2/services/auth_service.dart'; // Import AuthService

class ProfileScreen extends StatelessWidget {
  final String userEmail;

  // Constructor to receive the user email
  const ProfileScreen({Key? key, required this.userEmail}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    // Gọi hàm logout từ AuthService để xóa userId
    await AuthService().logout();

    // Chuyển hướng về màn hình đăng nhập
    Navigator.pushReplacementNamed(context, "/login");
  }

  @override
  Widget build(BuildContext context) {
    // Extract username from email (everything before @)
    String username = userEmail.split('@')[0];
    // Capitalize first letter of username
    username = username.isNotEmpty
        ? '${username[0].toUpperCase()}${username.substring(1)}'
        : '';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hồ Sơ",
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 24,
            color: Colors.pink[800],
          ),
        ),
        backgroundColor: Colors.pink[50],
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.pink[100],
              child: Icon(Icons.person, size: 60, color: Colors.pink[400]),
            ),
            SizedBox(height: 20),
            Text(
              username,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.pink[800],
              ),
            ),
            SizedBox(height: 10),
            Text(
              userEmail,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _logout(context), // Gọi hàm _logout
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[400],
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "Đăng xuất",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}