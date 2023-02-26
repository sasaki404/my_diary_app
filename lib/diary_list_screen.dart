import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_diary_app/data/database_helper.dart';
import 'package:my_diary_app/data/diary_entry.dart';

class DiaryListScreen extends StatefulWidget {
  @override
  _DiaryListScreenState createState() => _DiaryListScreenState();
}

class _DiaryListScreenState extends State<DiaryListScreen> {
  List<DiaryEntry> _diaryEntries = [];

  @override
  void initState() {
    super.initState();
    _loadDiaryEntries();
  }

  Future<void> _loadDiaryEntries() async {
    final entries = await DatabaseHelper.instance.getAllEntries();
    setState(() {
      _diaryEntries = entries;
    });
  }

  Future<void> _deleteEntry(int id) async {
    await DatabaseHelper.instance.delete(id);
    await _loadDiaryEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diary List'),
      ),
      body: ListView.builder(
        itemCount: _diaryEntries.length,
        itemBuilder: (context, index) {
          final entry = _diaryEntries[index];
          final date = DateFormat.yMd().format(entry.date);
          return Dismissible(
            key: Key(entry.id.toString()),
            onDismissed: (direction) async {
              await _deleteEntry(entry.id!);
            },
            child: ListTile(
              title: Text(date),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add entry functionality
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
