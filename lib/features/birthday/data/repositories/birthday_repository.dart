import 'dart:async';

import 'package:hive/hive.dart';
import 'package:save_it/features/birthday/models/birthday.dart';

class BirthdayRepository {
  final box = Hive.box<Birthday>('birthday');

  List<Birthday> getAllBirthdays() {
    return box.values.toList();
  }

  Future<int> addBirthday(String name, DateTime date) async {
    final birthday = Birthday(
      date: date,
      name: name,
      remainingDay: 0,
      turningAge: 0,
    );

    final id = await box.add(birthday);

    return id;
  }

  Future<void> deleteBirthday(int hiveId) async {
    await box.delete(hiveId);
  }

  
}
