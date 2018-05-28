import 'package:flutter/material.dart';
import 'podcast_tile.dart';
import 'player_container.dart';
import 'podcast.dart';

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
  String _playingMediaUrl;
  PlayerContainer _playerContainer;

  @override
  void initState() {
    super.initState();
    print("init main");
    _playingMediaUrl = 'http://podsync.net/download/ye702k1wl/75d9_WftjK0.mp4';
    _playerContainer = new PlayerContainer(key: Key(_playingMediaUrl), mediaUrl: _playingMediaUrl);
  }



  void playLatest(Podcast podcast) {
    print("playing ${podcast.latestEpisode.enclosure.url}");
    setState(() {
      _playingMediaUrl = podcast.latestEpisode.enclosure.url;
      _playerContainer = new PlayerContainer(key: Key(_playingMediaUrl), mediaUrl: _playingMediaUrl);
      _playerContainer.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    print("build main");
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
            new Text(_playingMediaUrl),
            new Row(
              children: <Widget>[
                new Container(
                  width: 100.0,
                  height: 100.0,
                  child: new PodcastTile(
                    feedUrl: "http://feeds.feedburner.com/daily_tech_news_show",
                    onTap: (podcast) {
                      playLatest(podcast);
                    }
                  ),
                ),
                new Container(
                  width: 100.0,
                  height: 100.0,
                  child: new PodcastTile(
                    feedUrl: "https://podsync.net/ye702k1wl",
                    onTap: (podcast) {
                      playLatest(podcast);
                    }
                  ),
                ),
              ],
            )
          ]
        )
      ),
    );
  }
}
