import '../../../models/notice.dart';

class NoticeMapper {
  const NoticeMapper._();

  static Notice fromJson(
    Map<String, dynamic> json, {
    Notice? fallback,
    required String Function() fallbackId,
  }) {
    return Notice(
      id:
          _stringValue(json['id'] ?? json['noticeId'] ?? json['notice_id']) ??
          fallback?.id ??
          fallbackId(),
      title: _stringValue(json['title']) ?? fallback?.title ?? '',
      content: _stringValue(json['content']) ?? fallback?.content ?? '',
      author:
          _stringValue(json['author'] ?? json['writer'] ?? json['userName']) ??
          fallback?.author ??
          '관리자',
      createdAt:
          _dateValue(json['createdAt'] ?? json['created_at']) ??
          fallback?.createdAt ??
          DateTime.now(),
    );
  }

  static String? _stringValue(dynamic value) => value?.toString();

  static DateTime? _dateValue(dynamic value) {
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
