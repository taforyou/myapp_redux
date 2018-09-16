import 'package:redux/redux.dart';

import 'package:myapp_redux/ducks/state.dart';

class IncrementalAction {
  final int count;

  IncrementalAction({this.count = 10});
}

final appReducer = combineReducers<AppState>([
  TypedReducer<AppState, IncrementalAction>(setIncremental),
]);

AppState setIncremental(AppState state, IncrementalAction action) {
  return AppState(count: state.count + action.count);
}
