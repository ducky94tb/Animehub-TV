import 'package:flutter/material.dart';
import 'package:movie/models/item.dart';

class OptionListCell extends StatelessWidget {
  final Function onTap;
  final Item item;
  final bool selected;
  const OptionListCell({this.onTap, this.item, this.selected = false});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(item);
        Navigator.of(context).pop();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: selected
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: const Color(0xFFFFFFFF)))
            : null,
        child: Text(
          item.name,
          style: TextStyle(color: const Color(0xFFFFFFFF), fontSize: 14),
        ),
      ),
    );
  }
}
