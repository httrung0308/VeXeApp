import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vexe_app/main.dart';

void main() {
  testWidgets('VeXe app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: VeXeApp(),
      ),
    );

    // Verify that the app builds successfully with VeXe title
    expect(find.text('VeXe'), findsOneWidget);
  });
}
