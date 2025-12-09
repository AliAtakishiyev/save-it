import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:save_it/features/birthday/providers/birthday_provider.dart';

class CreateBirthdayDialog extends ConsumerStatefulWidget {
  final BuildContext rootContext;

  const CreateBirthdayDialog({super.key, required this.rootContext});

  @override
  ConsumerState<CreateBirthdayDialog> createState() =>
      _CreateBirthdayDialogState();
}

class _CreateBirthdayDialogState extends ConsumerState<CreateBirthdayDialog> {
  DateTime? picked;
  String? month;
  String? day;
  String? year;
  TextEditingController name = TextEditingController();

  @override
  void initState() {
    super.initState();
    // DO YOUR STUFF
  }

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xffFDFBF8),
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(0),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close, size: 20),
                ),
              ),
              Text(
                "Add Birthday",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Text(
                "Save a birthday and get reminded 24 hours before!",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: Color(0xff826C61),
                ),
              ),

              SizedBox(height: 36),

              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        "Name",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    TextField(
                      controller: name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffE66F50),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),

                    SizedBox(height: 32),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        "Birthday",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: SizedBox(
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () async {
                            DateTime? date = await showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              lastDate: DateTime(DateTime.now().year),
                            );

                            if (date != null) {
                              setState(() {
                                picked = date;
                                month = DateFormat("MMMM").format(date);
                                day = DateFormat("dd").format(date);
                                year = DateFormat("yyyy").format(date);
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Color(0xffFDFBF8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(20),
                              side: BorderSide(
                                color: Color(0xffE6E0DA),
                                width: 2,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Icon(
                                  Icons.calendar_month_outlined,
                                  size: 20,
                                  color: Color(0xff846C61),
                                ),
                              ),
                              Text(
                                (picked == null)
                                    ? "Pick a date"
                                    : "$month $day, $year",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: Color(0xff826C61),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (name.text.isNotEmpty && picked != null) {
                              await ref
                                  .read(birthdayProvider.notifier)
                                  .addNote(name.value.text, picked!);

                              if (mounted) {
                                Navigator.pop(context);
                              }
                            } else {
                              Fluttertoast.showToast(
                                msg: "Fill name and birthday first!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: Color(0xffFDFBF8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(20),
                            ),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xffEB6B5F), Color(0xffEC637B)],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),

                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: double.infinity,
                              child: Text(
                                "Save Birthday",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: .w800,
                                ),
                              ),
                            ),
                          ),
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
    );
  }
}
