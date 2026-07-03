import '../../../models/item_comment.dart';

class ItemCommentMapper {
  const ItemCommentMapper._();

  static ItemComment fromJson(
    Map<String, dynamic> json, {
    ItemComment? fallback,
    required String Function() fallbackId,
  }) {
    return ItemComment(
      id:
          _stringValue(json['id'] ?? json['commentId'] ?? json['comment_id']) ??
          fallback?.id ??
          fallbackId(),
      itemId:
          _stringValue(json['productId'] ?? json['postId'] ?? json['itemId']) ??
          fallback?.itemId ??
          '',
      authorId:
          _stringValue(
            json['userId'] ?? json['authorId'] ?? json['writerId'],
          ) ??
          fallback?.authorId ??
          '',
      authorName:
          _stringValue(
            json['userName'] ?? json['authorName'] ?? json['writer'],
          ) ??
          fallback?.authorName ??
          '',
      content: _stringValue(json['content']) ?? fallback?.content ?? '',
      createdAt:
          _dateValue(json['createdAt'] ?? json['created_at']) ??
          fallback?.createdAt ??
          DateTime.now(),
      parentCommentId:
          _stringValue(json['parentCommentId'] ?? json['parentId']) ??
          fallback?.parentCommentId,
    );
  }

  static String? _stringValue(dynamic value) => value?.toString();

  static DateTime? _dateValue(dynamic value) {
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
