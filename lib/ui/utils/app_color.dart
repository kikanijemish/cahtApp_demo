import 'package:flutter/material.dart';

class AppColors {
  factory AppColors() {
    return _singleton;
  }

  AppColors._internal();
  static final AppColors _singleton = AppColors._internal();
  final Color whiteFA = const Color(0XFFFAFAFA);
  final Color orangeCode = const Color(0xfff77760);
  final Color primaryColor = const Color(0XFF6A2475);
  final Color fontColor74 = const Color(0XFF749A96);
  final Color white = const Color(0XFFFFFFFF);
  final Color greyA1 = const Color(0XFFa1a1a1);
  final Color black27 = const Color(0XFF272727);
  final Color fontColor00 = const Color(0XFF003F40);
  final Color grey75 = const Color(0XFF757575);
  final Color backGroundColor = const Color(0XFFf2f2f2);
  final Color redCode = const Color(0XFFD72E1F);
  final Color greenCode = const Color(0XFF3C8836);



  final Gradient orangeGradient=  const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment(0.8, 1),
    colors: <Color>[
      Color(0xffefb8ae),
      Color(0xffe28e7f),
      Color(0xfff78a76),
      Color(0xfff77760),
    ],
    tileMode: TileMode.mirror,
  );

  final Color transparent = Colors.transparent;

}
