import 'package:fish_redux/fish_redux.dart';
import 'package:movie/views/play_now_page/components/movicecell_component/component.dart';

import 'state.dart';

class PlayNowListAdapter extends SourceFlowAdapter<PlayNowPageState> {
  PlayNowListAdapter()
      : super(
          pool: <String, Component<Object>>{
            'moviecell': MovieCellComponent(),
          },
        );
}
