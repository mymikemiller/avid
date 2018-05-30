import 'package:flutter/material.dart';
import 'dart:async';
import 'player_container.dart';
import 'podcast.dart';
import 'tile_row.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());


List<String> feedUrls = [
  //"https://pa.tedcdn.com/feeds/talks.rss", // Causes player to slow down and stop responding
  //"http://feeds.feedburner.com/tedtalksHD", // Same, slows player
  //"http://rss.cnn.com/services/podcasting/cnn10/rss", // Image doesn't work (only specified in itunes:image tag)
  //"feeds.ign.com/ignfeeds/podcasts/video/gamescoop", // No host specified in URI (?)

  "https://podsync.net/ye702k1wl", //GameGrumpsOld
  "http://feeds.feedburner.com/daily_tech_news_show",
  "http://feeds.twit.tv/tnss_video_small.xml",
  "http://feeds.twit.tv/tnw_video_small.xml",
  "http://feeds.feedburner.com/KathyMaistersStartCookingVideoCast?format=xml",
  "http://feeds.twit.tv/aaa_video_small.xml",
  "https://animecons.tv/extras-hd.xml",
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
  GlobalKey<PlayerContainerState> _playerContainerKey = GlobalKey();

  List<Podcast> _podcasts;

  @override
  void initState() {
    super.initState();
    print("init main");
    _podcasts = [];

    // Load all the podcasts into _podcasts, updating state each time one is fetched
    for(var feedUrl in feedUrls) {
      _fetchPodcast(feedUrl).then((podcast) {
        setState(() {
          _podcasts.add(podcast);
        });
      });
    }

    // This is called the frame after everything is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playerContainerKey.currentState.load('http://podsync.net/download/ye702k1wl/75d9_WftjK0.mp4');
    });
  }

  Future<Podcast> _fetchPodcast(feedUrl) async {
    final response = await http.get(feedUrl);
    return new Podcast.fromXml(feedUrl, response.body);
  }

  void playLatest(Podcast podcast) {
    print("playing ${podcast.latestEpisode.enclosure.url}");
    setState(() {
      _playerContainerKey.currentState.load(podcast.latestEpisode.enclosure.url, true);
    });
  }

  Map<String, List<Podcast>> _categorize(List<Podcast> podcasts) {
    Map<String, List<Podcast>> map = {};

    // Add all the podcasts to the map, keyed off their category
    for(Podcast podcast in podcasts) {
      List<Podcast> list = map.putIfAbsent(podcast.category, () => []);
      list.add(podcast);
    }

    return map;
  }

  List<Widget> _buildTileRows() {
    if (_podcasts.isEmpty) return [];
    
    var map = _categorize(_podcasts);

    List<Widget> tileRows = [];
    for(var category in map.keys) {
      tileRows.add(
        new TileRow(
          title: category, 
          podcasts: map[category],
          onTap: (podcast) {
            playLatest(podcast);
          }
        )
      );
    }
    return tileRows;
  }

  @override
  Widget build(BuildContext context) {
    print("build main");
    Orientation orientation = MediaQuery
      .of(context)
      .orientation;

    return new Scaffold(
      backgroundColor: const Color.fromRGBO(20, 20, 20, 1.0),
      appBar: orientation == Orientation.landscape 
        ? null
        : new AppBar(
          title: new Text(widget.title),
        ),
      body: new Center(
        child: orientation == Orientation.landscape
          ? PlayerContainer(key: _playerContainerKey)
          : new Column(
          children: <Widget>[
            PlayerContainer(key: _playerContainerKey),
            new Expanded(
              child: new ListView(
                shrinkWrap: true,
                children: _buildTileRows(),
              ),
            )
          ]
        )
      ),
    );
  }
}
