import 'package:flutter/material.dart';

abstract class Searcher {
  TextEditingController searchController = TextEditingController();

  Searcher();

  Future<List<dynamic>> search(String pattern);
  Widget itemBuilder(BuildContext context, dynamic suggestion);
  dynamic suggestionSelectedCallback(BuildContext context, dynamic suggestion);
}