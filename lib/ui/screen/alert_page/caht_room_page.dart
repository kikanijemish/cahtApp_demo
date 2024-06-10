// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_1/main.dart';
import 'package:task_1/model/chatrrom_id.dart';
import 'package:task_1/model/message_model.dart';
import 'package:task_1/model/user_model.dart';
import 'package:task_1/ui/const/container_const.dart';
import 'package:task_1/ui/const/teaxt_form_field_const.dart';
import 'package:task_1/ui/screen/alert_page/home_page/home_page.dart';
import 'package:task_1/ui/screen/alert_page/onClick_photo_view_page.dart';
import 'package:task_1/ui/screen/alert_page/select_photo_page.dart';
import 'package:task_1/ui/utils/app_color.dart';
import 'package:task_1/ui/utils/text_const.dart';
import 'package:video_player/video_player.dart';
import '../../../notifire/vegicle_notifire.dart';

class ChatRoomPage extends StatefulWidget {
  final UserModel targetUser;
  final UserModel userModel;
  final ChatRoomModel chatRoom;
  final User firebaseUser;

  const ChatRoomPage({
    Key? key,
    required this.targetUser,
    required this.userModel,
    required this.chatRoom,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  VideoPlayerController? videoPlayerController;

  Size? size;
  File? image;
  File? video;
  String pickerImage = "";
  String imageUrl = "";

  VehicleNotifier? vehicleNotifier;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(55), child: appBarConst()),
        body: Column(
          children: [
            chatAreaConst(),
            messageTextFieldConst(),
          ],
        ),
      ),
    );
  }

  Widget chatAreaConst() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoom.chtRoomId)
          .collection("message")
          .orderBy("createdOn", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            QuerySnapshot dataSnapShot = snapshot.data as QuerySnapshot;
            // log("dtasnapshot arwe ${dataSnapShot.docs[0].data()}");

            // data available
            return Expanded(
              child: ListView.builder(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                reverse: true,
                controller: scrollController,
                shrinkWrap: true,
                itemCount: dataSnapShot.docs.length,
                itemBuilder: (context, index) {
                  MessageModel currentMessage = MessageModel.fromMap(
                      dataSnapShot.docs[index].data() as Map<String, dynamic>);
                  String hour =
                      currentMessage.createdOn!.toDate().hour.toString();
                  String min =
                      currentMessage.createdOn!.toDate().minute.toString();
                  imageUrl = currentMessage.imageUrl.toString();
                  log("time are=-=-${currentMessage.createdOn!.toDate()}");
                  log("image url=--==${currentMessage.imageUrl}");


                  log("user id ${widget.userModel.uid}");
                  log("sender id ${currentMessage.sender}");
                  log("target id ${widget.targetUser.uid}");
                  log("message id ${currentMessage.messageId}");
                  if(widget.targetUser.uid==widget.userModel.uid){
                    FirebaseFirestore.instance
                        .collection("chatrooms")
                        .doc(widget.chatRoom.chtRoomId)
                        .collection("message").doc(currentMessage.messageId!).update({"seen":true});
                  }


                  return Column(
                    crossAxisAlignment:
                        currentMessage.sender == widget.userModel.uid
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (currentMessage.imageUrl == "")
                        Dismissible(
                          key: Key(currentMessage.messageId!),
                          direction: DismissDirection.horizontal,
                          onDismissed: (direction) {
                            if (direction == DismissDirection.startToEnd) {
                              // Handle swipe from left to right (reply)
                              // showReplyDialog(currentMessage);
                            }
                          },
                          background: Container(
                            color: AppColors().orangeCode.withOpacity(0.5),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 16.0),
                            child: const Icon(Icons.reply),
                          ),
                          child: Stack(
                            children: [
                              ContainerConstWithoutHW(
                                onLongPress: () {
                                  currentMessage.sender == widget.userModel.uid
                                      ? deleteMessage(currentMessage.messageId!)
                                      : "";
                                  // messageDelete(currentMessage.messageId!,);
                                },
                                onTap: () {
                                  // log(" message are ${currentMessage.text![index].toString()}");
                                },
                                color: currentMessage.text ==
                                        "This message has been deleted"
                                    ? AppColors().orangeCode.withOpacity(0.4)
                                    : AppColors().orangeCode,
                                topPadding: 2,
                                bottomPadding: 0,
                                leftPadding: currentMessage.sender ==
                                        widget.userModel.uid
                                    ? 50
                                    : 10,
                                rightPadding: currentMessage.sender ==
                                        widget.userModel.uid
                                    ? 10
                                    : 50,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    textRegular(
                                        text: currentMessage.text.toString(),
                                        fontSize: 12,
                                        textAlign: TextAlign.left,
                                        textOverflow: TextOverflow.fade,
                                        topPadding: 5,
                                        bottomPadding: 0,
                                        rightPadding: 25),
                                    textSemiBold(
                                        text: "$hour:$min",
                                        fontSize: 8,
                                        textAlign: TextAlign.right,
                                        topPadding: 0,
                                        rightPadding: 5),
                                  ],
                                ),
                              ),
                              currentMessage.sender == widget.userModel.uid
                                  ?  Positioned(
                                      top: 03,
                                      left: 50,
                                      child: Icon(

                                        Icons.done_outline_rounded,
                                        color: currentMessage.seen==true? AppColors().white:AppColors().black27,
                                        size: 8,
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        )
                      else
                        Stack(
                          // alignment: Alignment.bottomRight,
                          children: [
                            ContainerConst(
                              onLongPress: () {
                                currentMessage.sender == widget.userModel.uid
                                    ? deleteMessage(currentMessage.messageId!)
                                    : "";
                              },
                              border: Border.all(
                                  color: AppColors().orangeCode, width: 2),
                              radius: 8,
                              height: 180,
                              width: 200,
                              color: AppColors().orangeCode.withOpacity(0.15),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: InkWell(
                                  onTap: () {
                                    log("photo are viewed");
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PhotoViewPage(
                                          imageView: currentMessage.imageUrl
                                              .toString(),
                                          profileView: "",
                                        ),
                                      ),
                                    );
                                  },
                                  child: Image.network(
                                    currentMessage.imageUrl.toString(),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 5,
                              right: 15,
                              child: textSemiBold(
                                  text: "$hour:$min",
                                  fontSize: 8,
                                  textAlign: TextAlign.right,
                                  topPadding: 0,
                                  fontColor: AppColors().white,
                                  rightPadding: 5),
                            ),
                          ],
                        )
                    ],
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            return textBold(text: "Error accrued Something", fontSize: 14);
          } else {
            return textBold(text: "Say hi! to your friend", fontSize: 14);
          }
        } else {
          return Center(child: Container());
        }
        return Container();
      },
    );
  }

  // void showReplyDialog(message) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       String replyText = '';
  //       return AlertDialog(
  //         title: const Text('Reply to Message'),
  //         content: TextField(
  //           onChanged: (value) {
  //             replyText = value;
  //           },
  //           decoration: const InputDecoration(hintText: 'Enter your reply...'),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('Cancel'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: const Text('Send'),
  //             onPressed: () {
  //               if (replyText.isNotEmpty) {
  //                 sendReply(message, replyText);
  //               }
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void sendReply(MessageModel? originalMessage, String replyText) {
  //   final MessageModel newMessage = MessageModel(
  //       text: replyText,
  //       seen: false,
  //       createdOn: Timestamp.now(),
  //       messageId: uuid.v1(),
  //       imageUrl: pickerImage,
  //       sender: widget.userModel.uid);
  //
  //   FirebaseFirestore.instance
  //       .collection("chatrooms")
  //       .doc(widget.chatRoom.chtRoomId)
  //       .collection("message")
  //       .doc(newMessage.messageId)
  //       .set(newMessage.toMap());
  // }

  void deleteMessage(messageId) async {
    QuerySnapshot lastMessageQuery = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(widget.chatRoom.chtRoomId)
        .collection("message")
        .orderBy("createdOn", descending: true)
        .get();
    log("full snapshot are ${lastMessageQuery.docs.first.id} ");
    if (lastMessageQuery.docs.first.id == messageId) {
      DocumentSnapshot lastMessageSnapshot = lastMessageQuery.docs.first;
      DocumentReference lastMessageRef = lastMessageSnapshot.reference;
      await lastMessageRef
          .update({"text": "This message has been deleted", "imageUrl": ""});
      widget.chatRoom.lastMessage = "This message has been deleted";
      widget.chatRoom.messageTime = Timestamp.now();
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoom.chtRoomId)
          .set(widget.chatRoom.toMap()!);
    } else {
      final DocumentReference messageRef = FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoom.chtRoomId)
          .collection("message")
          .doc(messageId);
      await messageRef.update({"text": "This message has been deleted"});
    }
  }

  Widget messageTextFieldConst() {
    return Stack(children: [
      ContainerConstWithoutHW(
        color: AppColors().orangeCode.withOpacity(0.15),
        bottomPadding: 10,
        leftPadding: 10,
        topPadding: 10,
        rightPadding: 10,
        child: Row(
          children: [
            Flexible(
                child: TextFormFieldConst(
              suffixIcon: IconButton(
                  onPressed: () {
                    if (messageController.text == "") {
                      pickImage(ImageSource.gallery);
                    }
                  },
                  icon: const Icon(Icons.photo)),
              maxLine: null,
              hintText: "Type a message...",
              controller: messageController,
            )),
            IconButton(
              onPressed: () {
                sendMessage();
              },
              icon: Icon(
                Icons.send_outlined,
                color: AppColors().orangeCode,
              ),
            )
          ],
        ),
      ),
    ]);
  }

  Widget appBarConst() {
    return AppBar(
      backgroundColor: AppColors().orangeCode,
      leading: IconButton(
        icon:const Icon(Icons.arrow_back_rounded),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                  userModel: widget.userModel,
                  firebaseUser: widget.firebaseUser),
            ),
          );
        },
      ),
      title: Row(
        children: [
          InkWell(
            onTap: () {
              log("photo are viewed");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhotoViewPage(
                    imageView: "",
                    profileView: widget.targetUser.profilePic.toString(),
                  ),
                ),
              );
            },
            child: CircleAvatar(
              backgroundColor: AppColors().greyA1,
              backgroundImage: NetworkImage(
                widget.targetUser.profilePic.toString(),
              ),
            ),
          ),
          textBold(text: widget.targetUser.fullName.toString(), fontSize: 14)
        ],
      ),
      actions: [popupMenuButtonConst()],
    );
  }

  void sendMessage() {
    String msg = messageController.text.trim();
    if (msg != "") {
      final MessageModel newMessage = MessageModel(
          text: msg,
          seen: false,
          createdOn: Timestamp.now(),
          messageId: uuid.v1(),
          imageUrl: pickerImage,
          sender: widget.userModel.uid);

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoom.chtRoomId)
          .collection("message")
          .doc(newMessage.messageId)
          .set(newMessage.toMap());

      widget.chatRoom.lastMessage = messageController.text.trim();
      widget.chatRoom.messageTime = Timestamp.now();

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoom.chtRoomId)
          .set(widget.chatRoom.toMap()!);
      messageController.clear();
    }

    // }
  }



  Future<File?> pickVideo() async {
    final picker = ImagePicker();
    XFile? pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        video = File(pickedFile.path);
      });
      uploadVideo(video!);
      // return video;
    }
    return null;
  }

  Future<String?> uploadVideo(File videoFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("videochat")
        .child("$fileName.Mp4")
        .putFile(
          File(videoFile.path),
        );

    TaskSnapshot snapshot = await uploadTask;
    String videoUrl = await snapshot.ref.getDownloadURL();
    if (videoUrl != "") {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectPhotoPage(
            userModel: widget.userModel,
            chatRoom: widget.chatRoom,
            pickerImage: videoUrl,
          ),
        ),
      );
    }

    // ;

    return null;
  }

  Future pickImage(ImageSource picImage) async {
    try {
      XFile? pickImage = await ImagePicker().pickImage(source: picImage);
      if (pickImage != null) {
        cropImage(pickImage);
      } else {
        pickerImage = "";
        if (pickerImage == "") {
          pickVideo();
        }
      }
    } on PlatformException catch (e) {
      Get.snackbar("Exception", e.toString());
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 20);
    if (croppedImage != null) {
      setState(
        () {
          pickerImage = croppedImage.path;
        },
      );
      // vehicleNotifier!.pickImage(true);
      uploadImage();
    }
  }

  void uploadImage() async {
    UploadTask uploadTask =
        FirebaseStorage.instance.ref("chatPicture").child(uuid.v4()).putFile(
              File(pickerImage),
            );
    TaskSnapshot snapshot = await uploadTask;
    String imageUrl = await snapshot.ref.getDownloadURL();
    log("picked image are ==---$imageUrl");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectPhotoPage(
          userModel: widget.userModel,
          chatRoom: widget.chatRoom,
          pickerImage: imageUrl,
        ),
      ),
    );
  }

// Assuming you have set up Firebase and have a reference to the chat messages collection or chat room

// Function to clear the chat
  void clearChat() async {
    CollectionReference chatRoomRef = FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(widget.chatRoom.chtRoomId)
        .collection("message");
    QuerySnapshot messagesSnapshot = await chatRoomRef.get();

    // Iterate through the messages and update each message to indicate it has been cleared
    for (DocumentSnapshot doc in messagesSnapshot.docs) {
      await doc.reference.delete();
    }
  }

  Widget popupMenuButtonConst() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'Clear') {
          clearChat();
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'Clear',
          child: textRegular(
              text: "Clear Chat",
              fontSize: 14,
              topPadding: 0,
              bottomPadding: 0,
              rightPadding: 0),
        ),
      ],
    );
  }
}

