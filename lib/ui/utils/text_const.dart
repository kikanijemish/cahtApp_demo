
import 'package:flutter/cupertino.dart';
import 'app_fontStyle.dart';

Widget textBold({
  required String text,
  required double fontSize,
  Color? fontColor,

  double? topPadding,
  double? leftPadding,
  double? rightPadding,
  double? bottomPadding,
  TextAlign? textAlign,
  bool? isUnderlined,
  TextOverflow? textOverflow,
}) {
  return Padding(
    padding: EdgeInsets.only(
        top: topPadding ?? 12.0,
        left: leftPadding ?? 12,
        right: rightPadding ?? 12.0,
        bottom: bottomPadding ?? 0.0),
    child: Text(
      text,
      style: AppFontStyle.poppinsBoldTextStyle(fontSize,
          fontColor: fontColor,isUnderlined:isUnderlined),
      textAlign:textAlign?? TextAlign.start,
      overflow: textOverflow ?? null,
    ),
  );
}


Widget textSemiBold({
  required String text,
  required double fontSize,
  Color? fontColor,

  double? topPadding,
  double? leftPadding,
  double? rightPadding,
  double? bottomPadding,
  TextAlign? textAlign,
  bool? isUnderlined,
  TextOverflow? textOverflow,
}) {
  return Padding(
    padding: EdgeInsets.only(
        top: topPadding ?? 12.0,
        left: leftPadding ?? 12,
        right: rightPadding ?? 12.0,
        bottom: bottomPadding ?? 0.0),
    child: Text(
      text,
      style: AppFontStyle.poppinsSemiBoldTextStyle(fontSize,
          fontColor: fontColor,isUnderlined:isUnderlined),
      textAlign:textAlign?? TextAlign.start,
      overflow: textOverflow ?? null,
    ),
  );
}

Widget textMedium({
  required String text,
  required double fontSize,
  Color? fontColor,
  double? topPadding,
  double? leftPadding,
  double? rightPadding,
  double? bottomPadding,
  TextAlign? textAlign,
  bool? isUnderlined,
  TextOverflow? textOverflow,
}) {
  return Padding(
    padding: EdgeInsets.only(
        top: topPadding ?? 12.0,
        left: leftPadding ?? 12,
        right: rightPadding ?? 12.0,
        bottom: bottomPadding ?? 0.0),
    child: Text(
      text,
      style: AppFontStyle.poppinsMediumTextStyle(fontSize,
          fontColor: fontColor,isUnderlined:isUnderlined),
      textAlign:textAlign?? TextAlign.start,
      overflow: textOverflow ?? null,
    ),
  );
}

Widget textRegular({
  required String text,
  required double fontSize,
  Color? fontColor,
  double? topPadding,
  double? leftPadding,
  double? rightPadding,
  double? bottomPadding,
  TextAlign? textAlign,
  bool? isUnderlined,softWrap,
  TextOverflow? textOverflow,
}) {
  return Padding(
    padding: EdgeInsets.only(
        top: topPadding ?? 12.0,
        left: leftPadding ?? 12,
        right: rightPadding ?? 12.0,
        bottom: bottomPadding ?? 0.0),
    child: Text(


      text,
      style: AppFontStyle.poppinsRegularTextStyle(fontSize,

          fontColor: fontColor,isUnderlined:isUnderlined ),
      textAlign:textAlign?? TextAlign.start,
      overflow: textOverflow ?? null,
    ),
  );
}
