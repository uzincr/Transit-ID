import 'package:flutter_test/flutter_test.dart';
import 'package:transitid_mobile/main.dart';

void main() {
  testWidgets('TransitID app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TransitIdApp());
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Verify splash screen renders
    expect(find.text('TransitID'), findsWidgets);
  });
}
