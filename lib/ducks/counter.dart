import 'package:redux/redux.dart';

import 'package:myapp_redux/ducks/state.dart';

class IncrementalAction {
  final int count;

  IncrementalAction({this.count = 10});
}

final counterReducer = combineReducers<int>([
  TypedReducer<int, IncrementalAction>(setIncremental),
]);

int setIncremental(int state, IncrementalAction action) {
  return state + action.count;
}
