import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayHeaderWidget extends StatelessWidget {
  final DateTime date;
  final Function(DateTime) onDateChanged;
  const DayHeaderWidget({
    super.key,
    required this.date,
    required this.onDateChanged,
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
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {
                      final newDate =
                          DateTime(date.year, date.month - 1, date.day);
                      onDateChanged(newDate);
                    },
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('EEEE').format(date),
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      Text(
                        DateFormat('MMMM yyyy').format(date),
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      final newDate =
                          DateTime(date.year, date.month + 1, date.day);
                      onDateChanged(newDate);
                    },
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
                  'Hoje',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
