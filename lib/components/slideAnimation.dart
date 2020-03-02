import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class SlideAnimation extends StatefulWidget {
  Widget child;
  int durationInMM;
  AnimationController controller;

  SlideAnimation({this.child,this.durationInMM=3000});
  _SlideAnimationState createState() => _SlideAnimationState();
}

class _SlideAnimationState extends State<SlideAnimation>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;


  @override
  initState() {
    super.initState();
    widget.controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
//    print(" widget.controller ${ widget.controller}");
    final CurvedAnimation curve =
    CurvedAnimation(parent: widget.controller, curve: Curves.bounceInOut);
    animation = Tween(begin: -400.0, end: 32.0).animate(curve)
      ..addListener(() {
//        print("listening");
//        print( widget.controller);
        setState(() {});
      });
    widget.controller.forward();


  }

  Widget build(BuildContext context) {
    return Positioned(
      left: animation.value,
      child: widget.child,
    );
  }

  @override
  dispose() {
    print("disposing animation widget");
//    widget.controller?.stop();
    widget.controller?.dispose();
    super.dispose();
  }
}
