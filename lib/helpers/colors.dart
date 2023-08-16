import 'package:flutter/material.dart';

class CColors{
  static const Color primary = Color(0xffD8FC2C);
  static const Color bandslineStrokeColor= Color.fromRGBO(255, 208, 70, 1,);
  static const Color eventsLineStrokeColor= Color.fromRGBO(220, 247, 99, 1);
  static const Color indicationCircle= Color(0xffe0e0e0);
  static const Color lineChartBackgroundLinesStrokeColor= Color.fromRGBO(57, 54, 48, 1);
  static const Color statisticsBgColor= Color(0xff0f0f0f);
  static const Color modelContainerColor= Color(0xff100B00);
  static const Color emptymodelTextColor= Color(0xff9D9D9D);
  static const Color emptyModelBg= Color(0xff1C1C1C);
  static const Color heighlatedColor= Color(0xffFFD046);
  static const Color iconBgColor= Color(0xff3F3F3F);
  static const Color dropDownColor= Color(0xff2c2921);
  static const Color feedContainerViewColor= Color.fromRGBO(255, 255, 255, 0.14);
  static const Color popUpContainerColor= Color(0xff1d1b16);
  static const Color genreOverlay= Color.fromRGBO(0, 0, 0, 0.5);
  static const Color modelColor= Color(0xff181818);
  static const Color cancelTxtColor= Color(0xffF27A59);
  static const Color changeTxtColor= Color(0xff906DD5);
  static const Color profileBgColor= Color.fromRGBO(127, 114, 152, 1);
  static const Color placeholderTextColor= Color.fromRGBO(255, 255, 255, 0.2);
  static const Color profileIconColor= Color.fromRGBO(255, 255, 255, 0.5);
  static const Color searchBarBgColor= Color.fromRGBO(255, 255, 255, 0.15);
  static const Color transparentColor= Color(0x00000000);
  static const Color AlbumSubTxtColor= Color(0xffA7A7A7);
  static const Color AlbumOpacityLayerColor= Color.fromRGBO(0, 0, 0, 0.4);
  static const Color AlbumTitleColor= Color.fromRGBO(167, 167, 167, 1);
  static const Color sideHeadingText= Color.fromRGBO(255, 255, 255, 0.4);
  static const Color playerArtistNameColor= Color.fromRGBO(220, 247, 99, 1);
  static const Color modelBgColor= Color.fromRGBO(0, 0, 0, 0.65);
  static const Color genrBgColor= Color(0xff5E478A);
  static const Color eventViewBgColor= Color.fromRGBO(255, 255, 255, 0.1);
  static const Color calendarBtnBg= Color.fromRGBO(220, 247, 99, 0.3);
  static const Color eventNameTextColor= Color.fromRGBO(220, 247, 99, 1);
  static const Color eventDetailsTextColor= Color.fromRGBO(255, 255, 255, 0.6);
  static const Color eventBgColor= Color.fromRGBO(255, 255, 255, 0.08);
  static const Color dividerColor= Color.fromRGBO(240, 240, 240, 0.2);
  static const Color radiumColour= Color(0xffD8FC2C);
  static const Color blurModelColor= Color.fromRGBO(0, 0, 0, 0.90);
  static const Color errorTextColor= Color.fromRGBO(255, 77, 79, 1);
  static const Color errorBorderColor= Color.fromRGBO(255, 77, 79, 0.4);
  static const Color URbtnColor= Color.fromRGBO(220, 247, 99, 1);
  static const Color labelBgColor= Color.fromRGBO(125, 133, 112, 0.4);
  static const Color URbtnBgColor= Color.fromRGBO(220, 247, 99, 0.2);
  static const Color labelColor= Color.fromRGBO(255, 255, 255, 1);
  static const Color textColor= Color.fromRGBO(255, 255, 255, 0.3);
  static const Color ContainerColor= Color(0x000000);
  static const Color gradientColor1= Color.fromRGBO(41, 31, 42, 1);
  static const Color gradientColor2= Color.fromRGBO(15, 14, 19, 1);
  static const Color White= Color(0xffFFFFFF);
  static const Color Black= Color(0xff000000);
  static const Color screenContainer= Color(0xff212121);
  static const Color queueButton= Color(0xffFFD479);
  static const Color placeholder= Color(0xff828282);
  static const Color error= Color(0xffFF0000);
  static const Color borderColor= Color(0xffdddddd);
  static const Color Grey= Colors.grey;
  static const Color textInputBorder= Color(0xffE0E0E0);
  static const Color correct= Color(0xff27AE60);


  static MaterialColor getMaterialColor() {
    return MaterialColor(primary.value, CColors.getSwatch(primary));
  }

  static Map<int, Color> getSwatch(Color color) {
    final hslColor = HSLColor.fromColor(color);
    final lightness = hslColor.lightness;
    const lowDivisor = 6;
    const highDivisor = 5;
    final lowStep = (1.0 - lightness) / lowDivisor;
    final highStep = lightness / highDivisor;
    return {
      50: (hslColor.withLightness(lightness + (lowStep * 5))).toColor(),
      100: (hslColor.withLightness(lightness + (lowStep * 4))).toColor(),
      200: (hslColor.withLightness(lightness + (lowStep * 3))).toColor(),
      300: (hslColor.withLightness(lightness + (lowStep * 2))).toColor(),
      400: (hslColor.withLightness(lightness + lowStep)).toColor(),
      500: (hslColor.withLightness(lightness)).toColor(),
      600: (hslColor.withLightness(lightness - highStep)).toColor(),
      700: (hslColor.withLightness(lightness - (highStep * 2))).toColor(),
      800: (hslColor.withLightness(lightness - (highStep * 3))).toColor(),
      900: (hslColor.withLightness(lightness - (highStep * 4))).toColor(),
    };
  }
}