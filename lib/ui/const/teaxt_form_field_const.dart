
import 'package:flutter/material.dart';

import '../utils/app_color.dart';
import '../utils/app_fontStyle.dart';
import '../utils/text_const.dart';
import 'container_const.dart';


class TextFormFieldConst extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Widget? suffixIcon,prefixIcon;
  final ValueChanged<String>? onChange;
  final Function()?onTap;
  final bool? isObSecure;
  final TextInputType? keyboardType;
  final double? topPadding;
  final bool? readOnly;
  final int ? maxLine;
  const TextFormFieldConst({Key? key,this.controller, this.onTap,this.maxLine,this.prefixIcon,this.hintText,this.suffixIcon,this.onChange,this.isObSecure,this.keyboardType,this.topPadding,this.readOnly}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(top:topPadding?? 10.0,left: 12,right: 12),
      child: ContainerConst(
        height: 45,
        leftPadding: 0,
        topPadding: 0,
        rightPadding: 0,
        color: AppColors().transparent,
        border: Border.all(color: AppColors().grey75),
        child: TextFormField(
          onTap:onTap ,
          maxLines:maxLine ,
          controller: controller,
          style: AppFontStyle.poppinsRegularTextStyle(14),
          obscureText: isObSecure ?? false,
          obscuringCharacter: "*",
          keyboardType: keyboardType ??TextInputType.text,
          readOnly: readOnly ?? false,
          cursorColor: AppColors().primaryColor,
          onChanged: onChange,
          decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppFontStyle.poppinsRegularTextStyle(14,fontColor: AppColors().greyA1),
              contentPadding: suffixIcon == null && prefixIcon == null ?  const EdgeInsets.only(left: 12) : const EdgeInsets.only(top: 7,left: 12),
              border: InputBorder.none,
              suffixIcon: suffixIcon,
              suffixIconColor: AppColors().primaryColor
          ),
        ),
      ),
    );
  }
}
/// topPadding add =- jemish
class TextFormFieldLabelConst extends StatelessWidget {
  final TextEditingController? controller;
  final String? label,hintText;
  final bool? isObSecure;
  final Widget? suffixIcon,prefixIcon;
  final TextInputType? keyboardType;
  final double? topPadding;
  final bool? readOnly;
  final Function(String)? onChange;
  const TextFormFieldLabelConst({super.key, this.controller,this.suffixIcon,this.hintText,this.label,this.isObSecure,this.keyboardType,this.readOnly, this.topPadding, this.prefixIcon,this.onChange});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(top:topPadding?? 12.0,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textMedium(text: label!,fontSize: 14,topPadding: 00,leftPadding: 3,bottomPadding: 5),
          ContainerConst(
            height: 47,
            leftPadding: 0,
            topPadding: 0,
            rightPadding: 0,
            color: AppColors().transparent,
            border: Border.all(color: AppColors().greyA1),
            child: TextFormField(
              controller: controller,
              style: AppFontStyle.poppinsRegularTextStyle(14),
              obscureText: isObSecure ?? false,
              obscuringCharacter: "*",
              keyboardType: keyboardType ??TextInputType.text,
              readOnly: readOnly ?? false,
              cursorColor: AppColors().primaryColor,
              onChanged: onChange,
              decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: AppFontStyle.poppinsRegularTextStyle(14,fontColor: AppColors().grey75),
                  contentPadding: suffixIcon == null && prefixIcon == null ?  const EdgeInsets.only(left: 12) : const EdgeInsets.only(top: 7,left: 12),
                  border: InputBorder.none,
                  suffixIcon: suffixIcon,
                  suffixIconColor: AppColors().primaryColor
              ),
            ),
          ),
        ],
      ),
    );
  }
}
