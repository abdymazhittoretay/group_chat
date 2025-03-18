import 'package:flutter/material.dart';

void errorDialog(String error, BuildContext context) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          shape: LinearBorder(),
          content: Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
        ),
  );
}
