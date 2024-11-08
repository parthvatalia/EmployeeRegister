import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:group_button/group_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDatePicker extends StatefulWidget {
  final Function(DateTime?) onDateSelected;
  final DateTime? joiningDate;
  final DateTime? initialDate;

  const CustomDatePicker({
    Key? key,
    required this.onDateSelected,
    this.joiningDate,
    this.initialDate,
  }) : super(key: key);

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime? _selectedDate;
  late DateTime _currentMonth;
  late int _selectedButtonIndex;
  bool _noDateSelected = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      _selectedDate = widget.initialDate!;
      _noDateSelected = false;
    } else if (widget.joiningDate != null) {
      _selectedDate = DateTime.now();
      _noDateSelected = true;
    } else {
      _selectedDate = DateTime.now();
      _noDateSelected = false;
    }
    _currentMonth = DateTime(_selectedDate!.year, _selectedDate!.month);

    _selectedButtonIndex = _getInitialButtonIndex();
    _updateSelectedButton();
  }

  bool _isDateSelectable(DateTime date) {
    if (widget.joiningDate == null) return true;
    return !date.isBefore(widget.joiningDate!);
  }

  int _getInitialButtonIndex() {
    final now = DateTime.now();
    final isTodaySelectable = _isDateSelectable(now);

    if (widget.joiningDate != null) {
      if (_noDateSelected) {
        return 0;
      } else if (_isSameDay(widget.initialDate!, now) && isTodaySelectable) {
        return 1;
      }
    } else {
      if (_isSameDay(_selectedDate!, now)) {
        return 0;
      } else if (_isNextMonday(_selectedDate!)) {
        return 1;
      } else if (_isNextTuesday(_selectedDate!)) {
        return 2;
      } else if (_isSameDay(_selectedDate!, now.add(Duration(days: 7)))) {
        return 3;
      }
    }
    return -1;
  }

  void _updateSelectedButton() {
    final now = DateTime.now();
    final isTodaySelectable = _isDateSelectable(now);
    final oneWeekFromNow = now.add(Duration(days: 7));

    if (widget.joiningDate != null) {
      if (_noDateSelected) {
        _selectedButtonIndex = 0;
      } else if (_isSameDay(_selectedDate!, now) && isTodaySelectable) {
        _selectedButtonIndex = 1;
      } else {
        _selectedButtonIndex = -1;
      }
    } else {
      if (_isSameDay(_selectedDate!, now)) {
        _selectedButtonIndex = 0;
      } else if (_isNextMonday(_selectedDate!)) {
        _selectedButtonIndex = 1;
      } else if (_isNextTuesday(_selectedDate!)) {
        _selectedButtonIndex = 2;
      } else if (_isSameDay(_selectedDate!, oneWeekFromNow)) {
        _selectedButtonIndex = 3;
      } else {
        _selectedButtonIndex = -1;
      }
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool _isNextMonday(DateTime date) {
    final now = DateTime.now();
    return date.weekday == DateTime.monday &&
        date.isAfter(now) &&
        date.difference(now).inDays <= 7;
  }

  bool _isNextTuesday(DateTime date) {
    final now = DateTime.now();
    return date.weekday == DateTime.tuesday &&
        date.isAfter(now) &&
        date.difference(now).inDays <= 7;
  }

  void _updateSelectedDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      _currentMonth = DateTime(_selectedDate!.year, _selectedDate!.month);
      _noDateSelected = false;
      _updateSelectedButton();
    });
  }

  void _selectToday() {
    final now = DateTime.now();
    if (_isDateSelectable(now)) {
      _updateSelectedDate(now);
    }
  }

  void _selectNextMonday() {
    final now = DateTime.now();
    final daysUntilNextMonday = (DateTime.monday - now.weekday + 7) % 7;
    final nextMonday = now.add(Duration(days: daysUntilNextMonday));
    if (_isDateSelectable(nextMonday)) {
      _updateSelectedDate(nextMonday);
    }
  }

  void _selectNextTuesday() {
    final now = DateTime.now();
    final daysUntilNextTuesday = (DateTime.tuesday - now.weekday + 7) % 7;
    final nextTuesday = now.add(Duration(days: daysUntilNextTuesday));
    if (_isDateSelectable(nextTuesday)) {
      _updateSelectedDate(nextTuesday);
    }
  }

  void _selectAfterOneWeek() {
    final oneWeekFromNow = DateTime.now().add(Duration(days: 7));
    if (_isDateSelectable(oneWeekFromNow)) {
      _updateSelectedDate(oneWeekFromNow);
    }
  }

  void _notSelect() {
    setState(() {
      _selectedButtonIndex = 0;
      _noDateSelected = true;
      _selectedDate = null;
      widget.onDateSelected(null);
    });
  }

  void _onSave() {
    if (_noDateSelected) {
      widget.onDateSelected(null);
      Navigator.of(context).pop();
      return;
    }
    widget.onDateSelected(_selectedDate);
    Navigator.of(context).pop();
  }

  void _goToPreviousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isTodaySelectable = _isDateSelectable(now);
    final buttons = widget.joiningDate == null
        ? [
            "Today",
            "Next Monday",
            "Next Tuesday",
            "After 1 week",
          ]
        : [
            "No date",
            if (isTodaySelectable) "Today",
          ];
    return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0).r,
        backgroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 500,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16).r,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GroupButton(
                      isRadio: true,
                      maxSelected: 1,
                      options: GroupButtonOptions(
                        crossGroupAlignment: CrossGroupAlignment.center,
                        mainGroupAlignment: MainGroupAlignment.spaceEvenly,
                        buttonWidth: MediaQuery.of(context).size.width  / 2.5 > 200?200:MediaQuery.of(context).size.width  / 2.5,
                        direction: Axis.horizontal,
                        runSpacing: 6,
                        selectedTextStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                        unselectedTextStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff1DA1F2),
                        ),
                        selectedColor: Color(0xff1DA1F2),
                        unselectedColor: Color(0xffEDF8FF),
                      ),
                      onSelected: (button, index, isSelected) {
                        setState(() {
                          if (widget.joiningDate != null) {
                            switch (index) {
                              case 0:
                                _notSelect();
                                break;
                              case 1:
                                if (isTodaySelectable) _selectToday();
                                break;
                            }
                          } else {
                            switch (index) {
                              case 0:
                                _selectToday();
                                break;
                              case 1:
                                _selectNextMonday();
                                break;
                              case 2:
                                _selectNextTuesday();
                                break;
                              case 3:
                                _selectAfterOneWeek();
                                break;
                            }
                          }
                        });
                      },
                      controller: GroupButtonController(
                          selectedIndex: _selectedButtonIndex),
                      buttons: buttons,
                    ),
                    16.verticalSpace,
                    _buildMonthHeader(),
                    24.verticalSpace,
                    _buildDaysOfWeek(),
                    24.verticalSpace,
                    _buildDaysGrid(),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16).r,
                child: Row(
                  children: [
                    Icon(
                      Icons.event,
                      color: Color(0xff1DA1F2),
                      size: 20,
                    ),
                    SizedBox(width: 12,),
                    Text(
                      _selectedDate == null
                          ? "No Date"
                          : "${DateFormat('d MMM yyyy').format(_selectedDate!)}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 15)
                                    .r),
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xffEDF8FF)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                              ),
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff1DA1F2),
                            ),
                          ),
                        ),
                        SizedBox(width: 16,),
                        ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 21)
                                    .r),
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xff1DA1F2)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                              ),
                            ),
                          ),
                          onPressed: _onSave,
                          child: Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildMonthHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(Icons.arrow_left_rounded,
              color: Color(0xff949C9E), size: 40),
          onPressed: _goToPreviousMonth,
        ),
        Text(
          DateFormat.yMMMM().format(_currentMonth),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(Icons.arrow_right_rounded,
              color: Color(0xff949C9E), size: 40),
          onPressed: _goToNextMonth,
        ),
      ],
    );
  }

  Widget _buildDaysOfWeek() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
          .map((day) => Text(day,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15)))
          .toList(),
    );
  }

  Widget _buildDaysGrid() {
    final firstDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0);

    final firstDayOffset = firstDayOfMonth.weekday % 7;
    final lastDayOffset = (7 - lastDayOfMonth.weekday % 7) % 7;

    final daysInMonth = List.generate(
      lastDayOfMonth.day,
      (index) => DateTime(_currentMonth.year, _currentMonth.month, index + 1),
    );

    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 5,
        mainAxisSpacing: 3,
      ),
      itemCount: firstDayOffset + daysInMonth.length + lastDayOffset,
      itemBuilder: (context, index) {
        int dayIndex = index - firstDayOffset;
        if (dayIndex < 0 || dayIndex >= daysInMonth.length) {
          return Container();
        }
        final date = daysInMonth[dayIndex];
        final isSelectable = _isDateSelectable(date);
        final isBeforeJoiningDate =
            widget.joiningDate != null && date.isBefore(widget.joiningDate!);
        final isCurrentDate = _isSameDay(date, DateTime.now());
        final isSelectedDate = !_noDateSelected &&
            _selectedDate != null &&
            _isSameDay(date, _selectedDate!);
        return GestureDetector(
          onTap: isSelectable ? () => _updateSelectedDate(date) : null,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isCurrentDate ? Color(0xff1DA1F2) : Colors.transparent,
                width: 1,
              ),
              color: isSelectedDate ? Color(0xff1DA1F2) : Colors.transparent,
            ),
            child: Text(
              date.day.toString(),
              style: TextStyle(
                color: !isSelectable
                    ? Color(0xffE5E5E5)
                    : isSelectedDate
                        ? Colors.white
                        : Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }
}
