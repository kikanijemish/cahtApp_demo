import 'package:flutter/material.dart';

import '../utils/text_const.dart';

class AlertBox{

  void showDiaLog(context, {Function()? okOnTap, subTitle,okTitle}){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert!'),
          content: Text(subTitle),
          actions: [
            TextButton(onPressed: (){Navigator.pop(context);}, child:textBold(text: "cancel", fontSize: 14)),
            TextButton(onPressed: okOnTap, child:textBold(text: okTitle, fontSize: 14)),

          ],
        );
      },);
  }
}