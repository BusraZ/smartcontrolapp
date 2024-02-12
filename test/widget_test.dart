import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartcontrolapp/main.dart';
import 'package:smartcontrolapp/model/Routine.dart';
import 'package:smartcontrolapp/model/SmartDevice.dart';
import 'package:smartcontrolapp/ui/CreateRoutinePage.dart';
import 'package:smartcontrolapp/ui/HomePage.dart';

void main() {
  testWidgets('MySmartHomeApp UI Test', (WidgetTester tester) async {
    // Uygulamayı başlat
    await tester.pumpWidget(const MySmartHomeApp());
  });

  testWidgets('CreateRoutinePage UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: CreateRoutinePage(
          onSave: (Routine newRoutine) {
            // Mock bir onSave fonksiyonu ile çağrıldığını kontrol et
            expect(newRoutine.name, 'Test Routine');
            expect(newRoutine.device, SmartDevice.AC);
            expect(newRoutine.isDeviceOn, true);
            expect(newRoutine.time, isNotNull);
          },
        ),
      ),
    );

    // Bekleme süresi ekleyerek render işleminin tamamlanmasını sağla
    await tester.pumpAndSettle();

    // 'Select Time' butonuna tıkla
    await tester.tap(find.byType(ElevatedButton).first);

    // Bekleme süresi ekleyerek time picker'ın render işleminin tamamlanmasını sağla
    await tester.pumpAndSettle();

    // Time Picker'da saat seçimi yap
    await tester.pumpWidget(
      MaterialApp(
        home: CreateRoutinePage(
          onSave: (Routine newRoutine) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Time Picker'da bir saat seçimi yap
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // 'AC' seçeneğini içeren dropdown'u bul
    final deviceDropdown = find.descendant(
      of: find.byType(DropdownButton<SmartDevice>),
      matching: find.text('AC'),
    );
    expect(deviceDropdown, findsOneWidget);

    // Dropdown'ı aç ve 'LIGHT' seçeneğini bul
    await tester.tap(deviceDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('LIGHT').last);
    await tester.pumpAndSettle();

    // 'Open' seçeneğini içeren dropdown'u bul
    final statusDropdown = find.descendant(
      of: find.byType(DropdownButton<bool>),
      matching: find.text('Open'),
    );
    expect(statusDropdown, findsOneWidget);

    // Dropdown'ı aç ve 'Close' seçeneğini bul
    await tester.tap(statusDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Close').last);
    await tester.pumpAndSettle();

    // 'Name' TextField'ını bul ve değeri 'Test Routine' olarak ayarla
    await tester.enterText(find.byType(TextField), 'Test Routine');

    // 'Save' butonuna tıkla
    await tester.tap(find.byType(ElevatedButton).last);

    // Bekleme süresi ekleyerek render işleminin tamamlanmasını sağla
    await tester.pumpAndSettle();
  });
}
