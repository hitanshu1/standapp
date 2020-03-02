import 'package:flutter/material.dart';
import 'package:standapp/utils/screenRatio.dart';

class RoundedButton extends StatelessWidget {
  final String label;
  final double width;
  final Function onPressed;
  final Color textColor;
  final Color backgroundColor;
  final bool shadow;
  final bool buttonDisabled;
  RoundedButton(
      {this.width,
      this.label,
      this.onPressed,
      this.textColor,
      this.backgroundColor,
      this.shadow,
      this.buttonDisabled = false});

  double _buttonSize = 70.0 * ScreenRatio.heightRatio;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
//      onTap: buttonDisabled ? null : onPressed,
      onTap: () {
        print("buttonDisabled=>${buttonDisabled}");
        buttonDisabled ? null : onPressed();
      },
      child: new AnimatedContainer(
        duration: Duration(milliseconds: 1200),
        curve: Curves.easeInOut,
        width: buttonDisabled ? _buttonSize : width,
        height: _buttonSize,
        decoration: new BoxDecoration(
          color: backgroundColor,
          // border: Border.all(color: Colors.white, width: 2.0),
          borderRadius: buttonDisabled
              ? new BorderRadius.circular(400.0)
              : new BorderRadius.circular(100.0),
          boxShadow: shadow
              ? [
                  BoxShadow(
                      color: Colors.grey[200], blurRadius: 4.0, spreadRadius: 2)
                ]
              : [],
        ),
        child: Center(
          child: buttonDisabled
              ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
          )
              : new Text(
            label,
            style: new TextStyle(
                fontSize: 18.0 * ScreenRatio.heightRatio,
                color: textColor,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
