import 'package:cached_network_image/cached_network_image.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie/actions/adapt.dart';
import 'package:movie/actions/imageurl.dart';
import 'package:movie/models/enums/imagesize.dart';
import 'package:movie/style/themestyle.dart';
import 'package:movie/views/play_now_page/action.dart';
import 'package:movie/widgets/linear_progress_Indicator.dart';

import 'state.dart';

Widget buildView(
    VideoCellState state, Dispatch dispatch, ViewService viewService) {
  final d = state.videodata;
  final isMovie = state.isMovie;
  if (d == null) return SizedBox();
  return _Card(
    isMovie: isMovie,
    data: d,
    onTap: (value) => dispatch(PlayNowPageActionCreator.onVideoCellTapped(
        value.id,
        value.posterPath,
        value.posterPath,
        state.isMovie ? value.name : value.tvName)),
  );
}

String _changeDatetime(String s1) {
  return s1 == null || s1 == '' || s1.length < 10 ? '1900-01-01' : s1;
}

class _Card extends StatelessWidget {
  final data;
  final bool isMovie;

  final Function(dynamic d) onTap;

  const _Card({this.data, this.onTap, this.isMovie});

  @override
  Widget build(BuildContext context) {
    final _horizontalPadding = Adapt.px(30);
    final _cardHeight = Adapt.px(350);
    final _borderRadius = Adapt.px(20);
    final _imageWidth = Adapt.px(240);
    final _rightPanelPadding = Adapt.px(20);
    final _rightPanelWidth = Adapt.screenW() -
        _imageWidth -
        _horizontalPadding * 2 -
        _rightPanelPadding * 2;
    final ThemeData _theme = ThemeStyle.getTheme(context);
    final description =
        isMovie ? "-" : 'Season ${data.seasonId} · Ep ${data.episodeId ?? '-'}';
    return Container(
      key: ValueKey('${data.id}'),
      margin: EdgeInsets.symmetric(
          horizontal: _horizontalPadding, vertical: Adapt.px(20)),
      height: _cardHeight,
      decoration: BoxDecoration(
          color: _theme.cardColor,
          borderRadius: BorderRadius.circular(_borderRadius),
          boxShadow: [
            BoxShadow(
                offset: Offset(5, 5),
                color: _theme.brightness == Brightness.light
                    ? _theme.primaryColorDark
                    : const Color(0xFF303030),
                blurRadius: 5)
          ]),
      child: GestureDetector(
        onTap: () => onTap(data),
        child: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(_borderRadius * 2),
            ),
            child: Container(
              width: _imageWidth,
              height: _cardHeight,
              color: const Color(0xFFAABBCC),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: ImageUrl.getUrl(data.posterPath, ImageSize.w300),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(_rightPanelPadding),
            child: SizedBox(
              width: _rightPanelWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isMovie ? data.name ?? "-" : data.tvName ?? "-",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: Adapt.px(30),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: Adapt.px(5)),
                  Text(
                    DateFormat.yMMMd().format(
                      DateTime?.tryParse(_changeDatetime(data.airDate)),
                    ),
                    style: TextStyle(
                        color: const Color(0xFF9E9E9E), fontSize: Adapt.px(18)),
                  ),
                  SizedBox(height: Adapt.px(5)),
                  Text(
                    data.genres,
                    style: TextStyle(
                        fontSize: Adapt.px(18), color: const Color(0xFF9E9E9E)),
                  ),
                  SizedBox(height: Adapt.px(10)),
                  Row(children: [
                    LinearGradientProgressIndicator(
                      value: data.voteAverage / 10,
                      width: Adapt.px(150),
                    ),
                    SizedBox(width: Adapt.px(10)),
                    Text(
                      data.voteAverage.toString(),
                      style: TextStyle(
                          fontSize: Adapt.px(20),
                          color: const Color(0xFF9E9E9E)),
                    )
                  ]),
                  SizedBox(height: Adapt.px(20)),
                  if (isMovie)
                    Text(
                      data.overview,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12,
                          height: 1.5,
                          color: const Color(0xFF717171)),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        gradient:
                            LinearGradient(begin: Alignment.topLeft, stops: [
                          0.0,
                          0.9
                        ], colors: [
                          Colors.deepPurpleAccent.withOpacity(0.4),
                          Colors.deepPurpleAccent.withOpacity(0.8)
                        ]),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 4.0),
                        child: Text(
                          description,
                          style: TextStyle(
                              fontSize: 12,
                              height: 1.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: [
                        Text(
                          'Watched: ${data.views}',
                          style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                              color: const Color(0xFF9E9E9E)),
                        ),
                        Spacer(),
                        Container(
                          width: Adapt.px(80),
                          height: Adapt.px(60),
                          decoration: BoxDecoration(
                            color: const Color(0xFF334455),
                            borderRadius: BorderRadius.circular(Adapt.px(20)),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.chevron_right,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
