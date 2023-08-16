import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';

void showWarningToast(BuildContext context, String message) {
  final snackBar = SnackBar(
    padding: const EdgeInsets.all(16),
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
      textAlign: TextAlign.center,
    ),
    behavior: SnackBarBehavior.floating,
    duration: const Duration(milliseconds: 800),
    backgroundColor: AppColor.errorColor,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showSuccessToast(BuildContext context, String message) {
  final snackBar = SnackBar(
    padding: const EdgeInsets.all(16),
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
      textAlign: TextAlign.center,
    ),
    behavior: SnackBarBehavior.floating,
    duration: const Duration(milliseconds: 800),
    backgroundColor: AppColor.successColor,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
