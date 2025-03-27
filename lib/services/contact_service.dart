import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/contact_model.dart';

class ContactService {
  static const String baseUrl = "https://back-end-ktpm2.onrender.com"; // Đổi thành domain thật

  static Future<bool> submitContact(ContactMessage contact) async {
    final url = Uri.parse("$baseUrl/contact/submit");
    
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(contact.toJson()),
      );

      if (response.statusCode == 200) {
        return true; // Thành công
      } else {
        return false; // Thất bại
      }
    } catch (e) {
      print("Lỗi gửi liên hệ: $e");
      return false;
    }
  }
}
