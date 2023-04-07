import 'package:flutter/material.dart';

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