import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:votesmartk4/main.dart';

void main() {
  testWidgets('App Smoke Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const VoteSmartApp()); // Ganti jadi VoteSmartApp

    // Cek apakah splash screen muncul
    expect(find.text('VoteSmartK4'), findsOneWidget);
  });
}