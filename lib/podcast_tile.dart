import 'package:flutter/material.dart';
import 'dart:async';
import 'package:feedparser/feedparser.dart';
import 'package:http/http.dart' as http;
import 'podcast.dart';


Future<Podcast> _fetchPodcast(feedUrl) async {
  final response = await http.get(feedUrl);
  print(response.body);
  Feed feed = parse(response.body);
  
  return new Podcast.fromFeed(feed); 
}

class PodcastTile extends StatefulWidget {
  final String feedUrl;

  PodcastTile(this.feedUrl);

  @override
  _PodcastTileState createState() => new _PodcastTileState();
}

class _PodcastTileState extends State<PodcastTile> {
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<Podcast>(
      future: _fetchPodcast(widget.feedUrl),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return new Column(
            children: <Widget>[
              new Text(snapshot.data.title),
              new Image.network(snapshot.data.imageUrl)
            ]
          );
        } else if (snapshot.hasError) {
          return new Text("${snapshot.error}");
        }

        // By default, show a loading spinner
        return new CircularProgressIndicator();
      },
    );
  }
}

