import 'package:flutter_test/flutter_test.dart';
import 'package:studia_complate/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const StudiaApp());
    expect(find.byType(StudiaApp), findsOneWidget);
  });
}
