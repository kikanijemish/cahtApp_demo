import 'dart:io';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_1/model/user_model.dart';
import 'package:task_1/ui/const/teaxt_form_field_const.dart';
import 'package:task_1/ui/utils/text_const.dart';

import '../../const/long_button_const.dart';
import '../../utils/app_color.dart';
import '../alert_page/home_page/home_page.dart';

class ProfilePage extends StatefulWidget {
  UserModel userModel;
  User firebaseUSer;
  bool? isEditPage;

  ProfilePage({Key? key, required this.userModel, required this.firebaseUSer,this.isEditPage})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController();

  File? image;
  String pickerImage = "";
  bool setEditImage=false;

  Future pickImage(ImageSource picImage) async {
    try {
      XFile? PickImage = await ImagePicker().pickImage(source: picImage);
      if (PickImage != null) {
        cropImage(PickImage);
      } else {
        image = null;
      }
    } on PlatformException catch (e) {
      Get.snackbar("Exception", e.toString());
    }
  }

  void cropImage(XFile file) async {
   CroppedFile? croppedImage= await ImageCropper().cropImage(sourcePath: file.path,aspectRatio:const CropAspectRatio(ratioX: 1, ratioY:1),compressQuality: 20);
    if (croppedImage != null) {
      setState(
        () {
          pickerImage = croppedImage.path;
          setEditImage=true;
        },
      );

    }
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    editProfile();
  }
  editProfile(){

    if(widget.isEditPage==true){

      pickerImage=widget.userModel.profilePic.toString();
      nameController.text=widget.userModel.fullName.toString();
      log("image are ${pickerImage}");
      log("gfdsjhgfsjhgfjfi");


    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors().orangeCode,
            title: textBold(text: "Profile Details", fontSize: 16),
          ),
          body: bodyData()),
    );
  }

  Widget bodyData() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          profilePicConst(),
          userNameConst(),
          submitButtonConst(),
        ],
      ),
    );
  }

  Widget profilePicConst() {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: InkWell(
        onTap: () {
          bottomSheetConst();
        },
        child:widget.isEditPage==true && setEditImage==false?CircleAvatar(
          backgroundImage:  pickerImage != ""  ?NetworkImage(widget.userModel.profilePic.toString()): null,
          radius: 35,
        ):CircleAvatar(
          backgroundImage:  pickerImage != ""  ? FileImage(File(pickerImage)) : null,
          radius: 35,
          child: pickerImage == ""
              ? const Icon(
                  CupertinoIcons.profile_circled,
                  size: 25,
                )
              : null,
        ),
      ),
    );
  }

  Widget userNameConst() {
    return TextFormFieldConst(
      hintText: "Full Name",
      controller: nameController,
    );
  }

  Widget submitButtonConst() {
    return LongButtonConst(
      topPadding: 40,
      colors: AppColors().orangeCode,
      child:
          textBold(text: "Submit".toUpperCase(), fontSize: 14, topPadding: 0),
      onTap: () {
        submitValidation();
      },
    );
  }

  bottomSheetConst() {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 140,
          decoration: BoxDecoration(
            color: AppColors().white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 9,
              ),
              ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.photo),
                ),
                title: textMedium(text: "gallery", fontSize: 14),
                subtitle: Divider(color: AppColors().black27),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.camera_alt)),
                title: textMedium(text: "camera", fontSize: 14),
                subtitle: Divider(color: AppColors().black27),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  submitValidation() {
    if (pickerImage == null) {
      Get.snackbar("Hey", "select The image ");
    } else if (nameController.text.trim() == "") {
      Get.snackbar("Hey", "Enter the Name");
    } else {
      uploadImage();
    }
  }

  void uploadImage() async {

    UploadTask uploadTask = FirebaseStorage.instance
        .ref("profilePicture")
        .child(widget.userModel.uid!)
        .putFile(File(pickerImage));
    TaskSnapshot snapshot = await uploadTask;
    String imageUrl = await snapshot.ref.getDownloadURL();
    String fullName = nameController.text.trim();

    widget.userModel.fullName = fullName;
    widget.userModel.profilePic = imageUrl;

      widget.isEditPage==true?
      await FirebaseFirestore.instance
          .collection("User")
          .doc(widget.userModel.uid)
          .update({"fullName":nameController.text.toString(),"profilePic":imageUrl})
          .then((value) {
        Get.snackbar("Hey", "Profile update successfully");
        Navigator.popUntil(context, (route) => route.isFirst);

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(userModel: widget.userModel,firebaseUser: widget.firebaseUSer),),);
      },)

          :
      await FirebaseFirestore.instance
        .collection("User")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap())
        .then((value) {
      Get.snackbar("Hey", "image upload successfully");
      Navigator.popUntil(context, (route) => route.isFirst);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(userModel: widget.userModel,firebaseUser: widget.firebaseUSer),),);
    });

    setEditImage=false;
  }
}
