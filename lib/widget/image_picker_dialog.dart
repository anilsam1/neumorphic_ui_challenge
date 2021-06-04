import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_demo_structure/values/export.dart';
import 'package:flutter_demo_structure/values/string_constants.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerDialog extends StatelessWidget {
  ImagePickerHandler listener;
  AnimationController controller;
  late BuildContext context;

  ImagePickerDialog(this.listener, this.controller);

  late Animation<double> _drawerContentsOpacity;
  late Animation<Offset> _drawerDetailsPosition;

  void initState() {
    _drawerContentsOpacity = CurvedAnimation(
      parent: ReverseAnimation(controller),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsPosition = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
    ));
  }

  getImage(BuildContext context) {
    controller.forward();
    showDialog(
      context: context,
      builder: (BuildContext context) => SlideTransition(
        position: _drawerDetailsPosition,
        child: FadeTransition(
          opacity: ReverseAnimation(_drawerContentsOpacity),
          child: this,
        ),
      ),
    );
  }

  void dispose() {
    controller.dispose();
  }

  startTime() async {
    var _duration = Duration(milliseconds: 200);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pop(context);
  }

  dismissDialog() {
    controller.reverse();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Material(
        type: MaterialType.transparency,
        child: Opacity(
          opacity: 1.0,
          child: Container(
            padding: EdgeInsets.only(left: 30, top: 0.0, right: 30, bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: () => listener.openCamera(),
                  child: roundedButton(
                    StringConstant.camera,
                    EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    AppColor.primaryColor,
                    AppColor.white,
                  ),
                ),
                GestureDetector(
                  onTap: () => listener.openGallery(),
                  child: roundedButton(
                      StringConstant.gallery,
                      EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      AppColor.primaryColor,
                      AppColor.white),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () => dismissDialog(),
                  child: Padding(
                    padding: EdgeInsets.only(left: 30, top: 0.0, right: 30, bottom: 20),
                    child: roundedButton(
                        StringConstant.cancel,
                        EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                        AppColor.primaryColor,
                        AppColor.white),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget roundedButton(String buttonLabel, EdgeInsets margin, Color bgColor, Color textColor) {
    var loginBtn = Container(
      width: MediaQuery.of(context).size.width,
      margin: margin,
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.all(const Radius.circular(100.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColor.primaryColor.withOpacity(0.5),
            offset: Offset(0.5, 2.0),
            blurRadius: 0.001,
          ),
        ],
      ),
      child: Text(
        buttonLabel,
        style: textBold.copyWith(color: textColor),
      ),
    );
    return loginBtn;
  }
}

class ImagePickerHandler {
  late ImagePickerDialog imagePicker;
  late AnimationController _controller;
  late ImagePickerListener _listener;

  ImagePickerHandler(this._listener, this._controller);

  openCamera() async {
    imagePicker.dismissDialog();
    PickedFile? image =
        await ImagePicker().getImage(source: ImageSource.camera, maxHeight: 800, maxWidth: 600);
    _listener.userImage(File(image!.path));
  }

  openGallery() async {
    imagePicker.dismissDialog();
    PickedFile? image =
        await ImagePicker().getImage(source: ImageSource.gallery, maxHeight: 800, maxWidth: 600);
    _listener.userImage(File(image!.path));
  }

  void init() {
    imagePicker = ImagePickerDialog(this, _controller);
    imagePicker.initState();
  }

  showDialog(BuildContext context) {
    imagePicker.getImage(context);
  }
}

abstract class ImagePickerListener {
  userImage(File _image);
}
