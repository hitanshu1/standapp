import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class AnimationOpacity extends StatefulWidget {
  Widget child;
  int durationInMM;
  AnimationController controller;

  AnimationOpacity({this.child, this.durationInMM = 1000});
  _AnimationOpacityState createState() => _AnimationOpacityState();
}

class _AnimationOpacityState extends State<AnimationOpacity>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;

  @override
  initState() {
    super.initState();
    widget.controller = AnimationController(
        duration:  Duration(milliseconds: widget.durationInMM), vsync: this);
    animation = Tween(begin: 0.1, end: 1.0).animate(widget.controller)
      ..addListener(() {
        setState(() {});
      });
    widget.controller.forward();
  }

  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: animation.value,
        child: widget.child,
      ),
    );
  }

  @override
  dispose() {
    print("disposing animationOpacity=>${widget.controller}");
    widget.controller?.dispose();
    super.dispose();
  }
}
