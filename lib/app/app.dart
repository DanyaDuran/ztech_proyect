import 'package:flutter/material.dart';
import '../features/auth/presentation/screens/login_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ztech',
      home: const LoginScreen(),
    );
  }
}
