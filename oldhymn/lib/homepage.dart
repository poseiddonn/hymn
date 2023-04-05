import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class HymnSearchDelegate extends SearchDelegate {
  final Function(String) filterHymns;

  HymnSearchDelegate({required this.filterHymns});

  @override
  String get searchFieldLabel => 'Search Hymns';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    filterHymns(query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}

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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final List<Tab> tabs = [
    const Tab(text: 'English'),
    const Tab(text: 'Yoruba'),
  ];
  final searchController = TextEditingController();

  List<Hymn> hymns = [];

  List<Hymn> filteredHymns = [];
  List<Hymn> searchedlist = [];

  @override
  void initState() {
    super.initState();
    loadHymns();
  }

  void loadHymns() async {
    final data = await rootBundle.loadString('assets/hymns.json');
    final jsonResult = json.decode(data);
    final List<Hymn> hymnns = List<Hymn>.from(jsonResult.map((model) {
      return Hymn(
        number: int.parse(model['number']),
        id: model['id'],
        titleEn: model['title_en'],
        titleYor: model['title_yor'],
        lyricsEn: model['lyrics_en'],
        lyricsYor: model['lyrics_yor'],
      );
    }));

    setState(() {
      hymns = hymnns;
      filteredHymns = hymns;
    });
  }

////////////////////////////////////
  ///  WE ARE WORKING BELOW
  ///  SEARCH QUERY NOT WORKING AS EXPECTED
  ///

  void filterHymns(String query) {
    for (int i = 0; i < hymns.length; i++) {
      if (query == hymns[i].number.toString() ||
          hymns[i].titleEn.contains(query)) {
        setState(() {
          searchedlist.add(hymns[i]);
        });
      }
    }
    if (query == '') {
      setState(() {
        searchedlist.clear();
      });
    }
    // print(searchedlist[0].id);
    // if (searchedlist.isEmpty) {
    //   //Print dialog
    //   print('List Empty');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hymn Book'),
          bottom: TabBar(
            tabs: tabs,
            indicatorColor: Colors.white,
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: searchController,
                onChanged: (query) {
                  final lowerCaseQuery = query.toLowerCase();
                  filterHymns(query);
                  // .where((hymn) {
                  //   final title = hymn.titleEn.toLowerCase();
                  //   final id = hymn.id.toString();
                  //   final lyrics = hymn.lyricsEn.toLowerCase();
                  //   return title.contains(lowerCaseQuery) ||
                  //       id.contains(lowerCaseQuery) ||
                  //       lyrics.contains(lowerCaseQuery);
                  // }).toList();
                  // setState(() {
                  //   filteredHymns = filtered;
                  // });
                },
                decoration: const InputDecoration(
                  hintText: 'Search Hymns',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  hymnList(context, filteredHymns, searchedlist, 'en'),
                  hymnList(context, filteredHymns, searchedlist, 'yor'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget hymnList(
  BuildContext context,
  List<Hymn> hymns,
  List<Hymn> searchedlist,
  String language,
) {
  return searchedlist.isEmpty
      ? ListView.builder(
          itemCount: hymns.length,
          itemBuilder: (context, index) {
            final hymn = hymns[index];
            final title = language == 'en' ? hymn.titleEn : hymn.titleYor;
            return Card(
              child: ListTile(
                title: Text(title),
                subtitle: Text('Hymn ${hymn.id}'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HymnPage(
                      hymn: hymn,
                      language: language,
                    ),
                  ));
                },
              ),
            );
          },
        )
      : ListView.builder(
          itemCount: searchedlist.length,
          itemBuilder: (context, index) {
            final hymn = searchedlist[index];
            final title = (language == 'en') ? hymn.titleEn : hymn.titleYor;
            return Card(
              child: ListTile(
                title: Text(title),
                subtitle: Text('Hymn ${hymn.id}'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HymnPage(
                      hymn: hymn,
                      language: language,
                    ),
                  ));
                },
              ),
            );
          },
        );
}
