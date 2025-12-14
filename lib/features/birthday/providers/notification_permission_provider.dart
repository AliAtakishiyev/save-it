import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:save_it/utils/notification_service.dart';

class NotificationPermissionNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    return await NotificationService.isPermissionGranted();
  }

  Future<void> checkPermission() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return await NotificationService.isPermissionGranted();
    });
  }
}

final notificationPermissionProvider =
    AsyncNotifierProvider<NotificationPermissionNotifier, bool>(() {
  return NotificationPermissionNotifier();
});