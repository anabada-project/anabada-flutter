import '../../../models/item_comment.dart';

class ItemCommentMapper {
  const ItemCommentMapper._();

  static ItemComment fromJson(
    Map<String, dynamic> json, {
    ItemComment? fallback,
    String? currentUserId,
    String? currentUserName,
    required String Function() fallbackId,
  }) {
    final bool isCurrentUser = json['writer'] == true;
    final String responseAuthorId =
        _stringValue(
          json['userId'] ??
              json['user_id'] ??
              json['authorId'] ??
              json['author_id'] ??
              json['writerId'] ??
              json['writer_id'],
        ) ??
        fallback?.authorId ??
        '';
    final String authorId =
        (isCurrentUser ? _nonEmptyValue(currentUserId) : null) ??
        responseAuthorId;
    final bool matchesCurrentUser =
        currentUserId != null &&
        currentUserId.isNotEmpty &&
        authorId == currentUserId;
    final String authorName =
        ((isCurrentUser || matchesCurrentUser)
            ? _nameValue(currentUserName)
            : null) ??
        _nameValue(fallback?.authorName) ??
        _nameValue(
          json['userName'] ??
              json['user_name'] ??
              json['accountName'] ??
              json['account_name'] ??
              json['memberName'] ??
              json['member_name'] ??
              json['authorName'] ??
              json['author_name'] ??
              json['nickname'] ??
              _nestedUserName(json['user']),
        ) ??
        '사용자';

    return ItemComment(
      id:
          _stringValue(json['id'] ?? json['commentId'] ?? json['comment_id']) ??
          fallback?.id ??
          fallbackId(),
      itemId:
          _stringValue(
            json['productId'] ??
                json['product_id'] ??
                json['postId'] ??
                json['post_id'] ??
                json['itemId'] ??
                json['item_id'],
          ) ??
          fallback?.itemId ??
          '',
      authorId: authorId,
      authorName: authorName,
      content:
          _stringValue(json['content'] ?? json['comment_content']) ??
          fallback?.content ??
          '',
      createdAt:
          _dateValue(json['createdAt'] ?? json['created_at']) ??
          fallback?.createdAt ??
          DateTime.now(),
      parentCommentId:
          _stringValue(
            json['parentCommentId'] ??
                json['parent_comment_id'] ??
                json['parentId'] ??
                json['parent_id'],
          ) ??
          fallback?.parentCommentId,
    );
  }

  static String? _stringValue(dynamic value) => value?.toString();

  static String? _nonEmptyValue(String? value) {
    if (value == null || value.isEmpty) return null;
    return value;
  }

  static String? _nameValue(dynamic value) {
    if (value is! String || value.trim().isEmpty) return null;
    return value.trim();
  }

  static String? _nestedUserName(dynamic user) {
    if (user is! Map) return null;
    return _nameValue(
      user['name'] ??
          user['userName'] ??
          user['user_name'] ??
          user['accountName'] ??
          user['account_name'] ??
          user['nickname'],
    );
  }

  static DateTime? _dateValue(dynamic value) {
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
