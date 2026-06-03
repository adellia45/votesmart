import 'package:flutter_test/flutter_test.dart';
import 'package:votesmartk4/main.dart'; // Import VoteSmartApp

void main() {
  testWidgets('Splash screen bisa di-load', (WidgetTester tester) async {
    // GANTI MyApp() MENJADI VoteSmartApp()
    await tester.pumpWidget(const VoteSmartApp()); 
    
    // Cek apakah text VoteSmart4 muncul di Splash Screen
    expect(find.text('VoteSmart4'), findsOneWidget);
    
    // Tunggu 2 detik (sesuai delay di splash screen kamu)
    await tester.pump(const Duration(seconds: 2));
  });
}