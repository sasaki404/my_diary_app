import 'package:flutter/material.dart';

class MoodIcon {
  static const sun = Icons.wb_sunny;
  static const rainy = Icons.beach_access;
  static const cloudy = Icons.cloud;
  static const thunderstorm = Icons.flash_on;

  final IconData iconData;
  final String name;

  const MoodIcon(this.iconData, this.name);

  static const List<MoodIcon> icons = [
    MoodIcon(sun, '晴れ'),
    MoodIcon(rainy, '雨'),
    MoodIcon(cloudy, '曇り'),
    MoodIcon(thunderstorm, '雷'),
  ];

  static MoodIcon getMoodIcon(String name) {
    return icons.firstWhere((icon) => icon.name == name, orElse: () => icons.first);
  }
}
