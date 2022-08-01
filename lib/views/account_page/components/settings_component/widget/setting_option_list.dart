import 'package:flutter/material.dart';
import 'package:movie/models/item.dart';
import 'package:movie/style/themestyle.dart';
import 'package:movie/views/account_page/components/settings_component/widget/setting_option_cell.dart';

class OptionList extends StatelessWidget {
  final String title;
  final Function(Item) onTap;
  final Item selected;
  final List<Item> data;

  const OptionList({this.onTap, this.selected, this.data, this.title});

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final _theme = ThemeStyle.getTheme(context);
    final _backGroundColor = _theme.brightness == Brightness.light
        ? const Color(0xFF25272E)
        : _theme.primaryColorDark;
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0.0,
      backgroundColor: _backGroundColor,
      titleTextStyle: TextStyle(color: const Color(0xFFFFFFFF), fontSize: 18),
      title: Text(title),
      children: [
        Container(
          height: _size.height / 2,
          width: _size.width,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 5.0),
            separatorBuilder: (_, __) => SizedBox(height: 10),
            physics: BouncingScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (_, index) {
              final _language = data[index];
              return OptionListCell(
                onTap: (l) => onTap(l),
                selected: selected.name == _language.name,
                item: _language,
              );
            },
          ),
        ),
      ],
    );
  }
}
