import 'package:flutter/material.dart';

class SHColorScheme {
  static SHColorScheme? _instance;

  static SHColorScheme get instance {
    return _instance ??= SHColorScheme._init();
  }

  SHColorScheme._init();

  final Color primaryColor = const Color(0xff59bddd);
  final Color greenColor = const Color(0xff28cf5e);
  final Color lightBlueColor = const Color(0xFF8a9cd2);
  final Color whiteColor = Colors.white;
  final Color blackColor = Colors.black;
  final Color backgroundColor = const Color(0xfff5f5f5);
}
