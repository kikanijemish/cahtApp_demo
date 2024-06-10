import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_1/model/chatrrom_id.dart';
import 'package:task_1/model/user_model.dart';

import '../../../main.dart';
import '../../../model/message_model.dart';
import '../../const/container_const.dart';
import '../../const/teaxt_form_field_const.dart';
import '../../utils/app_color.dart';

class SelectPhotoPage extends StatefulWidget {
  final UserModel userModel;
  final ChatRoomModel chatRoom;

  final String pickerImage;
  const SelectPhotoPage({Key? key, required this.pickerImage, required this.userModel, required this.chatRoom}) : super(key: key);

  @override
  State<SelectPhotoPage> createState() => _SelectPhotoPageState();
}

class _SelectPhotoPageState extends State<SelectPhotoPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          SizedBox(height: 10,),
          Container(
            height: 450,
            width: 400,
            child:Image.network(widget.pickerImage,) ,
          ),
          messageTextFieldConst()
        ],
      ),
    );
  }
  Widget messageTextFieldConst() {
    return ContainerConstWithoutHW(
      color: AppColors().orangeCode.withOpacity(0.15),
      bottomPadding: 10,
      leftPadding: 10,
      topPadding: 10,
      rightPadding: 10,
      child: Row(
        children: [
          const Flexible(
              child: TextFormFieldConst(

                maxLine: null,
                hintText: "Type a message...",
                // controller: messageController,
              )),
          IconButton(
            onPressed: () {
              setImageToFirebase();

            },
            icon: Icon(
              Icons.send_outlined,
              color: AppColors().orangeCode,
            ),
          )
        ],
      ),
    );
  }
  setImageToFirebase(){
    MessageModel newMessage = MessageModel(
        text: "",
        seen: false,
        createdOn: Timestamp.now(),
        messageId: uuid.v1(),
        imageUrl: widget.pickerImage,
        sender: widget.userModel.uid);

    FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(widget.chatRoom.chtRoomId)
        .collection("message")
        .doc(newMessage.messageId)
        .set(newMessage.toMap());
    Navigator.pop(context);

    widget.chatRoom.lastMessage = "image";
    widget.chatRoom.messageTime = Timestamp.now();

    FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(widget.chatRoom.chtRoomId)
        .set(widget.chatRoom.toMap()!);


  }
}
