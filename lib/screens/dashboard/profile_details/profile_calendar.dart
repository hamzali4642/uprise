import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';

import '../../../helpers/colors.dart';

class ProfileCalendar extends StatefulWidget {
  const ProfileCalendar({Key? key}) : super(key: key);

  @override
  State<ProfileCalendar> createState() => _ProfileCalendarState();
}

class _ProfileCalendarState extends State<ProfileCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10),
          TableCalendar(
            headerStyle: const HeaderStyle(
              formatButtonVisible: false, // Hide the format button
              titleCentered: true,
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeights.medium),
            ),
            calendarStyle: const CalendarStyle(

              selectedDecoration: BoxDecoration(
                color: CColors.primary,
                shape: BoxShape.circle,
              ),
              defaultTextStyle: TextStyle(color: Colors.white),
              selectedTextStyle: TextStyle(color: Colors.black),
              todayTextStyle: TextStyle(color: Colors.white),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.white, fontSize: 13),
              weekendStyle: TextStyle(color: Colors.white, fontSize: 13),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            selectedDayPredicate: (date) {
              return isSameDay(_selectedDay, date);
            },
            focusedDay: _selectedDay!,
            firstDay: _focusedDay,
            lastDay: DateTime.now().add(const Duration(days: 3650)),
          )
        ],
      ),
    );
  }
}
