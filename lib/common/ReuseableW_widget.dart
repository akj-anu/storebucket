// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ReuseableWidget {
  static snackMsg(BuildContext context, {Color? color, String? text}) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 1),
      backgroundColor: color,
      content: Text(text ?? 'TEST'),
    );
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
