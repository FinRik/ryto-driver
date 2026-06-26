import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class TripCalendarCard extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final DateTime selectedTime;
  final Function(DateTime selected, DateTime focused) onDaySelected;

  const TripCalendarCard({
    super.key,
    required this.focusedDay,
    this.selectedDay,
    required this.selectedTime,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F2F5)),
      ),
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: focusedDay,
            selectedDayPredicate: (day) => isSameDay(selectedDay, day),
            onDaySelected: onDaySelected,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: false,
              titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            calendarStyle: const CalendarStyle(
              selectedDecoration: BoxDecoration(color: Color(0xFFD9E8FF), shape: BoxShape.circle),
              selectedTextStyle: TextStyle(color: Color(0xFF0061FF), fontWeight: FontWeight.bold),
              todayDecoration: BoxDecoration(color: Colors.transparent, shape: BoxShape.circle),
              todayTextStyle: TextStyle(color: Color(0xFF0061FF)),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Time", style: TextStyle(color: Color(0xFF1B2559), fontSize: 14)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F7FE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  DateFormat.jm().format(selectedTime),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}