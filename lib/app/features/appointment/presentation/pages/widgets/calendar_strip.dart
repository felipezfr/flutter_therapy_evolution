import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarStrip extends StatefulWidget {
  final Function(DateTime date)? onDateSelected;
  final DateTime? initialDate;
  final List<DateTime>? checkedDays;

  const CalendarStrip({
    super.key,
    this.onDateSelected,
    this.initialDate,
    this.checkedDays,
  });

  @override
  State<CalendarStrip> createState() => _CalendarStripState();
}

class _CalendarStripState extends State<CalendarStrip> {
  late ScrollController _scrollController;
  late List<DateTime> _dates;
  late DateTime _selectedDate;
  late int _monthDays;

  late List<int>? checkedDays;

  @override
  void initState() {
    super.initState();
    checkedDays = widget.checkedDays?.map((e) => e.day).toList();
    // Scroll to today's position after render
  }

  void initialize() {
    _scrollController = ScrollController();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _dates = _getDaysInMonth(_selectedDate);
    _monthDays = _dates.length;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }

  void _scrollToSelectedDate() {
    final int today = _selectedDate.day;
    final double position = (today - 1) * 52.0; // Each date item width

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  List<DateTime> _getDaysInMonth(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    final lastDay = DateTime(date.year, date.month + 1, 0);

    final List<DateTime> days = [];
    for (int i = firstDay.day; i <= lastDay.day; i++) {
      days.add(DateTime(date.year, date.month, i));
    }

    return days;
  }

  @override
  Widget build(BuildContext context) {
    initialize();
    return _buildDateList();
  }

  Widget _buildDateList() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: _monthDays,
        itemBuilder: (context, index) {
          final DateTime date = _dates[index];
          final bool isToday = _isToday(date);
          final bool isSelected = _isSameDay(date, _selectedDate);

          final bool hasDate = checkedDays?.contains(date.day) ?? false;
          // print(hasDate);

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = date;
              });

              if (widget.onDateSelected != null) {
                widget.onDateSelected!(date);
              }
            },
            child: Stack(
              children: [
                Container(
                  width: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                    border: isToday && !isSelected
                        ? Border.all(
                            color: AppColors.primaryColor,
                            width: 1,
                          )
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('E').format(date).substring(0, 1),
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : isToday
                                  ? AppColors.primaryColor
                                  : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 8,
                  child: Visibility(
                    visible: hasDate,
                    child: Icon(
                      Icons.check_circle,
                      color: AppColors.green,
                      size: 12,
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
