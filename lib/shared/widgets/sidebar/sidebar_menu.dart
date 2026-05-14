import 'package:flutter/material.dart';

import '../../../app/router/routes.dart';
import '../../../core/auth/role_permissions.dart';
import '../../../core/session/current_user.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';

class SidebarMenu extends StatelessWidget {
  final String currentRoute;

  const SidebarMenu({super.key, required this.currentRoute});

  static const double _drawerWidth = 245;

  @override
  Widget build(BuildContext context) {
    final String? currentRole = CurrentUser.role;

    final allMenuItems = [
      _SidebarItem(
        icon: Icons.dashboard_outlined,
        title: 'Dashboard',
        route: AppRoutes.dashboard,
      ),
      _SidebarItem(
        icon: Icons.bar_chart_outlined,
        title: 'Reportes',
        route: AppRoutes.reportes,
      ),
      _SidebarItem(
        icon: Icons.inventory_2_outlined,
        title: 'Bodega',
        route: AppRoutes.bodega,
      ),
      _SidebarItem(
        icon: Icons.build_outlined,
        title: 'Técnico',
        route: AppRoutes.tecnico,
      ),
      _SidebarItem(
        icon: Icons.point_of_sale_outlined,
        title: 'Ventas',
        route: AppRoutes.ventas,
      ),
      _SidebarItem(
        icon: Icons.group_outlined,
        title: 'Usuarios',
        route: AppRoutes.admin,
      ),
    ];

    final menuItems = allMenuItems.where((item) {
      return RolePermissions.canAccess(currentRole, item.route);
    }).toList();

    return Drawer(
      width: _drawerWidth,
      backgroundColor: AppColors.sidebarBackground,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppDimensions.spacingLarge),

            Image.asset(
              'assets/images/logo_ztech.png',
              height: 65,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: AppDimensions.spacingXSmall),

            const Text(
              'Gestión de notebooks',
              style: AppTextStyles.sidebarSubtitle,
            ),

            const SizedBox(height: 28),

            ...menuItems.map(
              (item) => _MenuItem(
                icon: item.icon,
                title: item.title,
                route: item.route,
                currentRoute: currentRoute,
              ),
            ),

            const Spacer(),

            const Divider(color: AppColors.divider, thickness: 1),

            ListTile(
              dense: true,
              leading: const Icon(Icons.logout, color: AppColors.logout),
              title: const Text('Cerrar sesión', style: AppTextStyles.logout),
              onTap: () {
                CurrentUser.logout();

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              },
            ),

            const SizedBox(height: AppDimensions.spacingMedium),
          ],
        ),
      ),
    );
  }
}

class _SidebarItem {
  final IconData icon;
  final String title;
  final String route;

  const _SidebarItem({
    required this.icon,
    required this.title,
    required this.route,
  });
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;
  final String currentRoute;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.route,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = currentRoute == route;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingSmall,
        vertical: AppDimensions.spacingXSmall,
      ),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.sidebarSelected : Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          icon,
          color: isSelected
              ? AppColors.sidebarTextSelected
              : AppColors.sidebarText,
          size: 22,
        ),
        title: Text(
          title,
          style: isSelected
              ? AppTextStyles.sidebarSelected
              : AppTextStyles.sidebarItem,
        ),

        onTap: () {
          if (currentRoute != route) {
            Navigator.pushReplacementNamed(context, route);
          } else {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
