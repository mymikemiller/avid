import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class PlayerContainer extends StatefulWidget {

  PlayerContainer({Key key}) : super(key: key);

  @override
  PlayerContainerState createState() => new PlayerContainerState();
}

class PlayerContainerState extends State<PlayerContainer> {
  bool _isPlaying = false;
  bool _isInitialized = false;
  bool _isShowingControllerBar = false;
  VideoPlayerController _controller;
  Timer _hideTimer;

  void _controllerStateChange(){
    final bool isPlaying = _controller?.value?.isPlaying ?? false;
    if (isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = isPlaying;
      });
    }

    final bool isInitialized = _controller?.value?.initialized ?? false;
    if (_isInitialized != isInitialized) {
      setState(() {
        _isInitialized = isInitialized;
      });
    }
  }

  void load(String url, [bool autoplay = false]) {   
    setState(() {
      _isInitialized = false;
      _isPlaying = false;
    });
    if (_controller != null) {
      // _controller.pause();
      _controller.dispose();
    }
    _controller = new VideoPlayerController.network(url)
    ..addListener(_controllerStateChange)
    ..initialize();

    if (autoplay) { 
      _controller.play();
      setState(() {
        _isShowingControllerBar = true;
      });
    }
  }

  void _seek(seconds) {
    assert(_controller != null);
     _controller.seekTo(new Duration(seconds: _controller.value.position.inSeconds + seconds));
  }

  @override
  void dispose() {
    print("Disposing PlayerContainer");
    _controller?.dispose();
    _stopHideTimer();
    super.dispose();
  }

  Widget _buildControllerBar(BuildContext context) {
    return new AnimatedOpacity(
      opacity: _isShowingControllerBar ? 1.0 : 0.0,
      duration: Duration(milliseconds: 200),
      child: new IconTheme(
        data: Theme.of(context).accentIconTheme,
        child: new Container(
          height: 48.0,
          color: Colors.black45,
          child: new Offstage(
            offstage: _controller == null,
            child: new Row(
              children: <Widget>[
                new IconButton(
                  icon: new Icon(
                    (_controller?.value?.isPlaying ?? false) ? Icons.pause : Icons.play_arrow,
                  ),
                  onPressed: () => _controller.value.isPlaying ? _controller.pause() : _controller.play(),
                ),
                new IconButton(
                  icon: new Icon(
                    Icons.replay_10,
                  ),
                  onPressed: () { _seek(-10);},
                ),
                new Expanded(
                  child: new VideoScrubber(
                    controller: _controller,
                    onStartScrub: _stopHideTimer,
                    onEndScrub: _startHideTimer,
                    child:  _controller != null ? VideoProgressIndicator(_controller, allowScrubbing: false) : Container(),
                  ),
                ),
                // new Expanded(
                //   child: _controller != null ? VideoProgressIndicator(_controller, allowScrubbing: true) : Container(),
                // ),
                new IconButton(
                  icon: new Icon(
                    Icons.forward_10,
                  ),
                  onPressed: () { _seek(10);},
                ),
              ],
            ),
          )
        ),
      ),
    );
  }

  void _startHideTimer() {
    _stopHideTimer();
    _hideTimer = Timer(Duration(seconds: 2), () {
      setState(() {
        _isShowingControllerBar = false;
      });
    });
  }

  void _stopHideTimer() {
    _hideTimer?.cancel();
  }

  void _onTapVideoPlayer() {
    if (!_isShowingControllerBar) {
      _startHideTimer();
    }
    setState(() => _isShowingControllerBar = !_isShowingControllerBar);
  }

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
      aspectRatio: 1280 / 720,
      child: new GestureDetector(
        onTap: _onTapVideoPlayer,
        child: new Container(
          color: Colors.black,
          child: new Stack(
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              _controller != null ? VideoPlayer(_controller) : Container(),
              _buildControllerBar(context),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoScrubber extends StatefulWidget {
  final VideoPlayerController controller;
  final VoidCallback onStartScrub;
  final VoidCallback onEndScrub;
  final Widget child;

  const VideoScrubber({
    Key key,
    @required this.controller, 
    this.onStartScrub, 
    this.onEndScrub, 
    @required this.child,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VideoScrubberState();

}

class _VideoScrubberState extends State<VideoScrubber> {
  bool _controllerWasPlaying = false;

  VideoPlayerController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    void seekToRelativePosition(Offset globalPosition) {
      final RenderBox box = context.findRenderObject();
      final Offset tapPos = box.globalToLocal(globalPosition);
      final double relative = tapPos.dx / box.size.width;
      final Duration position = controller.value.duration * relative;
      controller.seekTo(position);
    }

    return new GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: widget.child,
      onHorizontalDragStart: (DragStartDetails details) {
        if (!controller.value.initialized) {
          return;
        }
        _controllerWasPlaying = controller.value.isPlaying;
        if (_controllerWasPlaying) {
          controller.pause();
        }
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (!controller.value.initialized) {
          return;
        }
        seekToRelativePosition(details.globalPosition);
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        if (_controllerWasPlaying) {
          controller.play();
        }
        widget?.onEndScrub();
      },
      onTapDown: (TapDownDetails details) {
        if (!controller.value.initialized) {
          return;
        }
        widget?.onStartScrub();
        seekToRelativePosition(details.globalPosition);
      },
      onTapUp: (_) => widget?.onEndScrub(),
      onTapCancel: () => widget?.onEndScrub()
    );
  }
}