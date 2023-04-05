// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class Hymn {
//   final String id;
//   final String titleEn;
//   final String titleYor;
//   final String lyricsEn;
//   final String lyricsYor;

//   Hymn({
//     required this.id,
//     required this.titleEn,
//     required this.titleYor,
//     required this.lyricsEn,
//     required this.lyricsYor,
//   });
// }
// class HymnList extends StatelessWidget {
//   final List<Hymn> hymns;
//   final String language;

//   const HymnList({Key? key, required this.hymns, required this.language})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: hymns.length,
//       itemBuilder: (context, index) {
//         final hymn = hymns[index];
//         final title = language == 'en' ? hymn.titleEn : hymn.titleYor;
//         return Card(
//           child: ListTile(
//             title: Text(title),
//             subtitle: Text('Hymn ${hymn.id}'),
//             onTap: () {
//               Navigator.of(context).push(MaterialPageRoute(
//                 builder: (context) => HymnPage(
//                   hymn: hymn,
//                   language: language,
//                 ),
//               ));
//             },
//           ),
//         );
//       },
//     );
//   }
// }

// class HymnSearchDelegate extends SearchDelegate<Hymn> {
//   final Function(String query) filterHymns;

//   HymnSearchDelegate({required this.filterHymns});

//   @override
//   String get searchFieldLabel => 'Search Hymns';
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: const Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//         },
//       ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, Hymn(id: '', lyricsEn: '', lyricsYor: '', titleEn: '', titleYor: ''),);
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     filterHymns(query);
//     return Container();
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return Container();
//   }
// }

// class HymnPage extends StatelessWidget {
//   final Hymn hymn;
//   final String language;

//   const HymnPage({Key? key, required this.hymn, required this.language})
//       : super(key: key);

//   String get title => language == 'en' ? hymn.titleEn : hymn.titleYor;

//   String get lyrics => language == 'en' ? hymn.lyricsEn : hymn.lyricsYor;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Text(
//           lyrics,
//           style: const TextStyle(fontSize: 18),
//         ),
//       ),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final List<Tab> tabs = [
//     const Tab(text: 'English'),
//     const Tab(text: 'Yoruba'),
//   ];
//   final searchController = TextEditingController();

//   List<Hymn> hymns = [];

//   List<Hymn> filteredHymns = [];

//   @override
//   void initState() {
//     super.initState();
//     loadHymns();
//   }

//   void loadHymns() async {
//     final data = await rootBundle.loadString('assets/hymns.json');
//     final jsonResult = json.decode(data);
//     final List<Hymn> hymns = List<Hymn>.from(jsonResult.map((model) {
//       return Hymn(
//         id: model['id'],
//         titleEn: model['title_en'],
//         titleYor: model['title_yor'],
//         lyricsEn: model['lyrics_en'],
//         lyricsYor: model['lyrics_yor'],
//       );
//     }));

//     setState(() {
//       this.hymns = hymns;
//       filteredHymns = hymns;
//     });
//   }

//   void filterHymns(String query) {
//     final lowerCaseQuery = query.toLowerCase();
//     final filtered = hymns.where((hymn) {
//       final title = hymn.titleEn.toLowerCase();
//       final id = hymn.id.toString();
//       final lyrics = hymn.lyricsEn.toLowerCase();
//       return title.contains(lowerCaseQuery) ||
//           id.contains(lowerCaseQuery) ||
//           lyrics.contains(lowerCaseQuery);
//     }).toList();
//     setState(() {
//       filteredHymns = filtered;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: tabs.length,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Hymn Book'),
//           bottom: TabBar(
//             tabs: tabs,
//             indicatorColor: Colors.white,
//           ),
//         ),
//         body: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               child: TextField(
//                 controller: searchController,
//                 onChanged: filterHymns,
//                 decoration: const InputDecoration(
//                   hintText: 'Search Hymns',
//                   prefixIcon: Icon(Icons.search),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: TabBarView(
//                 children: [
//                   HymnList(hymns: filteredHymns, language: 'en'),
//                   HymnList(hymns: filteredHymns, language: 'yor'),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }