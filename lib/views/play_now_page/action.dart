import 'package:fish_redux/fish_redux.dart';
import 'package:movie/models/video_list.dart';

enum PlayNowPageAction {
  loadData,
  action,
  mediaTypeChange,
  sortChanged,
  videoCellTapped,
  refreshData,
  loadMore,
  busyChanged,
  filterTap,
  applyFilter
}

class PlayNowPageActionCreator {
  static Action onAction() {
    return const Action(PlayNowPageAction.action);
  }

  static Action onSortChanged(String s) {
    return Action(PlayNowPageAction.sortChanged, payload: s);
  }

  static Action onLoadData(final list, bool isMovie) {
    return Action(PlayNowPageAction.loadData, payload: [isMovie, list]);
  }

  static Action onRefreshData() {
    return const Action(PlayNowPageAction.refreshData);
  }

  static Action onLoadMore(List<VideoListResult> p) {
    return Action(PlayNowPageAction.loadMore, payload: p);
  }

  static Action onVideoCellTapped(
      {int p, int seasonId, String backpic, int epId, String tvName}) {
    return Action(PlayNowPageAction.videoCellTapped,
        payload: [p, backpic, seasonId, epId, tvName]);
  }

  static Action onBusyChanged(bool p) {
    return Action(PlayNowPageAction.busyChanged, payload: p);
  }

  static Action mediaTypeChange(bool isMovie) {
    return Action(PlayNowPageAction.mediaTypeChange, payload: isMovie);
  }

  static Action filterTap() {
    return const Action(PlayNowPageAction.filterTap);
  }

  static Action applyFilter() {
    return const Action(PlayNowPageAction.applyFilter);
  }
}
