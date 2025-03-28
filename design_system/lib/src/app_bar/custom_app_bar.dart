import 'package:flutter/material.dart';

import '../../design_system.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppStyle.appBarTitle,
      ),
      backgroundColor: AppColors.whiteColor,
      actions: actions,
      leading: Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(
                Icons.chevron_left,
                color: AppColors.textGreyDark,
              ),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // Define a altura da AppBar
}
