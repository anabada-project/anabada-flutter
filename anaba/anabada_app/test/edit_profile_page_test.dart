import 'package:anabada_app/pages/edit_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('정보수정 전공을 회원가입과 같은 목록에서 선택한다', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1080, 1920));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        home: EditProfilePage(initialMajor: 'FLUTTER'),
      ),
    );

    expect(find.text('플러터'), findsOneWidget);

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();

    for (final String major in [
      '백엔드',
      '프론트엔드',
      '디자인',
      '플러터',
      'iOS',
      '안드로이드',
      '기획',
      'AI',
    ]) {
      expect(find.text(major), findsWidgets);
    }
  });

  testWidgets('기존 한글 전공명도 선택값으로 유지한다', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1080, 1920));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        home: EditProfilePage(initialMajor: '디자인'),
      ),
    );

    expect(find.text('디자인'), findsOneWidget);
  });
}
