import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:front_end_ktpm2/services/blog_service.dart';

class BlogScreen extends StatefulWidget {
  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  List<dynamic> blogs = [];
  bool isLoading = true;
  String errorMessage = '';
  
  // Base URL for images
  final String baseUrl = "http://localhost:3000/images/";

  @override
  void initState() {
    super.initState();
    loadBlogs();
  }

  Future<void> loadBlogs() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final fetchedBlogs = await BlogService.getBlogs();
      setState(() {
        blogs = fetchedBlogs;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Không thể tải danh sách bài viết: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: loadBlogs,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: loadBlogs,
                        child: Text('Thử lại'),
                      ),
                    ],
                  ),
                )
              : blogs.isEmpty
                  ? Center(child: Text('Không có bài viết nào'))
                  : RefreshIndicator(
                      onRefresh: loadBlogs,
                      child: ListView.builder(
                        itemCount: blogs.length,
                        itemBuilder: (context, index) {
                          final blog = blogs[index];
                          return BlogCard(
                            blog: blog,
                            baseUrl: baseUrl,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlogDetailScreen(
                                    blogId: blog['_id'],
                                    baseUrl: baseUrl,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
    );
  }
}

class BlogCard extends StatelessWidget {
  final dynamic blog;
  final String baseUrl;
  final VoidCallback onTap;

  const BlogCard({
    Key? key,
    required this.blog,
    required this.baseUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateStr = blog['date'] ?? '';
    DateTime? date;
    try {
      date = DateTime.parse(dateStr);
    } catch (e) {
      print('Lỗi parse ngày: $e');
    }

    final formattedDate = date != null
        ? DateFormat('dd/MM/yyyy').format(date)
        : 'Không có ngày';

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh Blog với baseUrl
            if (blog['image'] != null && blog['image'].toString().isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                child: Image.network(
                  baseUrl + (blog['image'] ?? ''),
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                ),
              ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề
                  Text(
                    blog['title'] ?? 'Không có tiêu đề',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  
                  // Ngày đăng
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        formattedDate,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  
                  // Mô tả
                  Text(
                    blog['description'] ?? 'Không có mô tả',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  
                  // Button đọc thêm
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: onTap,
                      child: Text('Đọc thêm'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlogDetailScreen extends StatefulWidget {
  final String blogId;
  final String baseUrl;

  const BlogDetailScreen({
    Key? key,
    required this.blogId,
    required this.baseUrl,
  }) : super(key: key);

  @override
  _BlogDetailScreenState createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  Map<String, dynamic> blogDetail = {};
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadBlogDetail();
  }

  Future<void> loadBlogDetail() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final detail = await BlogService.getBlogDetail(widget.blogId);
      
      if (detail.containsKey('error')) {
        setState(() {
          errorMessage = detail['error'];
          isLoading = false;
        });
        return;
      }
      
      setState(() {
        blogDetail = detail;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Không thể tải chi tiết bài viết: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = blogDetail['date'] ?? '';
    DateTime? date;
    try {
      date = DateTime.parse(dateStr);
    } catch (e) {
      print('Lỗi parse ngày: $e');
    }

    final formattedDate = date != null
        ? DateFormat('dd/MM/yyyy').format(date)
        : 'Không có ngày';

    return Scaffold(
      appBar: AppBar(
        title: Text(isLoading ? 'Đang tải...' : (blogDetail['title'] ?? 'Chi tiết bài viết')),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: loadBlogDetail,
                        child: Text('Thử lại'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ảnh bài viết với baseUrl
                      if (blogDetail['image'] != null && 
                          blogDetail['image'].toString().isNotEmpty)
                        Image.network(
                          widget.baseUrl + (blogDetail['image'] ?? ''),
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 250,
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.image_not_supported,
                                size: 50,
                                color: Colors.grey[600],
                              ),
                            );
                          },
                        ),

                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Tiêu đề
                            Text(
                              blogDetail['title'] ?? 'Không có tiêu đề',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            
                            // Ngày đăng
                            Row(
                              children: [
                                Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                SizedBox(width: 4),
                                Text(
                                  formattedDate,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            
                            // Mô tả
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                blogDetail['description'] ?? 'Không có mô tả',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            
                            // Nội dung bài viết
                            Text(
                              blogDetail['content'] ?? 'Không có nội dung',
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}