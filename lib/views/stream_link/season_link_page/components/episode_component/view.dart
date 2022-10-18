import 'package:cached_network_image/cached_network_image.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:movie/actions/adapt.dart';
import 'package:movie/actions/imageurl.dart';
import 'package:movie/models/enums/imagesize.dart';
import 'package:movie/style/themestyle.dart';
import 'package:movie/views/stream_link/season_link_page/action.dart';

import 'state.dart';

Widget buildView(
    EpisodeState state, Dispatch dispatch, ViewService viewService) {
  final ThemeData _theme = ThemeStyle.getTheme(viewService.context);
  DateTime _airDate;
  try {
    _airDate = DateTime.parse(state.episode.airDate ?? "-");
  } on FormatException catch (_) {
    _airDate = DateTime.parse('1990-01-01');
  }
  final bool _canPlay = DateTime.now().isAfter(_airDate);
  return InkWell(
      key: ValueKey('Episode${state.episode.id}'),
      onTap: () => dispatch(
          SeasonLinkPageActionCreator.onEpisodeCellTapped(state.episode)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Adapt.px(8)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: Adapt.px(220),
              height: Adapt.px(130),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Adapt.px(10)),
                  color: _theme.primaryColorDark,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter: _canPlay
                          ? null
                          : ColorFilter.mode(Colors.black, BlendMode.color),
                      image: CachedNetworkImageProvider(ImageUrl.getUrl(
                          state.episode.stillPath, ImageSize.w300)))),
            ),
            SizedBox(width: Adapt.px(20)),
            Container(
                width: Adapt.screenW() - Adapt.px(300),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text.rich(
                      TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: '${state.episode.episodeNumber}. ',
                            style: TextStyle(fontSize: Adapt.px(28))),
                        TextSpan(
                            text: '${state.episode.name}',
                            style: TextStyle(
                                fontSize: Adapt.px(28),
                                fontWeight: FontWeight.w800)),
                      ]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: Adapt.px(5)),
                    Text(
                      '${state.episode.overview}',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ))
          ],
        ),
      ));
}
