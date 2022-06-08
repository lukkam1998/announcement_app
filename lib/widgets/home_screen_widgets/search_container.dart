import 'package:announcements_app/data_models_and_providers/filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data_models_and_providers/announcement.dart';

class SearchContainer extends StatefulWidget {
  const SearchContainer({Key? key}) : super(key: key);

  @override
  State<SearchContainer> createState() => _SearchContainerState();
}

class _SearchContainerState extends State<SearchContainer> {
  final searchFieldController = TextEditingController();

  @override
  void dispose() {
    searchFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeOfDevice = MediaQuery.of(context).size;

    return Container(
      height: sizeOfDevice.height * (1 / 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(18.0),
            width: sizeOfDevice.width * (4 / 5),
            child: TextField(

              controller: searchFieldController,
              decoration: InputDecoration(
                label: Text('Enter keyword'),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 20,
            ),
            child: TextButton(
              onPressed: () {
                var keyword = searchFieldController.text;
                Provider.of<FilterProvider>(
                  context,
                  listen: false,
                ).setKeyword(keyword);
              },
              child: Text('Search'),
            ),
          )
        ],
      ),
    );
  }
}
