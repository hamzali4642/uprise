import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:uprise/widgets/event_widget.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';

import '../../../helpers/colors.dart';

typedef UserCallBack = void Function(int);

class ProfileCalendar extends StatefulWidget {
  const ProfileCalendar({Key? key, required this.callBack}) : super(key: key);

  final UserCallBack callBack;

  @override
  State<ProfileCalendar> createState() => _ProfileCalendarState();
}

class _ProfileCalendarState extends State<ProfileCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  late DataProvider provider;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 20), (){
      widget.callBack(1);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, value, child) {
      provider = value;
      var f = DateFormat("dd MMM yyyy");
      var cal = provider.userModel!.calendar
          .where((element) => element.date == f.parse(f.format(_selectedDay)))
          .toList();
      print(cal);
      List<String> ids = List.generate(cal.length, (index) => cal[index].event);
      var events =
          provider.events.where((element) => ids.contains(element.id)).toList();

      return Column(
        children: [
          const SizedBox(height: 10),
          TableCalendar(
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeights.medium,
              ),
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
            firstDay: DateTime(1970),
            lastDay: DateTime.utc(2030, 3, 14),
            // focusedDay: DateTime.now(),
            focusedDay: _selectedDay!,
          ),
          const SizedBox(height: 10),
          if (events.isEmpty)
            Container(
              height: 100,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: CColors.eventViewBgColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(7),
                  bottomRight: Radius.circular(7),
                ),
              ),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(15.0),
              child: const Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "No events scheduled.",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeights.medium,
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemBuilder: (ctx, i) {
                  return EventWidget(eventModel: events[i]);
                },
                itemCount: events.length,
              ),
            ),
        ],
      );
    });
  }
}
