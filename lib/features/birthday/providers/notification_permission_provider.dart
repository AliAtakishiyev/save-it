import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:save_it/utils/notification_service.dart';

final notificationPermissionProvider = FutureProvider<bool>((ref) async {
  return await NotificationService.isPermissionGranted();
});
