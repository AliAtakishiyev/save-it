/*
Person name
Date
bool notification enabled
*/
import 'package:hive/hive.dart';

part 'birthday.g.dart';

@HiveType(typeId: 0)
class Birthday extends HiveObject {
  @HiveField(0)
  String? name;

  @HiveField(1)
  DateTime? date;

  @HiveField(2)
  int? remainingDay;

  @HiveField(3)
  int? turningAge;

  Birthday({
    required this.date,
    required this.name,
    required this.remainingDay,
    required this.turningAge,
  });
}
