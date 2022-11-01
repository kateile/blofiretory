import 'package:flutter/material.dart';


typedef SearchBuilder = Widget Function(BuildContext context, String query);

class SearchTopicDelegate<T extends Widget> extends SearchDelegate {
  SearchTopicDelegate({
    required this.builder,
    String? hintText,
  }) : super(
          searchFieldLabel: 'Search Topic, Drug, Diagnosis, etc..',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  final SearchBuilder builder;

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_rounded),
      onPressed: () {
        super.close(context, query);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return builder(context, query);
  }

  @override
  Widget buildResults(BuildContext context) {
    return builder(context, query);
  }

  @override
  List<Widget> buildActions(BuildContext context) => [];
}
