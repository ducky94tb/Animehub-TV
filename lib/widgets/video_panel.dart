import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:movie/actions/adapt.dart';
import 'package:movie/actions/imageurl.dart';
import 'package:movie/models/enums/imagesize.dart';
import 'package:movie/widgets/webview_player.dart';
import 'package:toast/toast.dart';
import 'package:video_player/video_player.dart';

import 'custom_video_controls.dart';

class PlayerPanel extends StatefulWidget {
  final String streamLink;
  final String background;
  final String playerType;
  final bool streamInBrowser;
  final bool useVideoSourceApi;
  final bool needAd;
  final bool loading;
  final bool autoPlay;
  final int linkId;
  final Function onPlay;

  const PlayerPanel({
    Key key,
    this.streamLink,
    this.playerType,
    this.background,
    this.linkId,
    this.loading = false,
    this.useVideoSourceApi = true,
    this.streamInBrowser = false,
    this.needAd = false,
    this.autoPlay = false,
    this.onPlay,
  });

  @override
  _PlayerPanelState createState() => _PlayerPanelState();
}

class _PlayerPanelState extends State<PlayerPanel>
    with AutomaticKeepAliveClientMixin {
  bool _play = false;
  bool _needAd = false;
  bool _loading = false;
  bool _haveOpenAds = false;
  String _playerType;
  String _directUrl;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _needAd = widget.needAd;
    _loading = widget.loading;
    _playerType = widget.playerType;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(PlayerPanel oldWidget) {
    if (oldWidget.streamLink != widget.streamLink ||
        oldWidget.playerType != widget.playerType ||
        oldWidget.linkId != widget.linkId ||
        oldWidget.background != widget.background) {
      setState(() {
        _play = false;
      });
    }
    if (_needAd != widget.needAd && !_haveOpenAds) _setNeedAd(widget.needAd);
    if (_loading != widget.loading) _setLoading(widget.loading);
    if (_playerType != widget.playerType) _setPlayerType(widget.playerType);
    //if (widget.autoPlay) _playTapped(context);
    super.didUpdateWidget(oldWidget);
  }

  _playTapped(BuildContext context) async {
    if (widget.loading) return;
    if (!widget.useVideoSourceApi && widget.playerType == 'VideoSourceApi')
      return Toast.show('no streamlink at this moment', context);
    await _startPlayer();
  }

  _startPlayer() async {
    // await launch(
    //   widget.streamLink,
    //   enableJavaScript: true,
    // );
    setState(() {
      _play = true;
    });
    if (widget.onPlay != null) widget.onPlay();
  }

  _setLoading(bool loading) {
    setState(() {
      _loading = loading;
    });
  }

  _setPlayerType(String type) {
    setState(() {
      _playerType = type;
    });
  }

  _setNeedAd(bool needAd) {
    _needAd = needAd;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _play
        ? _Player(
            streamLink: widget.streamLink,
            playerType: _playerType,
          )
        : GestureDetector(
            onTap: () => _playTapped(context),
            child: _Background(
              url: widget.background,
              loading: _loading,
            ),
          );
  }
}

class _Player extends StatelessWidget {
  final String playerType;
  final String streamLink;

  const _Player({this.playerType, this.streamLink});

  @override
  Widget build(BuildContext context) {
    return WebViewPlayer(
        streamLink: this.streamLink, filterUrl: this.streamLink);
  }
}

class VideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;

  const VideoPlayer({this.controller});

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  ChewieController _chewieController;

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() {
    widget.controller.initialize().then((value) {
      _chewieController = ChewieController(
        videoPlayerController: widget.controller,
        customControls: CustomCupertinoControls(
          backgroundColor: Colors.black,
          iconColor: Colors.white,
        ),
        allowedScreenSleep: false,
        autoPlay: true,
        aspectRatio: widget.controller.value.aspectRatio,
      );
      setState(() {});
    });
  }

  @override
  void dispose() {
    widget.controller?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: _chewieController == null
          ? Center(
              child: Container(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                    const Color(0xFFFFFFFF),
                  ),
                ),
              ),
            )
          : Chewie(controller: _chewieController),
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
