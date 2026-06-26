import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DateSelectionBottomSheet extends StatefulWidget {
  const DateSelectionBottomSheet({super.key});

  @override
  State<DateSelectionBottomSheet> createState() =>
      _DateSelectionBottomSheetState();
}

class _DateSelectionBottomSheetState extends State<DateSelectionBottomSheet> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Header with Title and Close Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  size: 28,
                  color: Color(0xFF1B2559),
                ),
              ),
              const Text(
                "Select Date",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF33363E),
                ),
              ),
              const SizedBox(width: 48), // Balancing spacer
            ],
          ),
          const SizedBox(height: 20),

          // 2. Table Calendar Configuration
          TableCalendar(
            firstDay: DateTime.now(), // Disable selection for past days
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              Navigator.pop(context, _selectedDay);
            },
            // Matching the Custom Header Design
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              leftChevronIcon: _buildChevron(Icons.arrow_back),
              rightChevronIcon: _buildChevron(Icons.arrow_forward),
            ),
            // Styling the Grid and Days
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                color: Color(0xFF5F738C),
                fontWeight: FontWeight.w600,
              ),
              weekendStyle: TextStyle(
                color: Color(0xFF5F738C),
                fontWeight: FontWeight.w600,
              ),
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: const Color(0xFF0A83FF),
                shape: BoxShape.rectangle,
                border: Border.all(
                  color: const Color(0xFF222328),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              selectedDecoration: BoxDecoration(
                color: const Color(0xFF0A83FF),
                shape: BoxShape.rectangle,
                  border: Border.all(
                    color: const Color(0xFF222328),
                  ),
                borderRadius: BorderRadius.circular(8),
              ),
              selectedTextStyle: const TextStyle(
                color: Color(
                  0xFFE2FF54,
                ), // Highlighted yellow text on selection
                fontWeight: FontWeight.bold,
              ),
              defaultTextStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              disabledTextStyle: const TextStyle(
                color: Color(0xFFE0E5F2),
              ), // Faded past days
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildChevron(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.black, size: 20),
    );
  }
}
