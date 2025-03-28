import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/appointment_entity.dart';

class TimeWidget extends StatelessWidget {
  final AppointmentEntity appointment;
  const TimeWidget({
    super.key,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    final endData =
        appointment.date.add(Duration(minutes: appointment.durationMinutes));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              DateFormat('HH:mm').format(appointment.date),
              style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Text(
              DateFormat('HH:mm').format(endData),
              style: TextStyle(
                color: AppColors.textGreyDark,
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
