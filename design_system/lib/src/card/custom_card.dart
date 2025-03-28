import 'package:flutter/material.dart';

import '../../design_system.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final VoidCallback? onTapEdit;
  final VoidCallback? onTapDelete;
  final List<Widget>? children;
  final bool? titleIcon;

  const CustomCard({
    super.key,
    required this.title,
    this.onTap,
    this.onTapEdit,
    this.onTapDelete,
    this.children,
    this.titleIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: AppTheme.inputSeparator / 2),
      child: Material(
        elevation: 0,
        color: AppColors.greyLigth,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (titleIcon == true) ...[
                                CircleAvatar(
                                  backgroundColor: AppColors.primaryColor,
                                  child: Text(
                                    title.isNotEmpty
                                        ? title[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                              Text(
                                title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: AppColors.textGreyDark,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ...?children
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (onTapEdit != null || onTapDelete != null)
                Positioned(
                  right: 0,
                  top: 0,
                  child: MorePopup(
                    onTapEdit: onTapEdit,
                    onTapDelete: onTapDelete,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
