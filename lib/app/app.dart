import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class ZTechApp extends StatelessWidget {
  const ZTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZTech Inventory',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const Scaffold(body: Center(child: Text('ZTech Inventory App'))),
    );
  }
}
