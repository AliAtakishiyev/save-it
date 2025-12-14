import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:save_it/features/birthday/data/repositories/birthday_repository.dart';
import 'package:save_it/features/birthday/models/birthday.dart';
import 'package:save_it/utils/notification_service.dart';

class BirthdayNotifier extends Notifier<List<Birthday>> {
  late BirthdayRepository repository = BirthdayRepository();

  @override
  List<Birthday> build() {
    return repository.getAllBirthdays();
  }

  Future<void> addBirthday(String name, DateTime date) async {
    await repository.addBirthday(name, date);
    state = repository.getAllBirthdays();

    final birthday = state.last;

    try {
      await NotificationService.scheduleBirthdayNotification(
        id: birthday.key,
        name: name,
        birthDate: date,
        message: 'Don\'t forget! $name\'s birthday is tomorrow! 🎉',
      );
    } catch (e) {
      // Notification failed (Samsung device issue) but birthday was added successfully
      print('Notification scheduling failed: $e');
    }
  }

  Future<void> deleteBirthday(int hiveId) async {
    await NotificationService.cancelNotification(hiveId);
    await repository.deleteBirthday(hiveId);
    state = repository.getAllBirthdays();
  }
}
