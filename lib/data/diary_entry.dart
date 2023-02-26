import 'package:flutter/material.dart';

class DiaryEntry {
  final int? id;
  final String memo;
  final DateTime date;
  final String mood;

  DiaryEntry({
    required this.id,
    required this.memo,
    required this.date,
    required this.mood,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'memo': memo,
      'date': date.toIso8601String(),
      'mood': mood,
    };
  }

  static DiaryEntry fromMap(Map<String, dynamic> map) {
    return DiaryEntry(
      id: map['id'],
      memo: map['memo'],
      date: DateTime.parse(map['date']),
      mood: map['mood'],
    );
  }
}
