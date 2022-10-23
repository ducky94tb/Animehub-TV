import 'dart:ui' as ui;

import 'package:common_utils/common_utils.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:movie/actions/adapt.dart';
import 'package:movie/style/themestyle.dart';
import 'package:shimmer/shimmer.dart';

import 'state.dart';

Widget buildView(InfoState state, Dispatch dispatch, ViewService viewService) {
  var context = viewService.context;
  final ThemeData _theme = ThemeStyle.getTheme(context);
  var _d = state.selectMdeia;
  final season = _d == null
      ? ''
      : _d.seasonId == 0
          ? "OVA"
          : _d.seasonId;
  var date = DateTime.tryParse(_d != null ? _d.timeStamp : '1970-01-01');
  final String _timeline = TimelineUtil.format(
    date.millisecondsSinceEpoch,
    locTimeMs: DateTime.now().millisecondsSinceEpoch,
    locale: ui.window.locale.languageCode,
  );
  Widget _child = _d == null
      ? Shimmer.fromColors(
          baseColor: _theme.primaryColorDark,
          highlightColor: _theme.primaryColorLight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: Adapt.px(45),
                width: Adapt.px(400),
                color: Colors.grey[200],
              ),
              SizedBox(
                height: Adapt.px(30),
              ),
              Container(
                height: Adapt.px(24),
                color: Colors.grey[200],
              ),
              SizedBox(
                height: Adapt.px(8),
              ),
              Container(
                height: Adapt.px(24),
                color: Colors.grey[200],
              ),
              SizedBox(
                height: Adapt.px(8),
              ),
              Container(
                height: Adapt.px(24),
                color: Colors.grey[200],
              ),
              SizedBox(
                height: Adapt.px(8),
              ),
              Container(
                height: Adapt.px(24),
                width: Adapt.px(200),
                color: Colors.grey[200],
              ),
              SizedBox(
                height: Adapt.px(8),
              ),
            ],
          ),
        )
      : Column(
          key: ValueKey(_d),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(_d.tvName,
                style: TextStyle(
                    fontSize: Adapt.px(45), fontWeight: FontWeight.bold)),
            SizedBox(
              height: Adapt.px(20),
            ),
            Text('Season: $season Episode: ${_d.episodeId}',
                style: TextStyle(
                    fontSize: Adapt.px(30), fontWeight: FontWeight.bold)),
            SizedBox(
              height: Adapt.px(20),
            ),
            Text("Watched at: $_timeline"),
          ],
        );
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: Adapt.px(50)),
    child: AnimatedSwitcher(
      transitionBuilder: (w, a) {
        return SlideTransition(
          position: a.drive(Tween(begin: Offset(0, 0.2), end: Offset.zero)),
          child: FadeTransition(
            opacity: a,
            child: w,
          ),
        );
      },
      duration: Duration(milliseconds: 300),
      reverseDuration: Duration(milliseconds: 0),
      child: _child,
    ),
  );
}
