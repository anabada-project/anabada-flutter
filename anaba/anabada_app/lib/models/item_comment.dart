class ItemComment {
  const ItemComment({
    required this.id,
    required this.itemId,
    required this.authorId,
    required this.authorName,
    required this.content,
    required this.createdAt,
    this.parentCommentId,
  });

  final String id;
  final String itemId;
  final String authorId;
  final String authorName;
  final String content;
  final DateTime createdAt;
  final String? parentCommentId;

  ItemComment copyWith({String? content}) {
    return ItemComment(
      id: id,
      itemId: itemId,
      authorId: authorId,
      authorName: authorName,
      content: content ?? this.content,
      createdAt: createdAt,
      parentCommentId: parentCommentId,
    );
  }
}
