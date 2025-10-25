class Article {
  final String title;
  final String description;
  final String urlToImage;

  Article({
    required this.title,
    required this.description,
    required this.urlToImage,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'Tanpa Judul',
      description: json['description'] ?? 'Tidak ada deskripsi',
      urlToImage: json['urlToImage'] ??
          'https://via.placeholder.com/300x200.png?text=No+Image',
    );
  }
}