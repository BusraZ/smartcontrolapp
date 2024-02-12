import 'package:flutter/material.dart';
import 'package:smartcontrolapp/model/Routine.dart';
import 'package:smartcontrolapp/model/SmartDevice.dart';
import 'package:smartcontrolapp/utils/SHColorScheme.dart';
import '../main.dart';

class CreateRoutinePage extends StatefulWidget {
  final Function(Routine) onSave;

  const CreateRoutinePage({super.key, required this.onSave});

  @override
  _CreateRoutinePageState createState() => _CreateRoutinePageState();
}

class _CreateRoutinePageState extends State<CreateRoutinePage> {
  late TextEditingController routineNameController;
  TimeOfDay selectedTime = TimeOfDay.now();
  SmartDevice selectedDevice = SmartDevice.AC;
  bool isDeviceOn = false;

  @override
  void initState() {
    super.initState();
    routineNameController = TextEditingController();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: SHColorScheme.instance.primaryColor,
        backgroundColor: SHColorScheme.instance.whiteColor,
        title: const Text('New Routine'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Time: ${selectedTime.format(context)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: SHColorScheme.instance.primaryColor, // Butonun arka plan rengi
                // Diğer stil özelliklerini buraya ekleyebilirsiniz
              ),
              onPressed: () => _selectTime(context),
              child: const Text('Select Time'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: routineNameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Select Device: '),
                const SizedBox(width: 10),
                _buildDeviceTypeDropdown(),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Device Status: '),
                const SizedBox(width: 10),
                _buildDeviceStatusDropdown(),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: SHColorScheme.instance.primaryColor, // Butonun arka plan rengi
                // Diğer stil özelliklerini buraya ekleyebilirsiniz
              ),
              onPressed: () {
                String deviceName = selectedDevice == SmartDevice.AC ? 'AC' : 'LIGHT';
                String routineName = routineNameController.text;

                Routine newRoutine = Routine(
                  name: routineName,
                  time: selectedTime,
                  device: selectedDevice,
                  isDeviceOn: isDeviceOn,
                );

                // Rutini kaydetme callback fonksiyonunu çağır
                widget.onSave(newRoutine);

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceTypeDropdown() {
    return DropdownButton<SmartDevice>(
      value: selectedDevice,
      onChanged: (newValue) {
        setState(() {
          selectedDevice = newValue!;
        });
      },
      items: SmartDevice.values.map<DropdownMenuItem<SmartDevice>>(
        (SmartDevice value) {
          return DropdownMenuItem<SmartDevice>(
            value: value,
            child: Text(value == SmartDevice.LIGHT ? 'Light' : 'AC'),
          );
        },
      ).toList(),
    );
  }

  Widget _buildDeviceStatusDropdown() {
    return DropdownButton<bool>(
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
    );
  }
}
