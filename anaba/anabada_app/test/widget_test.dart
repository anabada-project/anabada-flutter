// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:anabada_app/main.dart';
import 'package:anabada_app/pages/item_detail_page.dart';
import 'package:anabada_app/pages/item_list_page.dart';
import 'package:anabada_app/widgets/item_list_card.dart';

Future<void> login(WidgetTester tester) async {
  final fields = find.byType(TextFormField);
  await tester.enterText(fields.at(0), 's26010@gsm.hs.kr');
  await tester.enterText(fields.at(1), 'password123!');
  await tester.pump();

  final loginButton = find.widgetWithText(ElevatedButton, '로그인');
  await tester.ensureVisible(loginButton);
  await tester.tap(loginButton);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('로그인'), findsWidgets);
    expect(find.text('회원가입'), findsOneWidget);
  });

  testWidgets('moves to main page after successful login', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await login(tester);

    expect(find.text('아나바다'), findsOneWidget);
    expect(find.text('최근 올라온 물건'), findsOneWidget);
    expect(find.byType(TextFormField), findsNothing);
  });

  testWidgets('moves from main to item list and item detail', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await login(tester);

    await tester.tap(find.text('물건 조회'));
    await tester.pumpAndSettle();

    expect(find.byType(ItemListPage), findsOneWidget);

    await tester.tap(find.byType(ItemListCard).first);
    await tester.pumpAndSettle();

    expect(find.byType(ItemDetailPage), findsOneWidget);
    expect(find.text('교환 요청'), findsOneWidget);
  });
}
