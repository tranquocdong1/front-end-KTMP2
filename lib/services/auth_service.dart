import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: "http://localhost:3000"));

  // Lưu userId vào SharedPreferences
  Future<void> _saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  // Lấy userId từ SharedPreferences
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    print('Retrieved userId from SharedPreferences: $userId');
    return prefs.getString('userId');
  }

  // Xóa userId khi đăng xuất
  static Future<void> clearUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
  }

  Future<Map<String, dynamic>> registerUser(
      String name, String email, String password, String confirmPassword, int age) async {
    try {
      final response = await _dio.post(
        "/signup",
        data: {
          "name": name,
          "email": email,
          "password": password,
          "confirmpassword": confirmPassword,
          "age": age,
        },
      );
      return response.data;
    } catch (e) {
      print("Lỗi đăng ký: $e");
      return {"success": false, "message": "Lỗi kết nối đến server."};
    }
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
  try {
    final response = await _dio.post(
      "/login",
      data: {"email": email, "password": password},
    );
    print('Login response: ${response.data}');
    if (response.data['success'] == true && response.data['userId'] != null) {
      await _saveUserId(response.data['userId']);
      print('UserId saved: ${response.data['userId']}');
    }
    return response.data;
  } catch (e) {
    print("Lỗi đăng nhập: $e");
    return {"success": false, "message": "Lỗi đăng nhập."};
  }
}
}