import 'package:flutter/material.dart';
import 'model/api.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShadowSocks Server Status',
      theme: ThemeData(
        // This is the theme of your application.
        //
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'ShadowSocks Server Status'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  ServerStatus serverStatus = ServerStatus(Status.Unknown);

  Future _refresh() async {
    if (serverStatus.status == Status.Checking){
      return;
    }

    setState(() {
      serverStatus = ServerStatus(Status.Checking);
    });
    var st = await ServerStatusRepository.getStatus();
    setState(() {
      serverStatus = st;
    });
  }

  _restart() async {
    if (serverStatus.status == Status.Checking){
      return;
    }
    setState(() {
      serverStatus = ServerStatus(Status.Checking);
    });
    var st = await ServerStatusRepository.restart();
    setState(() {
      serverStatus = st;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    _refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.autorenew), onPressed: (){ _restart();},tooltip: "Restart server",),
        ],
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '服务器状态:',
            ),
            Text(
              serverStatus.toString(),
              style: serverStatus.status == Status.Running
                  ? Theme.of(context).textTheme.body1.copyWith(color: Colors.blue)
                  : Theme.of(context).textTheme.body1,
              //style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refresh,
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
