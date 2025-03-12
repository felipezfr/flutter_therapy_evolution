import 'package:flutter/material.dart';

class AlertWidget extends StatelessWidget {
  final Color color;
  final Color backgroundColor;
  final IconData? icon;
  final AssetImage? imageIcon;
  final String message;
  const AlertWidget(
      {super.key,
      required this.color,
      required this.backgroundColor,
      this.icon,
      this.imageIcon,
      required this.message});

  @override
  SnackBar build(BuildContext context) {
    return SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 13, 10, 13),
              child: SelectableText(
                message.isNotEmpty ? message : "Ocorreu um erro inesperado.",
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          imageIcon == null
              ? Icon(
                  icon,
                  color: color,
                  size: 20,
                )
              : ImageIcon(
                  imageIcon,
                  size: 20,
                ),
        ],
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: backgroundColor,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      width: 346,
    );
  }
}
