import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:save_it/utils/notification_service.dart';

class NotificationPermissionNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    // Just check current status (no dialog)
    return await NotificationService.isPermissionGranted();
  }

  /// Actively asks user for permission
  Future<void> requestPermission() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      return await NotificationService.requestPermission();
    });
  }
}

final notificationPermissionProvider =
    AsyncNotifierProvider<NotificationPermissionNotifier, bool>(
      NotificationPermissionNotifier.new,
    );
