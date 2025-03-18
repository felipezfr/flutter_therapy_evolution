import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayHeaderWidget extends StatelessWidget {
  final DateTime date;
  const DayHeaderWidget({
    super.key,
    required this.date,
  });

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                date.day.toString(),
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('E').format(date),
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Text(
                    DateFormat('MMM yyyy').format(date),
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Visibility(
            visible: _isToday(date),
            child: Container(
              height: 40,
              width: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withAlpha(40),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Text(
                  'Today',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
