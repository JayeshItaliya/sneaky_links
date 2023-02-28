import 'package:flutter_test/flutter_test.dart';
import 'package:sneaky_links/main.dart';

void main() {
  testWidgets('app should work', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Hello, World!'), findsOneWidget);
  });
}