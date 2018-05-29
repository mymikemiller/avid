import 'package:flutter/material.dart';
import 'dart:async';
import 'package:feedparser/feedparser.dart';
import 'package:http/http.dart' as http;
import 'podcast.dart';


Future<Podcast> _fetchPodcast(feedUrl) async {
  final response = await http.get(feedUrl);
  Feed feed = parse(response.body);
  
  return new Podcast.fromFeed(feedUrl, feed);
}

typedef void PodcastCallback(Podcast podcast);

class PodcastTile extends StatefulWidget {
  final String feedUrl;
  final PodcastCallback onTap;

  PodcastTile({this.feedUrl, this.onTap});

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
          return new GestureDetector(
            child: new Column(
              children: <Widget>[
                new Image.network(snapshot.data.imageUrl)
              ]
            ),
            onTap: () { widget.onTap(snapshot.data); },
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

