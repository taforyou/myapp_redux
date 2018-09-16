import 'package:redux/redux.dart';
import 'package:myapp_redux/appState.dart';
import 'package:myapp_redux/actions/appActions.dart';

final appReducer = combineReducers<AppState>([
  TypedReducer<AppState, IncrementalAction>(setIncremental),
]);

AppState setIncremental(AppState state, IncrementalAction action) {
  return AppState(count: state.count + 1);
}



