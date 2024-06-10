import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_1/ui/const/container_const.dart';
import 'package:task_1/ui/utils/app_color.dart';

class PhotoViewPage extends StatefulWidget {
  final String imageView;
  final String profileView;

  const PhotoViewPage(
      {Key? key, required this.imageView, required this.profileView})
      : super(key: key);

  @override
  State<PhotoViewPage> createState() => _PhotoViewPageState();
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors().orangeCode,
        ),
        backgroundColor: AppColors().black27,
        body: Center(
          child: ContainerConst(
            height: 250,
            width: double.infinity,
            leftPadding: 0,
            rightPadding: 0,
            radius: 0,
            child: widget.imageView !=""?Image.network(
              widget.imageView,
              fit: BoxFit.fitHeight,
            ):Image.network(
              widget.profileView,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ),
    );
  }
}
