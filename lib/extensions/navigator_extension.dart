import 'package:flutter/material.dart';

extension NavigatorExtension on BuildContext {
  NavigatorState get navigator => Navigator.of(this);

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
}
