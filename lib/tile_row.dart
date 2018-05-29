import 'package:flutter/material.dart';

import 'podcast.dart';
import 'podcast_tile.dart';

class TileRow extends StatefulWidget {

  final String title;
  final List<String> feedUrls;
  final PodcastCallback onTap;


  TileRow({this.title, this.feedUrls, this.onTap});

  @override
  TileRowState createState() {
    return new TileRowState();
  }
}

class TileRowState extends State<TileRow> {
  

  List<Widget> _buildPodcastTiles() {
    return widget.feedUrls.map((feedUrl) {
      return new Container(
        width: 100.0,
        height: 100.0,
        child: new PodcastTile(
          feedUrl: feedUrl,
          onTap: (podcast) { widget.onTap(podcast); }
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: TextStyle(color: Colors.white),),
        new Container(
          margin: new EdgeInsets.only(bottom: 20.0),
          height: 160.0,
          child: new ListView(
            scrollDirection: Axis.horizontal,
            children: _buildPodcastTiles()
          ),
        ),
      ],
    );
  }
}