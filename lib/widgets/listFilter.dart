import 'package:flutter/material.dart';

class ListFilter extends StatefulWidget {
  final List<String> _criteria, _filters;
  final Function onFilter;

  ListFilter(this._criteria, this._filters, {this.onFilter});

  @override
  _ListFilterState createState() => _ListFilterState();
}

class _ListFilterState extends State<ListFilter> {
  Iterable<Widget> get criteriaWidgets sync* {
    for (final String criteria in widget._criteria) {
      yield Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: FilterChip(
          label: Text(criteria),
          selected: widget._filters.contains(criteria),
          onSelected: (bool value) {
            setState(() {
              if (value) {
                widget._filters.add(criteria);
              } else {
                widget._filters.removeWhere((String name) {
                  return name == criteria;
                });
              }
            });
            if (widget.onFilter != null) widget.onFilter();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: criteriaWidgets.toList(),
        ),
      ),
      scrollDirection: Axis.horizontal,
    );
  }
}
