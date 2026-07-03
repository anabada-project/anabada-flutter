import '../../models/app_notification.dart';
import '../../models/notice.dart';
import 'local_store.dart';

class LocalNoticeRepository {
  const LocalNoticeRepository(this._store);

  final LocalStore _store;

  Future<void> markNotificationRead(String notificationId) async {
    final int index = _store.notifications.indexWhere(
      (notification) => notification.id == notificationId,
    );
    if (index != -1) {
      _store.notifications[index] = _store.notifications[index].copyWith(
        isRead: true,
      );
    }
  }

  Future<Notice> create({
    required String title,
    required String content,
    required String author,
    required DateTime createdAt,
  }) async {
    final Notice notice = Notice(
      id: _store.newId('notice'),
      title: title,
      content: content,
      author: author,
      createdAt: createdAt,
    );
    _store.notices.insert(0, notice);
    _store.notifications.insert(
      0,
      AppNotification(
        id: _store.newId('notification'),
        userId: 'fake-user-1',
        type: AppNotificationType.notice,
        title: '공지사항',
        content: title,
        createdAt: createdAt,
        relatedNoticeId: notice.id,
      ),
    );
    return notice;
  }

  Future<void> update({
    required String noticeId,
    required String title,
    required String content,
    required String author,
    required DateTime createdAt,
  }) async {
    final int index = _store.notices.indexWhere(
      (notice) => notice.id == noticeId,
    );
    if (index == -1) throw StateError('공지를 찾을 수 없습니다.');
    _store.notices[index] = _store.notices[index].copyWith(
      title: title,
      content: content,
      author: author,
      createdAt: createdAt,
    );
  }

  Future<void> delete(String noticeId) async {
    _store.notices.removeWhere((notice) => notice.id == noticeId);
    _store.notifications.removeWhere(
      (notification) => notification.relatedNoticeId == noticeId,
    );
  }
}
