import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/appointment_entity.dart';

class TimeWidget extends StatelessWidget {
  final AppointmentEntity appointment;
  const TimeWidget({
    super.key,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              appointment.startTime,
              style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              appointment.endTime,
              style: TextStyle(
                color: AppColors.greyDark,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        VerticalDivider(
          color: AppColors.secondaryColor,
          thickness: 2,
        ),
      ],
    );
  }
}
