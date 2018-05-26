import 'package:flutter/material.dart';
import 'podcast_tile.dart';
import 'player_container.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Avid',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Avid'),
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
  PlayerContainer _playerContainer;

  @override
  void initState() {
    super.initState();
    print("init main");
    _playerContainer = PlayerContainer();
  }

  @override
  Widget build(BuildContext context) {
    print("build main");
    print(_playerContainer);
    Orientation orientation = MediaQuery
      .of(context)
      .orientation;

    return new Scaffold(
      backgroundColor: orientation == Orientation.landscape ? Colors.black : Colors.white,
      appBar: orientation == Orientation.landscape 
        ? null
        : new AppBar(
          title: new Text(widget.title),
        ),
      body: new Center(
        child: Column(
          children: <Widget>[
            _playerContainer,
            PodcastTile(
              feedUrl: "http://feeds.feedburner.com/daily_tech_news_show",
              onTap: (podcast) {
                print("playing ${podcast.latestEpisode.enclosure.url}");
                setState(() {
                  _playerContainer = PlayerContainer();
                });
              }
            )
          ]
        )
      ),
    );
  }
}
