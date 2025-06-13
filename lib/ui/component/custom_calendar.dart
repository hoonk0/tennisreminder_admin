import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tennisreminder_core/const/value/box_deco.dart';
import 'package:tennisreminder_core/const/value/colors.dart';
import 'package:tennisreminder_core/const/value/text_style.dart';

class CustomCalendar extends TableCalendar {
  CustomCalendar({
    required super.focusedDay,
    required void Function(DateTime, DateTime) super.onDaySelected,
    required bool Function(DateTime) super.selectedDayPredicate,
    super.key,
  }) : super(
          locale: 'ko_KR',
          daysOfWeekHeight: 40,
          firstDay: DateTime.utc(1000),
          lastDay: DateTime.utc(3000),
          headerStyle: HeaderStyle(
            headerPadding: EdgeInsets.zero,
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: const TS.s20w500(colorGray900),
            leftChevronIcon: Icon(MdiIcons.chevronLeft, color: colorGray900, size: 30),
            rightChevronIcon: Icon(MdiIcons.chevronRight, color: colorGray900, size: 30),
          ),
          daysOfWeekStyle: const DaysOfWeekStyle(
            weekdayStyle: TS.s16w600(colorGray900),
            weekendStyle: TS.s16w600(colorGray900),
          ),
          calendarStyle:  CalendarStyle(
            isTodayHighlighted: true,
            defaultTextStyle: const TS.s16w500(colorGray900),
            defaultDecoration: const BD.defaultCircle(colorWhite),
            todayTextStyle: const TS.s16w500(colorGray900),
            todayDecoration: BD.todayCircle(colorWhite),
            outsideTextStyle: const TS.s16w500(colorGray300),
            outsideDecoration: const BD.defaultCircle(colorWhite),
            weekendTextStyle: const TS.s16w500(colorGray900),
            weekendDecoration: const BD.defaultCircle(colorWhite),
            selectedTextStyle: const TS.s16w500(colorWhite),
            selectedDecoration: const BD.defaultCircle(colorBlue600),
          ),
        );
}
