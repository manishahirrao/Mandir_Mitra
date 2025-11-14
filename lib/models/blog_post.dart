class BlogPost {
  final String id;
  final String title;
  final String excerpt;
  final String content;
  final String author;
  final String authorAvatar;
  final DateTime date;
  final String imageUrl;
  final String category;
  final int readTime;

  BlogPost({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.content,
    required this.author,
    required this.authorAvatar,
    required this.date,
    required this.imageUrl,
    required this.category,
    required this.readTime,
  });
}
