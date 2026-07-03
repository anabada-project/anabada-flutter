import 'package:anabada_app/pages/auth/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows verification code fields after requesting a code', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SignUp()));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(1), 'new-user@test.com');
    await tester.tap(find.widgetWithText(OutlinedButton, '인증하기'));
    await tester.pump(const Duration(milliseconds: 150));

    expect(find.byType(TextFormField), findsNWidgets(10));
  });
}
