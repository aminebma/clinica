import 'package:flutter/material.dart';

class ListFilter extends StatefulWidget {
  final List<String> _criteria;

  ListFilter(this._criteria);

  @override
  _ListFilterState createState() => _ListFilterState();
}

class _ListFilterState extends State<ListFilter> {
  List<String> _filters = <String>[];

  Iterable<Widget> get criteriaWidgets sync* {
    for (final String criteria in widget._criteria) {
      yield Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: FilterChip(
          label: Text(criteria),
          selected: _filters.contains(criteria),
          onSelected: (bool value) {
            setState(() {
              if (value) {
                _filters.add(criteria);
              } else {
                _filters.removeWhere((String name) {
                  return name == criteria;
                });
              }
            });
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        children: criteriaWidgets.toList(),
      ),
      scrollDirection: Axis.horizontal,
    );
  }
}
