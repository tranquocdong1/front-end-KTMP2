class ContactMessage {
  final String name;
  final String email;
  final String subject; // Đảm bảo có subject
  final String message;

  ContactMessage({
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'subject': subject,
      'message': message,
    };
  }
}
