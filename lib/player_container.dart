import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayerContainer extends StatefulWidget {
  VideoPlayerController _controller;

  PlayerContainer({Key key, String mediaUrl}) : super(key: key) {
    print("Creating PlayerContainer: $mediaUrl");

    _controller = new VideoPlayerController.network(
      mediaUrl,
    )
      ..initialize();
  }

  void play() {
    _controller.play();
  }

  @override
  _PlayerContainerState createState() => new _PlayerContainerState();
}

class _PlayerContainerState extends State<PlayerContainer> {
  bool _isPlaying = false;
  bool _isShowingControllerBar = false;

  @override
  void initState() {
    super.initState();

    print("PlayerContainer initializing state");

    widget._controller.addListener(() {
      final bool isPlaying = widget._controller.value.isPlaying;
      if (isPlaying != _isPlaying) {
        setState(() {
          _isPlaying = isPlaying;
        });
      }
    });
  }

  void _seek(seconds) {
     widget._controller.seekTo(new Duration(seconds: widget._controller.value.position.inSeconds + seconds));
  }

  @override
  void dispose() {
    print("Disposing PlayerContainer");
    widget._controller.dispose();
    super.dispose();
  }

  Widget _buildControllerBar({iconColor}) {
    return new Container(
      decoration: new BoxDecoration(
        color: Colors.black45,
      ),
      child: new Row(
        children: <Widget>[
          new IconButton(
            icon: new Icon(
              widget._controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: iconColor,
            ),
            onPressed: widget._controller.value.isPlaying ? widget._controller.pause : widget._controller.play,
          ),
          new IconButton(
            icon: new Icon(
              Icons.replay_10,
              color: iconColor,
            ),
            onPressed: () { _seek(-10);},
          ),
          new Expanded(
            child: VideoProgressIndicator(widget._controller, allowScrubbing: true),
          ),
          new IconButton(
            icon: new Icon(
              Icons.forward_10,
              color: iconColor,
            ),
            onPressed: () { _seek(10);},
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
      aspectRatio: 1280 / 720,
      child: new Stack(
        alignment: Alignment.bottomLeft,
        children: <Widget>[
            new GestureDetector(
              onTap: () { setState(() { _isShowingControllerBar = !_isShowingControllerBar; } ); },
              child: new Stack(
                children: <Widget>[
                  new Container(color: Colors.black), // So we can see where the player will be once it loads
                  new VideoPlayer(widget._controller),
                ]
              ),
            ),
          _isShowingControllerBar 
            ? _buildControllerBar(iconColor: Colors.white) 
            : Row(),
        ],
      ),
    );
  }
}