import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:myapp_redux/appState.dart';
import 'package:myapp_redux/reducers/appReducers.dart';

void main() {
  final store = new Store<AppState>(
    appReducer,
    initialState: AppState.initial(),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times:',
            ),
            new StoreConnector<AppState, int>(
              converter: (Store<AppState> store) => store.state.count,
              // context >> ค่าต่างๆ ของ Flutter เช่น Theme
              // count >> อันนี้ส่วนของ State ใน redux
              builder: (context, count) {
                return new Text(
                  count.toString(),
                  style: Theme.of(context).textTheme.display1,
                );
              },
            ),
          ],
        ),
      ),
      // floatingActionButton: new StoreConnector<AppState, VoidCallback>(
      //   converter: (store) {
      //     return () => store.dispatch(IncrementalAction(10));
      //   },
      //   builder: (context, callback) {
      //     return new FloatingActionButton(
      //       onPressed: callback,
      //       tooltip: 'Increment',
      //       child: new Icon(Icons.add),
      //     );
      //   },
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
