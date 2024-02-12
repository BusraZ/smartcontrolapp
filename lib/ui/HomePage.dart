import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smartcontrolapp/model/Routine.dart';
import 'package:smartcontrolapp/utils/SHAsset.dart';
import 'package:smartcontrolapp/utils/SHColorScheme.dart';
import '../model/SmartDevice.dart';
import 'CreateRoutinePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  bool lightOn = false;
  bool acOn = false;
  List<Routine> routines = [];

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    // Ekran genişliğine göre düzeni seç
    if (shortestSide > 600) {
      // Tablet görünümü
      return _buildTabletLayout();
    } else {
      // Mobil görünümü
      return _buildMobileLayout();
    }
  }

  Widget _buildTabletLayout() {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        foregroundColor: SHColorScheme.instance.primaryColor,
        backgroundColor: SHColorScheme.instance.whiteColor,
        title: const Text('Smart Home App'),
      ),
      body: Row(
        children: [
          _buildControlPanel(),
          _buildRoutinesList(),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        foregroundColor: SHColorScheme.instance.primaryColor,
        backgroundColor: SHColorScheme.instance.whiteColor,
        title: const Text('Smart Home App'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 0.04.sh,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.06.sw),
            child: const Text(
              'Smart Devices',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
          ),
          _buildControlPanel(),
          _buildRoutinesList(),
        ],
      ),
    );
  }

  Widget _buildControlPanel() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.02.sh, horizontal: 0.06.sw),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 0.2.sh,
                width: 0.4.sw,
                decoration: BoxDecoration(
                  color: SHColorScheme.instance.whiteColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SvgPicture.asset(
                      SHAsset.smartLightSvg,
                      height: 0.08.sh,
                      color: lightOn ? Colors.yellow : null,
                    ),
                    const Text(
                      ' Smart Light ',
                      style: TextStyle(fontSize: 18),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(" ${lightOn ? "On" : "Off"}"),
                        Switch(
                          activeColor: SHColorScheme.instance.greenColor,
                          value: lightOn,
                          onChanged: (value) {
                            setState(() {
                              lightOn = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: 0.2.sh,
                width: 0.4.sw,
                decoration: BoxDecoration(
                  color: SHColorScheme.instance.whiteColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      SHAsset.airConditionerSvg,
                      height: 0.08.sh,
                      color: acOn ? SHColorScheme.instance.lightBlueColor : null,
                    ),
                    const Text(
                      ' Smart AC ',
                      style: TextStyle(fontSize: 18),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(" ${acOn ? "On" : "Off"}"),
                        Switch(
                          activeColor: SHColorScheme.instance.greenColor,
                          value: acOn,
                          onChanged: (value) {
                            setState(() {
                              acOn = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: SHColorScheme.instance.primaryColor, // Butonun arka plan rengi
                // Diğer stil özelliklerini buraya ekleyebilirsiniz
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateRoutinePage(
                      onSave: (Routine newRoutine) {
                        setState(() {
                          routines.add(newRoutine);
                          // Rutini çalıştırmak için bir zamanlayıcı başlat
                          _startRoutineTimer(newRoutine);
                        });
                      },
                    ),
                  ),
                );
              },
              child: const Text('Create New Routine'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutinesList() {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0.02.sh, horizontal: 0.06.sw),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Routines',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: routines.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0), // Kenarları oval yapmak için
                    ),
                    child: ListTile(
                      title: Text(routines[index].name),
                      subtitle: Text(
                        '${routines[index].time.format(context)} - ${routines[index].device.name} (${routines[index].isDeviceOn ? "Open" : "Close"})',
                      ),
                      onTap: () {
                        setState(() {
                          _showUpdateRoutineDialog(context, routines[index]);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateRoutineDialog(BuildContext context, Routine routine) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController nameController = TextEditingController(text: routine.name ?? "");
        TimeOfDay selectedTime = routine.time;
        bool isDeviceOn = routine.isDeviceOn;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          content: SizedBox(
            width: 0.8.sw,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SHColorScheme.instance.primaryColor, // Butonun arka plan rengi
                    // Diğer stil özelliklerini buraya ekleyebilirsiniz
                  ),
                  onPressed: () async {
                    TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (picked != null) {
                      setState(() {
                        selectedTime = picked;
                      });
                    }
                  },
                  child: const Text('Select Time'),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Device Status: '),
                    const SizedBox(width: 10),
                    DropdownButton<bool>(
                      value: isDeviceOn,
                      onChanged: (newValue) {
                        setState(() {
                          isDeviceOn = newValue!;
                        });
                      },
                      items: const [
                        DropdownMenuItem<bool>(
                          value: true,
                          child: Text('Open'),
                        ),
                        DropdownMenuItem<bool>(
                          value: false,
                          child: Text('Close'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: SHColorScheme.instance.primaryColor, // Butonun arka plan rengi
                // Diğer stil özelliklerini buraya ekleyebilirsiniz
              ),
              onPressed: () {
                Routine updatedRoutine = Routine(
                  name: nameController.text,
                  time: selectedTime,
                  device: routine.device,
                  isDeviceOn: isDeviceOn,
                );
                _updateRoutine(routine, updatedRoutine);
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _updateRoutine(Routine oldRoutine, Routine updatedRoutine) {
    setState(() {
      routines.remove(oldRoutine);
      routines.add(updatedRoutine);

      _startRoutineTimer(updatedRoutine);
    });
  }

  void _startRoutineTimer(Routine routine) {
    DateTime now = DateTime.now();
    DateTime scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      routine.time.hour,
      routine.time.minute,
    );
    Timer(Duration(seconds: scheduledTime.difference(now).inSeconds), () {
      _runRoutine(routine);
    });
  }

  void _runRoutine(Routine routine) {
    // Seçilen cihaz ve saate göre belirli bir işlemi gerçekleştir
    if (routine.device == SmartDevice.AC) {
      setState(() {
        acOn = routine.isDeviceOn;
      });
    } else {
      setState(() {
        lightOn = routine.isDeviceOn;
      });
    }
  }
}
