import '../../models/app_notification.dart';
import '../../models/item_comment.dart';
import 'local_store.dart';

class LocalCommentRepository {
  const LocalCommentRepository(this._store);

  final LocalStore _store;

  Future<ItemComment> create({
    required String itemId,
    required String authorId,
    required String authorName,
    required String content,
    String? parentCommentId,
  }) async {
    final item = _store.itemById(itemId);
    final ItemComment comment = ItemComment(
      id: _store.newId('comment'),
      itemId: itemId,
      authorId: authorId,
      authorName: authorName,
      content: content,
      createdAt: DateTime.now(),
      parentCommentId: parentCommentId,
    );
    _store.comments.add(comment);

    if (item.ownerId != authorId) {
      _store.notifications.insert(
        0,
        AppNotification(
          id: _store.newId('notification'),
          userId: item.ownerId,
          type: AppNotificationType.comment,
          title: '새 댓글',
          content: '${item.title}에 새로운 댓글이 달렸어요.',
          createdAt: DateTime.now(),
          relatedItemId: item.id,
        ),
      );
    }
    return comment;
  }

  Future<void> update({
    required String commentId,
    required String authorId,
    required String content,
  }) async {
    final int index = _store.comments.indexWhere(
      (comment) => comment.id == commentId,
    );
    if (index == -1 || _store.comments[index].authorId != authorId) {
      throw StateError('수정할 수 없는 댓글입니다.');
    }
    _store.comments[index] = _store.comments[index].copyWith(content: content);
  }

  Future<void> delete({
    required String commentId,
    required String authorId,
  }) async {
    final ItemComment? comment = _store.comments
        .where((entry) => entry.id == commentId)
        .firstOrNull;
    if (comment == null || comment.authorId != authorId) {
      throw StateError('삭제할 수 없는 댓글입니다.');
    }

    final Set<String> deletedIds = {commentId};
    for (final ItemComment entry in _store.comments) {
      if (entry.parentCommentId == commentId) deletedIds.add(entry.id);
    }
    _store.comments.removeWhere((entry) => deletedIds.contains(entry.id));
  }

  Future<void> updateAuthorName({
    required String authorId,
    required String authorName,
  }) async {
    for (int index = 0; index < _store.comments.length; index++) {
      final ItemComment comment = _store.comments[index];
      if (comment.authorId == authorId) {
        _store.comments[index] = ItemComment(
          id: comment.id,
          itemId: comment.itemId,
          authorId: comment.authorId,
          authorName: authorName,
          content: comment.content,
          createdAt: comment.createdAt,
          parentCommentId: comment.parentCommentId,
        );
      }
    }
  }
}
