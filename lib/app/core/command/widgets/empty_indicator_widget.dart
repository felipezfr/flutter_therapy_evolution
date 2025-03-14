import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class EmptyIndicatorWidget extends StatelessWidget {
  final String? howRegisterMessage;
  final String? emptyMessage;
  final IconData? iconData;

  const EmptyIndicatorWidget({
    super.key,
    this.howRegisterMessage,
    this.emptyMessage,
    this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData ?? Icons.add_task_rounded,
              size: 64,
              color: AppColors.primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage ?? 'Voce ainda não tem nenhum registro cadastrado',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              howRegisterMessage ?? 'Clique no botão + para adicionar',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
