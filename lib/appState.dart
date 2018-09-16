class AppState {
  final int count;

  AppState({this.count = 0});

  factory AppState.initial() => new AppState(count: 13);
}
