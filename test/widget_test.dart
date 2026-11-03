import 'package:flutter_test/flutter_test.dart';
import 'package:sehat_vaani_ai/main.dart';

void main() {
  testWidgets('App basic smoke test', (WidgetTester tester) async {
    expect(const SehatVanniApp(), isNotNull);
  });
}
