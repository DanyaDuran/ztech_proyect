import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1E4F6D);
  static const Color secondary = Color(0xFF0F2A3D);
  static const Color accent = Color(0xFF16C7D8);

  static const Color background = Color(0xFFF5F7FA);
  static const Color backgroundDark = Color(0xFF001233);
  static const Color surface = Colors.white;
  static const Color inputBackground = Color(0xFFF4F7FA);

  static const Color textPrimary = Color(0xFF16354A);
  static const Color textSecondary = Color(0xFF6B7C8A);
  static const Color textLight = Color(0xFFB8C7D3);
  static const Color textOnDark = Colors.white;

  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFF2F4A5F);

  static const Color statusAvailable = Colors.green;
  static const Color statusRepair = Colors.amber;
  static const Color statusSold = Colors.blue;
  static const Color statusDiscarded = Colors.red;
  static const Color statusPending = Colors.deepPurple;

  static const Color sidebarBackground = backgroundDark;
  static const Color sidebarSelected = primary;
  static const Color sidebarText = textLight;
  static const Color sidebarTextSelected = textOnDark;
  static const Color logout = Color(0xFFFFB4A2);

  static const Color shadow = Color(0x1A000000);

  static const Color white = surface;
  static const Color lightGrey = background;
  static const Color textDark = textPrimary;
  static const Color textGrey = textSecondary;
  static const Color selectedMenu = sidebarSelected;
  static const Color disponible = statusAvailable;
  static const Color reparacion = statusRepair;
  static const Color vendido = statusSold;
  static const Color merma = statusDiscarded;
  static const Color pendiente = statusPending;
}
