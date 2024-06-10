// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_1/main.dart';
import 'package:task_1/model/user_model.dart';
import 'package:task_1/ui/const/long_button_const.dart';
import 'package:task_1/ui/const/teaxt_form_field_const.dart';
import 'package:task_1/ui/utils/app_color.dart';
import 'package:task_1/ui/utils/text_const.dart';
import '../../../model/chatrrom_id.dart';
import 'caht_room_page.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User fireBaseUser;

  const SearchPage(
      {Key? key, required this.userModel, required this.fireBaseUser})
      : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  Future<ChatRoomModel?> getChatRoomModel(UserModel targetUser) async {
    ChatRoomModel chatRoom;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${widget.userModel.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.length > 0) {
      // already exist chatroom
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatRoom =
      ChatRoomModel.fromMap(docData as Map<String, dynamic>);
      chatRoom = existingChatRoom;
      print("already exist chatroom ");
    } else {
      // create new chatroom
      ChatRoomModel newChatRoom = ChatRoomModel(
        chtRoomId: uuid.v1(),
        messageTime: Timestamp.now(),
        lastMessage: "",
        participants: {
          widget.userModel.uid.toString(): true,
          targetUser.uid.toString(): true,
        },
      );

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatRoom.chtRoomId)
          .set(newChatRoom.toMap()!);

      chatRoom = newChatRoom;
      print("account created ");
    }
    return chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: textBold(text: "Search", fontSize: 14, topPadding: 0),
          centerTitle: true,
          backgroundColor: AppColors().orangeCode,
        ),
        body: bodyData(),
      ),
    );
  }

  Widget bodyData() {
    return Column(
      children: [searchFieldConst(), searchButton(), listTileConst()],
    );
  }

  Widget searchFieldConst() {
    return TextFormFieldConst(
      topPadding: 10,
      hintText: "Search Here",
      controller: searchController,
    );
  }

  Widget searchButton() {
    return LongButtonConst(
      width: 100,
      topPadding: 15,
      colors: AppColors().orangeCode,
      radius: 8,
      onTap: () {
        setState(() {});
      },
      child: textMedium(text: "Search", fontSize: 14, topPadding: 0),
    );
  }

  Widget listTileConst() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("User")
            .where("email", isEqualTo: searchController.text.trim())
            .where("email", isNotEqualTo: widget.userModel.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              QuerySnapshot dataSnpShot = snapshot.data as QuerySnapshot;

              if (dataSnpShot.docs.length > 0) {
                Map<String, dynamic> userMap;
                userMap = dataSnpShot.docs[0].data() as Map<String, dynamic>;
                UserModel searchUser = UserModel.fromMap(userMap);
                return ListTile(
                  onTap: () async {
                    ChatRoomModel? chatRoomModel =
                    await getChatRoomModel(searchUser);
                    if (chatRoomModel != null) {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatRoomPage(

                              userModel: widget.userModel,
                              firebaseUser: widget.fireBaseUser,
                              chatRoom: chatRoomModel,
                              targetUser: searchUser,
                            ),
                          ));
                    }
                  },
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(searchUser.profilePic.toString()),
                  ),
                  title: textSemiBold(
                      text: searchUser.fullName.toString(),
                      fontSize: 14,
                      topPadding: 0,
                      leftPadding: 2),
                  subtitle: textSemiBold(
                      text: searchUser.email.toString(),
                      fontSize: 14,
                      topPadding: 0,
                      leftPadding: 2),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),
                );
              } else {
                return textRegular(text: "No Result Found ", fontSize: 14);
              }
            } else if (snapshot.hasError) {
              return textRegular(text: "Error Accursed Something", fontSize: 14);
            } else {
              return textRegular(text: "No Data Found", fontSize: 14);
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
