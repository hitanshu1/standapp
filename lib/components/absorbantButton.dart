import 'dart:async';

import 'package:flutter/material.dart';
import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/screenRatio.dart';

class AbsorbantButton extends StatefulWidget {
  final String label;
  final double width;
  final Function onPressed;
  final Color color;
  bool disabled;
  bool loading = false;
  bool shadow;

  AbsorbantButton({
    this.width,
    this.label,
    this.onPressed,
    this.color,
    this.disabled = false,
    this.shadow = false,
  });

  @override
  AbsorbantButtonState createState() {
    return new AbsorbantButtonState();
  }
}

class AbsorbantButtonState extends State<AbsorbantButton> {
//  int numberOfTaps = 0;
  double _buttonSize = 60.0 * ScreenRatio.heightRatio;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: loading,
      child: new InkWell(
//        enableFeedback: false,
        onTap: () async {
          setState(() {
            loading = true;
          });
          print("pressed");
          await widget.onPressed();

          setState(() {
            loading = false;
          });
//          }
        },
        child: new AnimatedContainer(
          duration: Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          width: loading ? _buttonSize : widget.width,
          height: _buttonSize,
          decoration: new BoxDecoration(
            color: !widget.disabled
                ? (widget.color ?? Colors.white)
                : Colors.white10,
            border: new Border.all(
                color: !widget.disabled
                    ? ColorConstants.primaryTextColor
                    : Colors.white70,
                width: 2.0),
            borderRadius: loading
                ? new BorderRadius.circular(400.0)
                : new BorderRadius.circular(100.0),
//            borderRadius: new BorderRadius.circular(100.0),
            boxShadow: widget.shadow
                ? [
                    BoxShadow(
                        color: Colors.grey[200],
                        blurRadius: 4.0,
                        spreadRadius: 2)
                  ]
                : [],
          ),
          child: new Center(
            child: loading
                ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            )
                : new Text(
              widget.label,
              style: new TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14.0 * ScreenRatio.heightRatio,
                  color: !widget.disabled
                      ? Colors.white
                      : ColorConstants.primaryTextColor.withAlpha(100),
                  fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ),
    );
  }
}
