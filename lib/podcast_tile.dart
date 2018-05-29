import 'package:flutter/material.dart';
import 'podcast.dart';

typedef void PodcastCallback(Podcast podcast);

class PodcastTile extends StatefulWidget {
  final Podcast podcast;
  final PodcastCallback onTap;

  PodcastTile({this.podcast, this.onTap});

  @override
  _PodcastTileState createState() => new _PodcastTileState();
}

class _PodcastTileState extends State<PodcastTile> {
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Column(
        children: <Widget>[
          new Image.network(widget.podcast.imageUrl)
        ]
      ),
      onTap: () { widget.onTap(widget.podcast); },
    );
  }

    // Not using FutureBuilder because now a PodcastTile is only created once the Podcast has been fetched
    // return new FutureBuilder<Podcast>(
    //   future: _fetchPodcast(widget.feedUrl),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       return new GestureDetector(
    //         child: new Column(
    //           children: <Widget>[
    //             new Image.network(snapshot.data.imageUrl)
    //           ]
    //         ),
    //         onTap: () { widget.onTap(snapshot.data); },
    //       );
    //     } else if (snapshot.hasError) {
    //       return new Text("${snapshot.error}");
    //     }

    //     // By default, show a loading spinner
    //     return new CircularProgressIndicator();
    //   },
    // );
  // }
}

