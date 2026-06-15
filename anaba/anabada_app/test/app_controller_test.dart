import 'dart:typed_data';

import 'package:anabada_app/controllers/app_controller.dart';
import 'package:anabada_app/models/trade_item.dart';
import 'package:anabada_app/models/trade_request.dart';
import 'package:anabada_app/repositories/local_app_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppController controller;

  setUp(() {
    controller = AppController(LocalAppRepository());
  });

  test('item registration, like, comment, and request flow work locally', () async {
    final item = await controller.createItem(
      CreateTradeItemInput(
        title: '테스트 물건',
        description: '테스트 설명',
        wantedItem: '테스트 교환품',
        category: ItemCategory.etc,
        tradeMethod: TradeMethod.exchange,
        ownerId: 'owner',
        ownerName: '소유자',
        ownerGeneration: '10기',
        imageBytes: Uint8List.fromList([1, 2, 3]),
      ),
    );

    expect(controller.itemById(item.id)?.title, '테스트 물건');

    await controller.toggleLike(
      itemId: item.id,
      userId: 'requester',
      userName: '요청자',
    );
    expect(controller.itemById(item.id)?.isLikedBy('requester'), isTrue);

    final comment = await controller.createComment(
      itemId: item.id,
      authorId: 'requester',
      authorName: '요청자',
      content: '댓글',
    );
    expect(controller.commentsFor(item.id), hasLength(1));

    await controller.updateComment(
      commentId: comment.id,
      authorId: 'requester',
      content: '수정 댓글',
    );
    expect(controller.commentById(comment.id)?.content, '수정 댓글');

    final request = await controller.createTradeRequest(
      itemId: item.id,
      requesterId: 'requester',
      requesterName: '요청자',
    );
    await controller.updateTradeRequestStatus(
      requestId: request.id,
      status: TradeRequestStatus.accepted,
    );

    expect(
      controller.itemById(item.id)?.status,
      ItemTradeStatus.completed,
    );

    await controller.deleteComment(
      commentId: comment.id,
      authorId: 'requester',
    );
    expect(controller.commentsFor(item.id), isEmpty);
  });

  test('notice create, update, and delete flow works locally', () async {
    final notice = await controller.createNotice(
      title: '새 공지',
      content: '공지 내용',
      author: '관리자',
      createdAt: DateTime(2026, 6, 15),
    );

    expect(controller.noticeById(notice.id)?.title, '새 공지');

    await controller.updateNotice(
      noticeId: notice.id,
      title: '수정 공지',
      content: '수정 내용',
      author: '관리자',
      createdAt: DateTime(2026, 6, 16),
    );
    expect(controller.noticeById(notice.id)?.title, '수정 공지');

    await controller.deleteNotice(notice.id);
    expect(controller.noticeById(notice.id), isNull);
  });
}
