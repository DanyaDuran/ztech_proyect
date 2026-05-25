import 'package:flutter/material.dart';

import 'package:ztech_flutter__app/core/theme/theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.secondary,
      elevation: 0,

      iconTheme: const IconThemeData(color: AppColors.textOnDark),

      title: Text(
        title,

        style: AppTextStyles.appBarTitle.copyWith(color: AppColors.textOnDark),
      ),
    );
  }
}
