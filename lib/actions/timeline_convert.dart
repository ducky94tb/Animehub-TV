import 'dart:ui' as ui;

import 'package:common_utils/common_utils.dart';

class TimeLineConvert {
  TimeLineConvert._();
  static final TimeLineConvert instance = TimeLineConvert._();
  String getTimeLine(DateTime date) {
    final _date = DateTime.tryParse(date.toString().split('.')[0]);
    final String _timeline = TimelineUtil.format(
      _date.millisecondsSinceEpoch,
      locale: ui.window.locale.languageCode,
    );
    return _timeline;
  }
}
