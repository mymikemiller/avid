import 'package:flutter/material.dart';
import 'podcast_tile.dart';
import 'player_container.dart';
import 'podcast.dart';
import 'tile_row.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
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

  final feedUrls = [
    "http://feeds.feedburner.com/daily_tech_news_show",
    //"https://podsync.net/ye702k1wl", GameGrumpsOld
    "http://feeds.twit.tv/tnss_video_small.xml",
    //"https://pa.tedcdn.com/feeds/talks.rss", // Causes player to slow down and stop responding
    //"http://feeds.feedburner.com/tedtalksHD", // Same, slows player
    //"http://rss.cnn.com/services/podcasting/cnn10/rss", // Image doesn't work (only specified in itunes:image tag)
    //"feeds.ign.com/ignfeeds/podcasts/video/gamescoop", // No host specified in URI (?)
    "http://feeds.feedburner.com/KathyMaistersStartCookingVideoCast?format=xml",
    "http://feeds.twit.tv/aaa_video_small.xml",
  ];

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
      backgroundColor: Colors.black,
      appBar: orientation == Orientation.landscape 
        ? null
        : new AppBar(
          title: new Text(widget.title),
        ),
      body: new Center(
        child: Column(
          children: <Widget>[
            _playerContainer,
            // new Text(_playingMediaUrl),
            new TileRow(
              title: "Tech", 
              feedUrls: feedUrls,
              onTap: (podcast) {
                playLatest(podcast);
              }
            )
          ]
        )
      ),
    );
  }
}
