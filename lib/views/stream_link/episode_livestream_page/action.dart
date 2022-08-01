import 'package:fish_redux/fish_redux.dart';
import 'package:movie/models/base_api_model/tvshow_comment.dart';
import 'package:movie/models/episode_model.dart';
import 'package:movie/models/firebase_api_model/stream_link.dart';

enum EpisodeLiveStreamAction {
  action,
  episodeTapped,
  setSelectedEpisode,
  setComment,
  setStreamLink,
  selectedStreamLink,
  setLike,
  setLoading,
  markWatched,
}

class EpisodeLiveStreamActionCreator {
  static Action episodeTapped(Episode episode) {
    return Action(EpisodeLiveStreamAction.episodeTapped, payload: episode);
  }

  static Action setSelectedEpisode(Episode episode, StreamLink link) {
    return Action(EpisodeLiveStreamAction.setSelectedEpisode,
        payload: [episode, link]);
  }

  static Action setComment(TvShowComments comment) {
    return Action(EpisodeLiveStreamAction.setComment, payload: comment);
  }

  static Action setLike(int likeCount, bool userLiked) {
    return Action(EpisodeLiveStreamAction.setLike,
        payload: [likeCount, userLiked]);
  }

  static Action setStreamLink(StreamLink selectedLink) {
    return Action(EpisodeLiveStreamAction.setStreamLink, payload: selectedLink);
  }

  static Action selectedStreamLink(StreamLink streamLink) {
    return Action(EpisodeLiveStreamAction.selectedStreamLink,
        payload: streamLink);
  }

  static Action setLoading(bool loading) {
    return Action(EpisodeLiveStreamAction.setLoading, payload: loading);
  }

  static Action markWatched(Episode episode) {
    return Action(EpisodeLiveStreamAction.markWatched, payload: episode);
  }
}
