import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:save_it/features/birthday/data/repositories/birthday_repository.dart';
import 'package:save_it/features/birthday/models/birthday.dart';

class BirthdayNotifier extends Notifier<List<Birthday>> {
  late BirthdayRepository repository = BirthdayRepository();

  @override
  List<Birthday> build() {
    final repository = BirthdayRepository();
    return repository.getAllBirthdays();
  }

  Future<void> addNote(String name, DateTime date) async {
    await repository.addBirthday(name, date);
    state = repository.getAllBirthdays();
  }

  Future<void> deleteNote(int hiveId) async {
    await repository.deleteBirthday(hiveId);
    state = repository.getAllBirthdays();
  }
}
