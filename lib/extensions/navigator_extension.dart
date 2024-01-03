import 'package:flutter/material.dart';

extension NavigatorExtension on BuildContext {
  NavigatorState get navigator => Navigator.of(this);
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  void push(
    Widget page, {
    bool withAnimation = true,
  }) {
    if (withAnimation) {
      navigator.push(
        MaterialPageRoute(builder: (context) => page),
      );
      return;
    }

    navigator.push(
      PageRouteBuilder(
        pageBuilder: (context, _, __) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  void pop() {
    navigator.pop();
  }

  void showSnackBar(String message, {bool clearAllSnackBars = false}) {
    if (clearAllSnackBars) {
      scaffoldMessenger.clearSnackBars();
    }

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
