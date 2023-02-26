import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_diary_app/data/diary_entry.dart';
import 'package:my_diary_app/data/database_helper.dart';
import 'package:my_diary_app/mood_icon.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final dbHelper = DatabaseHelper.instance;
  final _memoController = TextEditingController();
  MoodIcon? _selectedMoodIcon;
  final Map<DateTime, MoodIcon> _moods = {
    DateTime(2022, 2, 1): MoodIcon.icons[0],
    DateTime(2022, 2, 5): MoodIcon.icons[1],
    DateTime(2022, 2, 14): MoodIcon.icons[2],
    DateTime(2022, 2, 23): MoodIcon.icons[3],
  };

  Future<void> _showMemoDialog(DateTime date) async {
    _memoController.text = '';
    _selectedMoodIcon = MoodIcon.icons[0];
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return AlertDialog(
            title: Text(DateFormat('yyyy/MM/dd').format(date)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _memoController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Write your memo here',
                    ),
                  ),
                  SizedBox(height: 20.0),
                  DropdownButton<MoodIcon>(
                    value: _selectedMoodIcon,
                    onChanged: (MoodIcon? newValue) {
                      setState(() {
                        _selectedMoodIcon = newValue!;
                      });
                    },
                    items: MoodIcon.icons
                        .map(
                          (icon) => DropdownMenuItem<MoodIcon>(
                            value: icon,
                            child: Row(
                              children: [
                                Icon(icon.iconData),
                                SizedBox(width: 8),
                                Text(icon.name),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Save'),
                onPressed: () async {
                  DiaryEntry diaryEntry = DiaryEntry(
                    id: null,
                    date: date,
                    memo: _memoController.text,
                    mood: "晴",
                  );
                  int id = await dbHelper.insert(diaryEntry);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Saved')));
                },
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TableCalendar(
            firstDay: DateTime.utc(2010, 1, 1),
            lastDay: DateTime.now().add(Duration(days: 365)),
            focusedDay: DateTime.now(),
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.monday,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              outsideDaysVisible: false,
            ),
            onDaySelected: (selectedDay, focusedDay) {
              _showMemoDialog(selectedDay);
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                final mood = _moods[day];
                if (mood != null) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Icon(
                      mood.iconData,
                      size: 20,
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
