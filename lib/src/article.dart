
class Article {
  final String? title;
  final String? author;
  final int length;
  final String? excerpt;
  final String? siteName;
  final String? imageUrl;
  final String? faviconUrl;
  final String? content;
  final String? textContent;
  final String? language;
  final String? publishedTime;

  Article({
    required this.title,
    required this.author,
    required this.length,
    required this.excerpt,
    required this.siteName,
    required this.imageUrl,
    required this.faviconUrl,
    required this.content,
    required this.textContent,
    required this.language,
    required this.publishedTime,
  });

  @override
  String toString() {
    return 'Article{title: $title,\n author: $author,\n length: $length,\n excerpt: $excerpt,\n siteName: $siteName,\n imageUrl: $imageUrl,\n faviconUrl: $faviconUrl,\n content: $content,\n textContent: $textContent,\n language: $language,\n publishedTime: $publishedTime}';
  }
}
