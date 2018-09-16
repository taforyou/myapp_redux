import 'package:redux_epics/redux_epics.dart';

import 'video.dart';
import 'counter.dart';

class AppState {
  final int count;
  final List<Video> videos;

  AppState({this.count = 0, this.videos = const []});

  factory AppState.initial() => new AppState(count: 13);
}

AppState rootReducer(AppState state, dynamic action) {
  return AppState(
    count: counterReducer(state.count, action),
    videos: videoReducer(state.videos, action)
  );
}

final allEpics = combineEpics<AppState>([
  createVideoEpic,
  fetchVideoEpic,
  deleteVideoEpic
]);