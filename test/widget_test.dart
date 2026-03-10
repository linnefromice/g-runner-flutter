import 'package:flutter_test/flutter_test.dart';

import 'package:g_runner/main.dart';

void main() {
  testWidgets('App starts with title screen', (WidgetTester tester) async {
    await tester.pumpWidget(const GRunnerApp());
    expect(find.text('G-RUNNER'), findsOneWidget);
    expect(find.text('START'), findsOneWidget);
  });
}
