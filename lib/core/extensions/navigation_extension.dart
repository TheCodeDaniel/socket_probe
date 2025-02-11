import 'package:flutter/material.dart';

extension NavigationExtension on BuildContext {
  /// Pushes a new screen onto the navigation stack.
  Future<T?> push<T>(Widget page) {
    return Navigator.of(this).push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// Pushes a new screen on navigaiton stack via named
  Future<T?> pushNamed<T>(String name, {Object? arguments}) {
    return Navigator.of(this).pushNamed(name, arguments: arguments);
  }

  /// Replaces the current screen with a new one.
  Future<T?> pushReplacement<T, TO>(Widget page) {
    return Navigator.of(this).pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// Pops to the first screen in the stack and then pushes the new screen.
  Future<T?> pushAndRemoveUntil<T>(Widget page) {
    return Navigator.of(this).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  ///
  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop(result);
  }
}
