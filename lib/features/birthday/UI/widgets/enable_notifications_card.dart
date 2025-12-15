import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:save_it/features/birthday/providers/notification_permission_provider.dart';
import 'package:save_it/utils/notification_service.dart';

class EnableNotificationsCard extends ConsumerWidget {
  const EnableNotificationsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16),
      child: SizedBox(
        width: double.infinity,
        height: 120,
        child: Card(
          color: Color(0xffFBF1D8),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Color(0xffFBE7B5), width: 1),
            borderRadius: BorderRadiusGeometry.circular(16),
          ),

          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xffFAE6B2),
                  radius: 24,
                  child: Icon(Icons.notifications_off_outlined, size: 30),
                ),

                SizedBox(width: 16),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Enable notifications",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Get reminded 24 hours before each birthdy ",
                        maxLines: 2,
                        style: TextStyle(color: Color(0xff826D60)),
                      ),
                    ],
                  ),
                ),

                ElevatedButton(
                  onPressed: () async {
                    ref
                        .read(notificationPermissionProvider.notifier)
                        .requestPermission();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Color(0xffE66F50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          top: 10,
                          bottom: 10,
                        ),
                        child: Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          "Enable",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
