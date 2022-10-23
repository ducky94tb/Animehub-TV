import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:movie/actions/adapt.dart';

import 'state.dart';

Widget buildView(
    DataPanelState state, Dispatch dispatch, ViewService viewService) {
  return _SecondPanel(
    state: state,
  );
}

class _SecondPanel extends StatelessWidget {
  final DataPanelState state;
  const _SecondPanel({this.state});
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(bottom: 25),
        height: Adapt.px(220),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF5568E8),
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('images/account_bar_background.png')),
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _DataItem(
                title: 'Download',
                value: '${state.downloadTask?.length ?? 0}',
              ),
              _DataItem(
                title: 'What',
                value: '80',
              ),
              _DataItem(
                title: 'Here?',
                value: '100',
              ),
              Icon(
                Icons.keyboard_arrow_right,
                color: const Color(0xFFFFFFFF),
                size: 30,
              )
            ]),
      ),
    );
  }
}

class _DataItem extends StatelessWidget {
  final String title;
  final String value;
  const _DataItem({this.title, this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(value,
            style: TextStyle(
              color: const Color(0xFFFFFFFF),
              fontWeight: FontWeight.bold,
              fontSize: Adapt.px(22),
            )),
        SizedBox(height: 5),
        Text(title,
            style: TextStyle(
                color: const Color(0xFFFFFFFF), fontSize: Adapt.px(24)))
      ],
    );
  }
}
