import 'package:flutter_test/flutter_test.dart';
import 'package:cashtrack/app.dart';

void main() {
  testWidgets('CashTrack renders', (tester) async {
    await tester.pumpWidget(const CashTrackApp());
    expect(find.text('CashTrack'), findsOneWidget);
  });
}
