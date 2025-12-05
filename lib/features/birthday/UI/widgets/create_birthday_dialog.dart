import 'package:flutter/material.dart';

class CreateBirthdayDialog extends StatefulWidget {
  const CreateBirthdayDialog({super.key});

  @override
  State<CreateBirthdayDialog> createState() => _CreateBirthdayDialogState();
}

class _CreateBirthdayDialogState extends State<CreateBirthdayDialog> {
  
  @override
  void initState() {
    super.initState();
    // DO YOUR STUFF
  }

  @override
  void dispose() {
    // DO YOUR STUFF
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(0)
      ),
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("data")
          ],
        ),
      ),
    );
  }
}
