import 'package:flutter/cupertino.dart';

import '../utils/app_color.dart';


class LongButtonConst extends StatelessWidget {
  Widget? child;

  Color? colors, borderColor;
  Function()? onTap;
  double? width,
      radius,
      height,
      borderWidth,
      topPadding,
      leftPadding,
      rightPadding,
      bottomPadding;

  LongButtonConst(
      {this.child,
        this.colors,
        this.onTap,
        this.width,
        this.radius,
        this.borderColor,
        this.height,
        this.borderWidth,
        this.topPadding,
        this.leftPadding,
        this.rightPadding,
        this.bottomPadding});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding:  EdgeInsets.only(top:topPadding?? 5, left:leftPadding?? 5, right:rightPadding?? 5, bottom: 5),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: height ?? 50,
          width: width,
          decoration: BoxDecoration(
              color: colors??AppColors().whiteFA,
              borderRadius: BorderRadius.circular(radius ?? 25),
              border: Border.all(width: borderWidth ?? 0, color: borderColor??AppColors().greyA1)),
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
