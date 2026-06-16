enum AppNotificationType { request, comment, favorite, notice }

class AppNotification {
  const AppNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.content,
    required this.createdAt,
    this.relatedItemId,
    this.relatedNoticeId,
    this.relatedRequestId,
    this.isRead = false,
  });

  final String id;
  final String userId;
  final AppNotificationType type;
  final String title;
  final String content;
  final DateTime createdAt;
  final String? relatedItemId;
  final String? relatedNoticeId;
  final String? relatedRequestId;
  final bool isRead;

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      userId: userId,
      type: type,
      title: title,
      content: content,
      createdAt: createdAt,
      relatedItemId: relatedItemId,
      relatedNoticeId: relatedNoticeId,
      relatedRequestId: relatedRequestId,
      isRead: isRead ?? this.isRead,
    );
  }
}
