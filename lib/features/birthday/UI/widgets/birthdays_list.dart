import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:save_it/features/birthday/providers/birthday_provider.dart';

class BirthdaysList extends ConsumerWidget {
  const BirthdaysList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final birthdays = ref.watch(birthdayProvider);

    return Expanded(
      child: ListView.builder(
        itemCount: birthdays.length,
        itemBuilder: (context, index) {
          int turning = 1;
          int remainingDay = 0;

          final birthday = birthdays[index];
          final date = birthday.date; // birthday
          final now = DateTime.now(); //now

          final month = DateFormat("MMMM").format(date!);
          final day = DateFormat("dd").format(date);

          // Step 1 — create this year's birthday
          final birthdayThisYear = DateTime(now.year, date.month, date.day);

          // Step 2 — check if it is upcoming or already passed
          late DateTime nextBirthday;

          if (birthdayThisYear.isAfter(now)) {
            // Birthday is still coming this year
            nextBirthday = birthdayThisYear;
            turning = now.year - date.year;
          } else {
            // Birthday already happened → use next year
            nextBirthday = DateTime(now.year + 1, date.month, date.day);
            turning = (now.year + 1) - date.year;
          }

          // Step 3 — calculate days remaining
          remainingDay = nextBirthday.difference(now).inDays;

          //final turning = yearNow - int.parse(year!);
          return Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: .circular(16)),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 8,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16, left: 8),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xffFCF0EC),
                        child: SvgPicture.asset(
                          "assets/cake_icon.svg",
                          width: 30,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            "${birthday.name}",
                            style: TextStyle(fontWeight: .bold, fontSize: 20),
                          ),
                          Text(
                            "$month $day • Turning $turning",
                            style: TextStyle(
                              color: Color(0xff826C61),
                              fontSize: 16,
                            ),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xffF4F0EA),

                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          "$remainingDay Days",
                          style: TextStyle(fontWeight: .w900, fontSize: 14),
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: () async {
                        await ref
                            .read(birthdayProvider.notifier)
                            .deleteBirthday(birthday.key);
                      },
                      icon: Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
