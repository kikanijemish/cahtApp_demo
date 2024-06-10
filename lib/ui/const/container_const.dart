
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/app_color.dart';


class ContainerConst extends StatelessWidget {
  final double? height,width,radius;
  final double? topPadding,bottomPadding,leftPadding,rightPadding;
  final Color? color;
  final Widget? child;
  final Border? border;
  final Function()? onTap,onLongPress;
  const ContainerConst({Key? key,this.child,this.onLongPress,this.radius,this.width,this.height,this.rightPadding,this.leftPadding,this.bottomPadding,this.topPadding,this.color,this.border,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: topPadding ?? 8.0,bottom: bottomPadding ?? 0.0,left: leftPadding ?? 12.0,right: rightPadding ?? 12.0),
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          height:height ?? size.height,
          width: width ?? size.width,
          decoration: BoxDecoration(
              color: color ?? AppColors().white,
              borderRadius: BorderRadius.circular(radius ?? 8),
              border: border ?? null),
          child: child,
        ),
      ),
    );
  }
}

class ContainerConstWithoutHW extends StatelessWidget {
  final double? radius;
  final double? topPadding,bottomPadding,leftPadding,rightPadding;
  final Color? color;
  final Widget? child;
  final Border? border;
  final Function()? onTap,onLongPress;
  final  Gradient? gradientColor;
  final  EdgeInsetsGeometry?margin;
  const ContainerConstWithoutHW({Key? key,this.child,this.radius,this.onLongPress,this.rightPadding,this.leftPadding,this.bottomPadding,this.topPadding,this.color,this.border,this.onTap, this.gradientColor, this.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: topPadding ?? 8.0,bottom: bottomPadding ?? 0.0,left: leftPadding ?? 12.0,right: rightPadding ?? 12.0),
      child: GestureDetector(
         onLongPress:onLongPress ,
        onTap: onTap,
        child: Container(
          margin:margin ,
          decoration: BoxDecoration(
            gradient:gradientColor,

              color: color ?? AppColors().white,
              borderRadius: BorderRadius.circular(radius ?? 8),
              border: border ?? null),
          child: child,
        ),
      ),
    );
  }
}


