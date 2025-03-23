import 'dart:convert';
import 'package:http/http.dart' as http;

class BlogService {
  static const String baseUrl = 'http://localhost:3000';
  static const int timeoutSeconds = 10;

  // Xử lý phản hồi API
  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        print('Lỗi khi parse JSON: $e');
        throw Exception('Lỗi parse dữ liệu JSON');
      }
    } else {
      print('Lỗi API: ${response.statusCode} - ${response.body}');
      throw Exception('Lỗi API: ${response.statusCode}');
    }
  }

  // Lấy danh sách bài viết blog
  static Future<List<dynamic>> getBlogs() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/api/blogs'))
          .timeout(Duration(seconds: timeoutSeconds));


      // Kiểm tra trường hợp response body rỗng
      if (response.body.isEmpty) {
        print('Phản hồi rỗng từ server');
        return [];
      }

      final data = _handleResponse(response);
      return data['blogs'] ?? [];
    } catch (e) {
      print('Lỗi khi tải danh sách blog: $e');
      return [];
    }
  }

  // Lấy chi tiết bài viết blog
  static Future<Map<String, dynamic>> getBlogDetail(String blogId) async {
    try {
      if (blogId.isEmpty) {
        return {'error': 'ID bài viết không hợp lệ'};
      }

      final response = await http
          .get(Uri.parse('$baseUrl/api/blog/$blogId'))
          .timeout(Duration(seconds: timeoutSeconds));

      if (response.statusCode == 404) {
        return {'error': 'Không tìm thấy bài viết'};
      }

      final data = _handleResponse(response);
      return data['blog'] ?? {};
    } catch (e) {
      print('Lỗi khi tải chi tiết blog: $e');
      return {'error': e.toString()};
    }
  }
}