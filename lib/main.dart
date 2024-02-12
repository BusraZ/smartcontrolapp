import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'ui/HomePage.dart';

void main() => runApp(const MySmartHomeApp());

class MySmartHomeApp extends StatelessWidget {
  const MySmartHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(1920, 1080),
        builder: (BuildContext context, Widget? child) {
          return const MaterialApp(
            title: 'Smart Home App',
            home: HomePage(),
            debugShowCheckedModeBanner: false,
          );
        });
  }
}
