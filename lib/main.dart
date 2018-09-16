import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_epics/redux_epics.dart';

import 'package:myapp_redux/ducks/state.dart';
import 'package:myapp_redux/ducks/video.dart';

void main() {
  final store = new Store<AppState>(
    rootReducer,
    initialState: AppState.initial(),
    middleware: [EpicMiddleware(allEpics)]
  );

  runApp(new MyApp(
    store: store,
    title: 'Flutter Redux Demo',
  ));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;
  final String title;

  MyApp({Key key, this.store, this.title}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Flex(
        direction: Axis.horizontal,
        children: [VideoList()]
      ),
      floatingActionButton: new StoreConnector<AppState, VoidCallback>(
        converter: (store) {
          return () => store.dispatch(FetchVideos());
        },
        builder: (context, callback) {
          return new FloatingActionButton(
            onPressed: callback,
            tooltip: 'Load Data',
            child: new Icon(Icons.add),
          );
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class VideoList extends StatelessWidget {
  const VideoList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, Store<AppState>>(
      converter: (Store<AppState> store) => store,
      // context >> ค่าต่างๆ ของ Flutter เช่น Theme
      // count >> อันนี้ส่วนของ State ใน redux
      builder: (context, store) {
        return Flexible(
          child: ListView.builder(
            itemCount: store.state.videos.length,
            itemBuilder: (context, index) {
              final video = store.state.videos[index];

              return ListTile(
                title: Text(video.name),
                subtitle: Text(video.description),
                onTap: () => store.dispatch(DeleteVideo(video.id)),
              );
            },
          )
        );
      },
    );
  }
}
