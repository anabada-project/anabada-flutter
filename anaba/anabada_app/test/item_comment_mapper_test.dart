import 'package:anabada_app/repositories/api/mappers/item_comment_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('댓글 작성자 ID가 로그인 사용자와 같으면 해당 사용자 이름을 표시한다', () {
    final comment = ItemCommentMapper.fromJson(
      {
        'comment_id': 1,
        'product_id': 10,
        'user_id': 'user-1',
        'writer': true,
        'comment_content': '댓글',
      },
      currentUserId: 'user-1',
      currentUserName: '홍길동',
      fallbackId: () => 'fallback',
    );

    expect(comment.authorName, '홍길동');
    expect(comment.content, '댓글');
  });

  test('writer true인 댓글은 현재 로그인 사용자 정보로 보정한다', () {
    final comment = ItemCommentMapper.fromJson(
      {
        'comment_id': 4,
        'user_id': 'comment-user',
        'user_name': '댓글작성자',
        'writer': true,
        'content': '댓글',
      },
      currentUserId: 'current-user',
      currentUserName: '현재사용자',
      fallbackId: () => 'fallback',
    );

    expect(comment.authorId, 'current-user');
    expect(comment.authorName, '현재사용자');
  });

  test('서버가 내려준 작성자 이름을 우선한다', () {
    final comment = ItemCommentMapper.fromJson(
      {
        'comment_id': 2,
        'user_name': '김아나',
        'writer': false,
        'content': '다른 사용자의 댓글',
      },
      currentUserId: 'user-1',
      currentUserName: '홍길동',
      fallbackId: () => 'fallback',
    );

    expect(comment.authorName, '김아나');
  });

  test('작성자 정보가 없어도 true나 false를 이름으로 표시하지 않는다', () {
    final comment = ItemCommentMapper.fromJson({
      'comment_id': 3,
      'writer': false,
      'content': '댓글',
    }, fallbackId: () => 'fallback');

    expect(comment.authorName, '사용자');
  });
}
