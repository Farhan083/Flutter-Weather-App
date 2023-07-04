class ScreenSize {
  double getPhoneModel(double mediaQueryHeight) {
    if (mediaQueryHeight >= 812) {
      return mediaQueryHeight * .3;
      // } else if (mediaQueryHeight >= 736) {
      //   return mediaQueryHeight * .4;
    } else if (mediaQueryHeight >= 667) {
      return mediaQueryHeight * .4;
    } else if (mediaQueryHeight >= 568) {
      return mediaQueryHeight * .5;
    } else {
      return mediaQueryHeight * .5;
    }
  }
}
