import 'package:flutter/material.dart';
import 'package:feedparser/feedparser.dart';
import 'dart:async';
import 'player_container.dart';
import 'podcast.dart';
import 'tile_row.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());


List<String> feedUrls = [
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

  List<Podcast> _podcasts;

  @override
  void initState() {
    super.initState();
    print("init main");
    _playingMediaUrl = 'http://podsync.net/download/ye702k1wl/75d9_WftjK0.mp4';
    _playerContainer = new PlayerContainer(key: Key(_playingMediaUrl), mediaUrl: _playingMediaUrl);
    _podcasts = [];

    // Load all the podcasts into _podcasts, updating state each time one is fetched
    for(var feedUrl in feedUrls) {
      _fetchPodcast(feedUrl).then((podcast) {
        setState(() {
          _podcasts.add(podcast);
        });
      });
    }
  }

  Future<Podcast> _fetchPodcast(feedUrl) async {
    final response = await http.get(feedUrl);
    Feed feed = parse(response.body);
    return new Podcast.fromFeed(feedUrl, feed);
  }

  void playLatest(Podcast podcast) {
    print("playing ${podcast.latestEpisode.enclosure.url}");
    setState(() {
      _playingMediaUrl = podcast.latestEpisode.enclosure.url;
      _playerContainer = new PlayerContainer(key: Key(_playingMediaUrl), mediaUrl: _playingMediaUrl);
      _playerContainer.play();
    });
  }

  List<Widget> _buildTileRows() {
    if (_podcasts.isEmpty) return [];

    return [new TileRow(
      title: "Tech", 
      podcasts: _podcasts,
      onTap: (podcast) {
        playLatest(podcast);
      }
    )];
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
            new Column(
              children: _buildTileRows(),
            )
          ]
        )
      ),
    );
  }
}
