import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:save_it/features/birthday/providers/birthday_provider.dart';
import 'package:save_it/utils/notification_service.dart';

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

  
  Widget build(BuildContext context) {
    final birthdays = ref.watch(birthdayProvider);

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
                textAlign: TextAlign.center,
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
                              lastDate: DateTime.now(),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: Color(
                                        0xffF7CE54,
                                      ), // Header background color
                                      onPrimary: Color(
                                        0xffFDFBF8,
                                      ), // Header text color
                                      onSurface:
                                          Colors.black, // Default text color
                                    ),

                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        foregroundColor:
                                            Colors.black, // Buttons (OK/CANCEL)
                                      ),
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
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
                              final exist = birthdays.any(
                                (b) =>
                                    b.name!.toLowerCase() ==
                                    name.text.toLowerCase(),
                              );
                              if (exist) {
                                Fluttertoast.showToast(
                                  msg: "This name exist!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                );
                                return;
                              } 

                              try{
                                await ref.read(birthdayProvider.notifier).addBirthday(name.text, picked!);

                                if(mounted){
                                  Navigator.pop(context);
                                }
                              }catch(e){
                                print(e);
                                Fluttertoast.showToast(
                                  msg: "Failed to add birthday",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                );
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
