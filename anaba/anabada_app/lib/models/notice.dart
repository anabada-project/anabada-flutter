class Notice {
  const Notice({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String content;
  final String author;
  final DateTime createdAt;

  Notice copyWith({
    String? title,
    String? content,
    String? author,
    DateTime? createdAt,
  }) {
    return Notice(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      author: author ?? this.author,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
