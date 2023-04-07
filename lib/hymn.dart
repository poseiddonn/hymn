class Hymn {
  final String id;
  final String titleEn;
  final String titleYor;
  final String lyricsEn;
  final String lyricsYor;
  final int number;

  Hymn({
    required this.number,
    required this.id,
    required this.titleEn,
    required this.titleYor,
    required this.lyricsEn,
    required this.lyricsYor,
  });
}