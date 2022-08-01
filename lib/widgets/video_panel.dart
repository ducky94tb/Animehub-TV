import 'dart:ui';

import 'package:android_intent_plus/android_intent.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:movie/actions/adapt.dart';
import 'package:movie/actions/imageurl.dart';
import 'package:movie/models/enums/imagesize.dart';
import 'package:movie/models/firebase_api_model/tv_episode_model.dart';
import 'package:movie/utils/dialog_utils.dart';
import 'package:movie/utils/player_utils.dart';
import 'package:toast/toast.dart';

class PlayerPanel extends StatefulWidget {
  final String streamLink;
  final String background;
  final String playerType;
  final bool needAd;
  final bool loading;
  final bool autoPlay;
  final int linkId;
  final Function onPlay;
  final TVEpisodeModel item;
  final int currentEpisodeNo;

  const PlayerPanel({
    Key key,
    this.streamLink,
    this.playerType,
    this.background,
    this.linkId,
    this.loading = false,
    this.needAd = false,
    this.autoPlay = false,
    this.onPlay,
    this.item,
    this.currentEpisodeNo,
  });

  @override
  _PlayerPanelState createState() => _PlayerPanelState();
}

class _PlayerPanelState extends State<PlayerPanel>
    with AutomaticKeepAliveClientMixin {
  bool _loading = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _loading = widget.loading;
    super.initState();
  }

  @override
  void didUpdateWidget(PlayerPanel oldWidget) {
    if (oldWidget.streamLink != widget.streamLink ||
        oldWidget.linkId != widget.linkId ||
        oldWidget.background != widget.background) {}
    super.didUpdateWidget(oldWidget);
  }

  _playTapped(BuildContext context) async {
    if (widget.loading | _loading) return;
    if (TextUtil.isEmpty(widget.streamLink))
      return Toast.show('Oop Sorry!, Link is not found!', context);

    if (MyPlayerUtils.isSupportedInVideoPlayer(widget.streamLink)) {
      _startPlayMovieViaDkPlayer();
      return;
    }
    if (widget.streamLink.contains("drive.google.com")) {
      _startPlayMovie();
      return;
    }
    return Toast.show('Oop Sorry!, Link is not found!', context);
  }

  void _startPlayMovie() async {
    AndroidIntent intent = AndroidIntent(
      action: 'android.intent.action.VIEW',
      data: Uri.encodeFull(widget.streamLink),
    );
    try {
      await intent.launch();
      await _startPlayer();
    } catch (_) {}
  }

  void _startPlayMovieViaDkPlayer() async {
    const dkPlayerPackage = "com.ducky.video.player";
    try {
      await InstalledApps.getAppInfo(dkPlayerPackage);
    } catch (_) {
      DialogUtils.showCustomDialog(
          context: context,
          title: "Install player plugin?",
          content:
              "Download Dk Player, video player plugin support for playing. Thanks!",
          ok: "Yes",
          cancel: "No",
          onAgree: () => {
                Navigator.of(context).pop(true),
                _openBrowserInStore(dkPlayerPackage)
              },
          onCancel: () {
            Navigator.of(context).pop(true);
          });
      return;
    }
    String imageUrl = widget.item != null
        ? ImageUrl.getUrl(widget.item.posterPath, ImageSize.w200)
        : '';
    print(widget.item.toString());
    AndroidIntent intent = AndroidIntent(
      action: 'android.intent.action.VIEW',
      package: dkPlayerPackage,
      data: Uri.encodeFull(widget.streamLink),
      arguments: widget.item != null
          ? {
              'tvshowId': widget.item.id,
              'title': widget.item.tvName ?? '',
              'imageUrl': imageUrl,
              'seasonNo': widget.item.seasonId ?? 0,
              'episodeNo': widget.item.episodeId ?? 0,
              'selectedEpisode': widget.currentEpisodeNo ?? 0,
            }
          : {},
    );
    try {
      await intent.launch();
      await _startPlayer();
    } catch (_) {}
  }

  _openBrowserInStore(String packageName) {
    AndroidIntent intent = AndroidIntent(
      action: 'android.intent.action.VIEW',
      data: Uri.encodeFull(
          "https://play.google.com/store/apps/details?id=$packageName"),
    );
    intent.launch();
  }

  Future<void> _startPlayer() async {
    if (widget.onPlay != null) widget.onPlay();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () => _playTapped(context),
      child: _Background(
        url: widget.background,
        loading: _loading,
      ),
    );
  }
}

class _Background extends StatelessWidget {
  final String url;
  final bool loading;

  const _Background({@required this.url, this.loading});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFAABBEE),
        image: url != null
            ? DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(
                  ImageUrl.getUrl(url, ImageSize.original),
                ),
              )
            : null,
      ),
      child: loading
          ? Center(
              child: Container(
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(const Color(0xFFFFFFFF)),
                ),
              ),
            )
          : _PlayArrow(),
    );
  }
}

class _PlayArrow extends StatelessWidget {
  const _PlayArrow();

  @override
  Widget build(BuildContext context) {
    final _brightness = MediaQuery.of(context).platformBrightness;
    return Center(
        child: ClipRRect(
      borderRadius: BorderRadius.circular(Adapt.px(50)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          color: _brightness == Brightness.light
              ? const Color(0x40FFFFFF)
              : const Color(0x40000000),
          width: Adapt.px(100),
          height: Adapt.px(100),
          child: Icon(
            Icons.play_arrow,
            size: 25,
            color: const Color(0xFFFFFFFF),
          ),
        ),
      ),
    ));
  }
}
