import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data_models_and_providers/announcement.dart';
import '../../data_models_and_providers/filter_provider.dart';

class FiltersContainer extends StatefulWidget {
  @override
  State<FiltersContainer> createState() {
    return FiltersContainerState();
  }
}

class FiltersContainerState extends State<FiltersContainer> {
  @override
  Widget build(BuildContext context) {
    final sizeOfDevice = MediaQuery.of(context).size;
    final dropdownValue = Provider.of<FilterProvider>(context).category;

    return Container(
      height: sizeOfDevice.height * (1 / 14),
      child: DropdownButton<Category>(
        value: dropdownValue,
        underline: Container(
          height: 2,
          color: ColorScheme.fromSwatch().secondary,
        ),
        onChanged: (newValue) {
          Provider.of<FilterProvider>(context, listen: false).setCategory(newValue!);
          setState(() {});
        },
        icon: const Icon(Icons.arrow_downward),
        items: <Category>[
          Category.Electronics,
          Category.Animals,
          Category.All,
          Category.Fruits
        ]
            .map<DropdownMenuItem<Category>>(
              (Category e) => DropdownMenuItem<Category>(
            value: e,
            child: Text(e.name.toString()),
          ),
        )
            .toList(),
      ),
    );
  }
}