import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_1/model/chatrrom_id.dart';
import 'package:task_1/model/firebse_hgelper_model.dart';
import 'package:task_1/model/user_model.dart';
import 'package:task_1/ui/const/Alert_box_const.dart';
import 'package:task_1/ui/screen/alert_page/caht_room_page.dart';
import 'package:task_1/ui/screen/alert_page/search_page.dart';
import 'package:task_1/ui/screen/auth_page/login_page.dart';
import 'package:task_1/ui/screen/auth_page/profile_page.dart';
import 'package:task_1/ui/utils/app_color.dart';
import 'package:task_1/ui/utils/text_const.dart';

import '../../../../model/message_model.dart';
import '../../../../notifire/vegicle_notifire.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const HomePage(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    userStatus("Online");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // user are online
      userStatus("Online");
    } else {
      // user are offline
      userStatus("Offline");
    }
  }

  void userStatus(status) {
    FirebaseFirestore.instance
        .collection("User")
        .doc(widget.userModel.uid)
        .update({"status": status});
  }
VehicleNotifier? vehicleNotifier;
  @override
  Widget build(BuildContext context) {
    vehicleNotifier = Provider.of<VehicleNotifier>(context, listen: true);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: textBold(text: "chat Page", fontSize: 14),
          centerTitle: true,
          backgroundColor: AppColors().orangeCode,
          automaticallyImplyLeading: false,
          actions: [
            popupMenuButtonConst(),
          ],
        ),
        // backgroundColor: AppColors().primaryColor,
        floatingActionButton: floatingButton(),
        body: bodyData(),
      ),
    );
  }

  Widget bodyData() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("chatrooms")
          .where("participants.${widget.userModel.uid}", isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            // has data
            QuerySnapshot chatRoomSnapShot = snapshot.data as QuerySnapshot;
            return ListView.builder(
              itemCount: chatRoomSnapShot.docs.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                ChatRoomModel chatRoom = ChatRoomModel.fromMap(
                    chatRoomSnapShot.docs[index].data()
                        as Map<String, dynamic>);

                Map<String, dynamic> participants = chatRoom.participants!;
                log("participant are 1 $participants");
                List<String> targetParticipant = participants.keys.toList();
                targetParticipant.remove(widget.userModel.uid);
                log("target user id are ===> $targetParticipant");

                return FutureBuilder(
                  future: FirebaseHelperModel.getUserModelByuUid(
                    targetParticipant[0],
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      String fullDate =
                          chatRoom.messageTime!.toDate().toString().split(" ")[0];
                      String date =
                          chatRoom.messageTime!.toDate().toString().split(" ")[0]
                              .substring(8);
                      String month = fullDate.split("-")[1];
                      String year = fullDate.split("-")[0];
                      UserModel targetUser = snapshot.data as UserModel;
                      log("target user are  $targetUser");
                      if (snapshot.data != null) {
                        return ListTile(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatRoomPage(
                                    targetUser: targetUser,
                                    userModel: widget.userModel,
                                    chatRoom: chatRoom,
                                    firebaseUser: widget.firebaseUser),
                              ),
                            );

                          },
                          leading: CircleAvatar(
                            backgroundColor: AppColors().greyA1,
                            backgroundImage:
                                NetworkImage(targetUser.profilePic.toString()),
                          ),
                          title: textSemiBold(
                              text: targetUser.fullName.toString(),
                              fontSize: 14,
                              topPadding: 0,
                              leftPadding: 2),
                          subtitle: Container(
                            height: 15,
                            // color: AppColors().black27,
                            child: textSemiBold(
                                text: chatRoom.lastMessage.toString() != ""
                                    ? chatRoom.lastMessage.toString()
                                    : "Say Hi ! Your New Friend",
                                textOverflow: TextOverflow.ellipsis,
                                fontSize: 14,
                                topPadding: 0,
                                leftPadding: 2),
                          ),
                          trailing: Column(
                            children: [
                              textRegular(
                                  text: "$date-$month-$year", fontSize: 12),
                              textSemiBold(
                                  text: targetUser.status.toString(),
                                  fontSize: 10,
                                  topPadding: 0,
                                  fontColor: targetUser.status == "Online"
                                      ? AppColors().greenCode
                                      : AppColors().redCode),
                            ],
                          ),
                        );
                      } else {
                        return textRegular(text: "Waiting.....", fontSize: 14);
                      }
                    } else {
                      return Container();
                    }
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Container();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }


  Widget floatingButton() {
    return FloatingActionButton(
      backgroundColor: AppColors().orangeCode,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchPage(
                userModel: widget.userModel, fireBaseUser: widget.firebaseUser),
          ),
        );
      },
      child: const Icon(Icons.search),
    );
  }

  Widget signOutConst() {
    return IconButton(
      onPressed: () {
        popupMenuButtonConst();
      },
      icon: const Icon(Icons.more_vert_rounded),
    );
  }

  Widget popupMenuButtonConst() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'Profile') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(
                  userModel: widget.userModel,
                  firebaseUSer: widget.firebaseUser,
                  isEditPage: true),
            ),
          );
        } else if (value == 'signOut') {
          // Perform sign out action
          AlertBox().showDiaLog(context, okOnTap: () {
            auth.signOut();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ));
          }, subTitle: "Are you want to sign out?", okTitle: "Sign out");
        } else if (value == "Exit") {
          AlertBox().showDiaLog(context, subTitle: "Are you want to exit?",
              okOnTap: () {
            exit(0);
          }, okTitle: "Exit");
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'Profile',
          child: textRegular(
              text: "Profile",
              fontSize: 14,
              topPadding: 0,
              bottomPadding: 0,
              rightPadding: 0),
        ),
        PopupMenuItem<String>(
          value: 'signOut',
          child: textRegular(
              text: "Sign Out",
              fontSize: 14,
              topPadding: 0,
              bottomPadding: 0,
              rightPadding: 0),
        ),
        PopupMenuItem<String>(
            value: 'Exit',
            child: Row(
              children: [
                Icon(
                  Icons.exit_to_app_rounded,
                  color: AppColors().black27,
                  size: 18,
                ),
                textRegular(
                    text: "Exit",
                    fontSize: 14,
                    topPadding: 0,
                    bottomPadding: 0,
                    rightPadding: 0),
              ],
            )),
      ],
    );
  }
}
