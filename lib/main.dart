import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'video_container.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Avid',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Avid Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = new VideoPlayerController.network(
      'http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_20mb.mp4',
    )
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      })
      ..initialize();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Padding(
          padding: const EdgeInsets.all(10.0),
          child: new Column(
            children: <Widget>[
              new AspectRatio(
                aspectRatio: 1280 / 720,
                child: new VideoPlayer(_controller),
              ),
              new VideoProgressIndicator(_controller, allowScrubbing: true),
            ],
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed:
            _controller.value.isPlaying ? _controller.pause : _controller.play,
        child: new Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
