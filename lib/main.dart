import 'package:flutter/material.dart';
import 'package:front_end_ktpm2/screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/flower_detail_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/login", // Start with Login screen
      onGenerateRoute: (settings) {
        // Special case for home route to handle parameters
        if (settings.name == '/home') {
          final args = settings.arguments as Map<String, dynamic>?;
          final userEmail = args?['userEmail'] as String? ?? '';

          return MaterialPageRoute(
            builder: (context) => HomeScreen(userEmail: userEmail),
          );
        }

        // Product detail route
        if (settings.name == '/product-detail') {
          final productId = settings.arguments as String;

          return MaterialPageRoute(
            builder: (context) => ProductDetailScreen(productId: productId),
          );
        }

        // Standard routes
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (context) => LoginScreen());
          case '/register':
            return MaterialPageRoute(builder: (context) => RegisterScreen());
          default:
            return MaterialPageRoute(builder: (context) => LoginScreen());
        }
      },
    );
  }
}
