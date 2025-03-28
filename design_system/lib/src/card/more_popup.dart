import '../../design_system.dart';
import 'package:flutter/material.dart';

class MorePopup extends StatelessWidget {
  final VoidCallback? onTapEdit;
  final VoidCallback? onTapDelete;

  const MorePopup({
    super.key,
    required this.onTapEdit,
    required this.onTapDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.more_vert_rounded,
        color: AppColors.textGreyDark,
      ),
      onSelected: (String value) {
        if (value == 'edit' && onTapEdit != null) {
          onTapEdit!();
        } else if (value == 'delete' && onTapDelete != null) {
          onTapDelete!();
        }
      },
      itemBuilder: (BuildContext context) => [
        if (onTapEdit != null)
          const PopupMenuItem(
            value: 'edit',
            child: ListTile(
              leading: Icon(Icons.edit),
              title: Text('Editar'),
            ),
          ),
        if (onTapDelete != null)
          const PopupMenuItem(
            value: 'delete',
            child: ListTile(
              leading: Icon(Icons.delete),
              title: Text('Excluir'),
            ),
          ),
      ],
    );
  }
}
