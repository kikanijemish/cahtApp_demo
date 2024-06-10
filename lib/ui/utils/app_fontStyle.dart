import 'package:flutter/cupertino.dart';
import 'app_color.dart';


class AppFontStyle {


  static TextStyle poppinsBoldTextStyle(double fontSize,
      {Color? fontColor, FontWeight? fontWeight, bool? isUnderlined}) {
    return TextStyle(
        fontFamily: 'PoppinsBold',
        color: fontColor ?? AppColors().fontColor00,
        fontSize: fontSize,
        decoration: isUnderlined ?? false
            ? TextDecoration.underline
            : TextDecoration.none,
        fontWeight: fontWeight ?? FontWeight.w700,decorationThickness: 1.5 );
  }

  static TextStyle poppinsMediumTextStyle(double fontSize,
      {Color? fontColor, FontWeight? fontWeight,bool? isUnderlined}) {
    return TextStyle(
      fontFamily: 'PoppinsMedium',
      color: fontColor ?? AppColors().fontColor00,
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.w500, decoration: isUnderlined ?? false
        ? TextDecoration.underline
        : TextDecoration.none,
      decorationThickness: 1.5,);
  }

  static TextStyle poppinsSemiBoldTextStyle(double fontSize,
      {Color? fontColor, FontWeight? fontWeight, bool? isUnderlined}) {
    return TextStyle(
        decoration: isUnderlined ?? false
            ? TextDecoration.underline
            : TextDecoration.none,
        fontFamily: 'PoppinsSemiBold',
        color: fontColor ?? AppColors().fontColor00,
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.w600,decorationThickness: 1.5);
  }

  static TextStyle poppinsRegularTextStyle(double fontSize,
      {Color? fontColor, FontWeight? fontWeight, bool? isUnderlined}) {
    return TextStyle(
      fontFamily: 'PoppinsRegular',
      color: fontColor ?? AppColors().fontColor00,
      fontSize: fontSize,
      decoration: isUnderlined ?? false
          ? TextDecoration.underline
          : TextDecoration.none,
      fontWeight: fontWeight ?? FontWeight.w400,decorationThickness: 1.5,);
  }


}
