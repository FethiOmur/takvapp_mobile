class Story {
  final String imageUrl;
  final String label;
  final bool isLive;
  final String? contentText;
  final String? title;

  const Story({
    required this.imageUrl,
    required this.label,
    this.isLive = false,
    this.contentText,
    this.title,
  });
}
