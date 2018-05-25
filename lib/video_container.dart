import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoContainer extends StatefulWidget{
  VideoContainer({Key key}) : super(key: key);

  @override
  _VideoContainerState createState() => new _VideoContainerState();
}

class _VideoContainerState extends State<VideoContainer> {

  VideoPlayerController _controller;

  @override
  Widget build(BuildContext context) {
    return new VideoPlayer(_controller);
  }

}