import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayerContainer extends StatefulWidget {
  final String mediaUrl;

  PlayerContainer({Key key, this.mediaUrl}) : super(key: key) {
    print("Created PlayerContainer: $mediaUrl");
  }

  @override
  _PlayerContainerState createState() => new _PlayerContainerState();
}

class _PlayerContainerState extends State<PlayerContainer> {
  VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isShowingControllerBar = false;
  VoidCallback listener;

  @override
  void initState() {
    super.initState();

    print("PlayerContainer initializing state");

    listener = () {
      final bool isPlaying = _controller.value.isPlaying;
      if (isPlaying != _isPlaying) {
        setState(() {
          _isPlaying = isPlaying;
        });
      }
    };
    initController(widget.mediaUrl);
  }

  void _seek(seconds) {
     _controller.seekTo(new Duration(seconds: _controller.value.position.inSeconds + seconds));
  }

  void initController(videoUrl) {
    print("initController: $videoUrl");

    _controller = new VideoPlayerController.network(
      videoUrl,
    )
      ..addListener(listener)
      ..setVolume(1.0)
      ..initialize();
  }

  @override
  void dispose() {
    print("Disposing PlayerContainer");
    _controller.dispose();
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
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: iconColor,
            ),
            onPressed: _controller.value.isPlaying ? _controller.pause : _controller.play,
          ),
          new IconButton(
            icon: new Icon(
              Icons.replay_10,
              color: iconColor,
            ),
            onPressed: () { _seek(-10);},
          ),
          new Expanded(
            child: VideoProgressIndicator(_controller, allowScrubbing: true),
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
                  new VideoPlayer(_controller),
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