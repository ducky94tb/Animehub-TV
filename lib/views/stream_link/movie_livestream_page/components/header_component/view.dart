import 'package:cached_network_image/cached_network_image.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie/actions/adapt.dart';
import 'package:movie/actions/imageurl.dart';
import 'package:movie/models/enums/imagesize.dart';
import 'package:movie/models/firebase/firebase_api.dart';
import 'package:movie/style/themestyle.dart';
import 'package:movie/utils/dialog_utils.dart';
import 'package:movie/widgets/expandable_text.dart';
import 'package:toast/toast.dart';

import 'state.dart';

Widget buildView(
    HeaderState state, Dispatch dispatch, ViewService viewService) {
  final context = viewService.context;
  final _theme = ThemeStyle.getTheme(context);
  void report() async {
    final res = await FirebaseApi.instance.report(
      mediaType: "movie",
      id: state.detail.id,
    );
    if (res == 1) {
      Toast.show("Thanks for your report!", context);
    } else {
      Toast.show("Thanks", context);
    }
  }

  return SliverToBoxAdapter(
    child: Padding(
      padding: EdgeInsets.only(top: Adapt.px(40)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.name ?? '',
            style: TextStyle(
              fontSize: Adapt.px(35),
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          SizedBox(height: Adapt.px(40)),
          Row(children: [
            Container(
              width: Adapt.px(80),
              height: Adapt.px(80),
              decoration: BoxDecoration(
                color: _theme.primaryColorDark,
                borderRadius: BorderRadius.circular(Adapt.px(20)),
                image: state.detail.posterPath != null
                    ? DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          ImageUrl.getUrl(
                              state.detail.posterPath, ImageSize.w300),
                        ),
                      )
                    : null,
              ),
            ),
            SizedBox(width: Adapt.px(10)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMd()
                      .format(DateTime.tryParse(state.detail.releaseDate)),
                ),
                Text(
                  state.detail.genres.take(2).map((e) => e.name).join(' · '),
                  style: TextStyle(
                    fontSize: Adapt.px(24),
                    color: const Color(0xFF717171),
                  ),
                ),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                DialogUtils.showCustomDialog(
                    context: context,
                    title: "Have problem with this movie?",
                    content:
                        "The stream link for this movie is not found or expired? Please help us report it.\nThanks so much!",
                    ok: "Yes",
                    cancel: "No",
                    onAgree: () => {Navigator.of(context).pop(true), report()},
                    onCancel: () {
                      Navigator.of(context).pop(true);
                    });
              },
              child: Row(
                children: [
                  Icon(Icons.flag),
                  Text(
                    'Report',
                    style: TextStyle(
                        fontSize: Adapt.px(28),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ]),
          SizedBox(height: Adapt.px(40)),
          ExpandableText(
            state.overview,
            maxLines: 3,
            style: TextStyle(color: const Color(0xFF717171), height: 1.5),
          )
        ],
      ),
    ),
  );
}
