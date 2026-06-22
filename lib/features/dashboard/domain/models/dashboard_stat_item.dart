import 'package:flutter/material.dart';

class DashboardStatItem {
  final String title;
  final int count;
  final IconData icon;
  final Color iconColor;
  final String trendText;
  final IconData trendIcon;
  final Color trendColor;

  const DashboardStatItem({
    required this.title,
    required this.count,
    required this.icon,
    required this.iconColor,
    required this.trendText,
    required this.trendIcon,
    required this.trendColor,
  });
}
