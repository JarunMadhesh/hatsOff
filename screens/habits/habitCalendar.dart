import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:hatsoff/providers/habits.dart';
import 'package:hatsoff/providers/notificationsProvider.dart';
import 'package:provider/provider.dart';

class HabitCalendar extends StatefulWidget {
  final List<NotificationData> recordList;

  const HabitCalendar(this.recordList);

  @override
  _HabitCalendarState createState() => _HabitCalendarState();
}

class _HabitCalendarState extends State<HabitCalendar> {
  int pageIndex = 0;
  bool _isUnderDates = false;
  final _nowTime = DateTime.now();

  PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController =
        PageController(initialPage: 0, viewportFraction: 0.853, keepPage: true);
  }

  @override
  void dispose() {
    super.dispose();
    if (pageController != null) pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        if (widget.recordList.length != 0)
          Container(
            height: height * 0.142,
            child: PageView.builder(
              controller: pageController,
              itemCount: widget.recordList.length,
              pageSnapping: true,
              onPageChanged: (int index) {
                setState(() {
                  pageIndex = index;
                });
              },
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, i) {
                Habit _habit = Provider.of<HabitProvider>(context)
                    .getHabitById(widget.recordList[i].habitId);
                return Container(
                  width: width * 0.5,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: height * 0.142,
                        width: width * 0.781,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(6, 6),
                                  blurRadius: 6,
                                  color:
                                      const Color(0xff9F9F9F).withOpacity(0.16))
                            ],
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: const Color(0xffE5E2E2), width: 1)),
                        child: Center(
                          child: AutoSizeText(
                            _habit.name,
                            maxLines: 1,
                            style: const TextStyle(
                              fontFamily: 'sofia',
                              fontSize: 32,
                              fontWeight: FontWeight.w300,
                              color: const Color(0xff8b8b8b),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        SizedBox(
            height:
                widget.recordList.length != 0 ? height * 0.01 : height * 0.04),
        if (widget.recordList.length != 0)
          Container(
            height: height * 0.41,
            padding: EdgeInsets.symmetric(horizontal: width * 0.1),
            child: CalendarCarousel(
              childAspectRatio: 1.1,
              headerMargin: EdgeInsets.all(height * 0.015),
              weekDayPadding: EdgeInsets.all(height * 0.01),
              dayButtonColor: Colors.transparent,
              selectedDayButtonColor: Theme.of(context).primaryColor,
              selectedDayBorderColor: Colors.transparent,
              todayBorderColor: Colors.transparent,
              todayButtonColor: Colors.transparent,
              daysTextStyle: const TextStyle(
                fontFamily: 'Sofia',
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Color(0xffffffff),
              ),
              headerTextStyle: const TextStyle(
                fontFamily: 'Sofia',
                fontSize: 21,
                fontWeight: FontWeight.w300,
                color: Color(0xff727272),
              ),
              showHeaderButton: false,
              headerTitleTouchable: false,
              weekendTextStyle: const TextStyle(
                fontFamily: 'Sofia',
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Colors.transparent,
              ),
              showOnlyCurrentMonthDate: true,
              maxSelectedDate: _nowTime,
              showIconBehindDayText: false,
              weekDayFormat: WeekdayFormat.narrow,
              weekdayTextStyle: TextStyle(
                fontFamily: 'Sofia',
                fontSize: 15,
                fontWeight: FontWeight.w300,
                color: Color(0xffa0a0a0),
              ),
              dayPadding: 2,
              minSelectedDate: widget.recordList[pageIndex].records[0].date,
              customDayBuilder: (
                bool isSelectable,
                int index,
                bool isSelectedDay,
                bool isToday,
                bool isPrevMonthDay,
                TextStyle textStyle,
                bool isNextMonthDay,
                bool isThisMonthDay,
                DateTime day,
              ) {
                if (day.toString().substring(0, 10) ==
                    widget.recordList[pageIndex].records[0].date
                        .toString()
                        .substring(0, 10)) {
                  _isUnderDates = true;
                }
                if (widget.recordList[pageIndex].records.indexWhere((element) {
                          return element.date.toString().substring(8, 10) ==
                              day.day.toString();
                        }) !=
                        -1 ||
                    _isUnderDates) {
                  if (day.toString().substring(0, 10) ==
                      DateTime.now().toString().substring(0, 10)) {
                    _isUnderDates = false;
                  }

                  final index = widget.recordList[pageIndex].records.indexWhere(
                      (element) =>
                          element.date.toString().substring(8, 10) ==
                          day.day.toString());
                  if (index >= 0) {
                    if (widget.recordList[pageIndex].records[index].isDone) {
                      return Center(
                        child: CircleAvatar(
                          backgroundColor: Color(0xff85E21E),
                          child: AutoSizeText(
                            day.day < 10 ? '0${day.day}' : day.day.toString(),
                            style: const TextStyle(
                              fontFamily: 'Sofia',
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: const Color(0xffffffff),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Center(
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).splashColor,
                          child: AutoSizeText(
                            day.day < 10 ? '0${day.day}' : day.day.toString(),
                            style: const TextStyle(
                              fontFamily: 'Sofia',
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: const Color(0xffffffff),
                            ),
                          ),
                        ),
                      );
                    }
                  }
                  return Center(
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).splashColor,
                      child: AutoSizeText(
                        day.day < 10 ? '0${day.day}' : day.day.toString(),
                        style: const TextStyle(
                          fontFamily: 'Sofia',
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xffffffff),
                        ),
                      ),
                    ),
                  );
                }

                return Center(
                  child: CircleAvatar(
                    backgroundColor: Color(0xffE4E4E4),
                    child: AutoSizeText(
                      day.day < 10 ? '0${day.day}' : day.day.toString(),
                      style: const TextStyle(
                        fontFamily: 'Sofia',
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xffa0a0a0),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        if (widget.recordList.length != 0) SizedBox(height: height * 0.01),
        if (widget.recordList.length != 0)
          Container(
            height: height * 0.137,
            width: height * 0.137,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(height * 0.0688),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff9F9F9F).withOpacity(0.41),
                  offset: const Offset(6, 6),
                  blurRadius: 6,
                )
              ],
              border: Border.all(color: Color(0xffEBEBEB)),
            ),
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.only(top: height * 0.016),
              child: AutoSizeText(
                Provider.of<HabitProvider>(context)
                    .habits
                    .firstWhere((element) =>
                        element.id == widget.recordList[pageIndex].habitId)
                    .streek
                    .toString(),
                    maxLines: 1,
                style: const TextStyle(
                  fontFamily: 'Sofia',
                  fontSize: 76,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xff727272),
                ),
              ),
            ),
          ),
        if (widget.recordList.length != 0) SizedBox(height: height * 0.016),
        if (widget.recordList.length != 0)
          const AutoSizeText(
            'Current streak',
            maxLines: 1,
            style: const TextStyle(
              fontFamily: 'Sofia Pro',
              fontSize: 17,
              fontWeight: FontWeight.w300,
              color: Color(0xff989898),
            ),
          ),
        if (widget.recordList.length == 0) SizedBox(height: height * 0.1),
        if (widget.recordList.length == 0)
          Container(
            width: width * 0.6,
            child: Column(children: [
              SizedBox(height: height * 0.15),
              const AutoSizeText(
                'No results',
                style: TextStyle(
                  fontFamily: 'Sofia Pro',
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                  color: Color(0xff717171),
                ),
              ),
              const AutoSizeText(
                "You have't started to do any habit yet",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Sofia Pro',
                  fontSize: 21,
                  fontWeight: FontWeight.w300,
                  color: Color(0xffd9d8d8),
                ),
              )
            ]),
          )
      ],
    );
  }
}
