import 'dart:convert';

import 'hymn_page.dart';
import 'hymn.dart';
import 'search.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showSearch(
              context: context,
              delegate: HymnSearchDelegate(
                filterHymns: filterHymns,
              ),
            );
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.search),
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
                title: Text('Hymn ${hymn.id}'),
                subtitle: Text(title),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HymnPage(
                        hymn: hymn,
                        language: language,
                      ),
                    ),
                  );
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
                title: Text('Hymn ${hymn.id}'),
                subtitle: Text(title),
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
