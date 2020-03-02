class ScreenRatio {
  static double heightRatio;
  static double widthRatio;
  static double screenheight;
  static double screenwidth;

  static String deviceInfo;

  static setScreenRatio(
      {double currentScreenHeight, double currentScreenWidth,String deviceInfo}) {
    screenheight = currentScreenHeight;
    screenwidth = currentScreenWidth;
    heightRatio = currentScreenHeight / 812.0;
    widthRatio = currentScreenWidth / 375.0;
    deviceInfo = deviceInfo;
  }
}
