import 'package:flutter/material.dart';

import 'SmartDevice.dart';

class Routine {
  final String name;
  final TimeOfDay time;
  final SmartDevice device;
  final bool  isDeviceOn;// false: Oven, true: AC

  Routine({required this.name, required this.time, required this.device, required this.isDeviceOn});
}