import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const pageTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.secondary,
  );

  static const sectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.secondary,
  );

  static const subtitle = TextStyle(fontSize: 14, color: AppColors.textGrey);

  static const cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.secondary,
  );

  static const body = TextStyle(fontSize: 14, color: AppColors.textGrey);

  static const badge = TextStyle(fontSize: 12, fontWeight: FontWeight.w600);

  static const button = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const appBarTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.secondary,
  );

  static const filterText = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
  );

  static const sidebarSubtitle = TextStyle(
    fontSize: 12,
    color: AppColors.textLight,
  );

  static const sidebarItem = TextStyle(
    color: AppColors.textLight,
    fontWeight: FontWeight.w500,
  );

  static const sidebarSelected = TextStyle(
    color: AppColors.white,
    fontWeight: FontWeight.bold,
  );

  static const logout = TextStyle(
    color: AppColors.logout,
    fontWeight: FontWeight.w600,
  );

  static const statusCount = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );
}
