import 'package:flutter/material.dart';
import 'hymn.dart';

class HymnPage extends StatelessWidget {
  final Hymn hymn;
  final String language;

  const HymnPage({Key? key, required this.hymn, required this.language})
      : super(key: key);

  String get title => language == 'en' ? hymn.titleEn : hymn.titleYor;

  String get lyrics => language == 'en' ? hymn.lyricsEn : hymn.lyricsYor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Text(
          lyrics,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}