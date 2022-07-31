import 'package:fish_redux/fish_redux.dart';

import 'adapter.dart';
import 'components/filter_component/component.dart';
import 'components/filter_component/state.dart';
import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class PlayNowPage extends Page<PlayNowPageState, Map<String, dynamic>> {
  PlayNowPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          shouldUpdate: (o, n) {
            return o.filterState.isMovie != n.filterState.isMovie ||
                o.tvEpisodeList != n.tvEpisodeList ||
                o.movieList != n.movieList ||
                o.isbusy != n.isbusy;
          },
          view: buildView,
          dependencies: Dependencies<PlayNowPageState>(
              adapter: NoneConn<PlayNowPageState>() + PlayNowListAdapter(),
              slots: <String, Dependent<PlayNowPageState>>{
                'filter': FilterConnector() + FilterComponent()
              }),
          middleware: <Middleware<PlayNowPageState>>[],
        );
}
