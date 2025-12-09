import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:save_it/features/birthday/domain/birthday_notifier.dart';
import 'package:save_it/features/birthday/models/birthday.dart';

final birthdayProvider = NotifierProvider<BirthdayNotifier, List<Birthday>>(
  () => BirthdayNotifier(),
);
