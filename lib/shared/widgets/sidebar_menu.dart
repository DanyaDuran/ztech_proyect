import 'package:flutter/material.dart';

class SidebarMenu extends StatelessWidget {
  final String currentRoute;

  const SidebarMenu({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF001233),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),

            Image.asset(
              'assets/images/logo_ztech.png',
              height: 70,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 4),

            const Text(
              'Gestión de notebooks',
              style: TextStyle(color: Color(0xFFB8C7D3), fontSize: 13),
            ),

            const SizedBox(height: 32),

            _MenuItem(
              icon: Icons.dashboard_outlined,
              title: 'Dashboard',
              route: '/dashboard',
              currentRoute: currentRoute,
            ),

            _MenuItem(
              icon: Icons.inventory_2_outlined,
              title: 'Bodega',
              route: '/bodega',
              currentRoute: currentRoute,
            ),

            _MenuItem(
              icon: Icons.build_outlined,
              title: 'Técnico',
              route: '/tecnico',
              currentRoute: currentRoute,
            ),

            _MenuItem(
              icon: Icons.point_of_sale_outlined,
              title: 'Ventas',
              route: '/ventas',
              currentRoute: currentRoute,
            ),

            _MenuItem(
              icon: Icons.group_outlined,
              title: 'Usuarios',
              route: '/admin',
              currentRoute: currentRoute,
            ),

            const Spacer(),

            const Divider(color: Color(0xFF2F4A5F), thickness: 1),

            ListTile(
              leading: const Icon(Icons.logout, color: Color(0xFFFFB4A2)),
              title: const Text(
                'Cerrar sesión',
                style: TextStyle(
                  color: Color(0xFFFFB4A2),
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
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
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1E4F6D) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.white : const Color(0xFFB8C7D3),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFFB8C7D3),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
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
