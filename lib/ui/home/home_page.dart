import 'dart:io';

import 'package:catcher/catcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_structure/core/db/app_db.dart';
import 'package:flutter_demo_structure/core/navigation/navigation_service.dart';
import 'package:flutter_demo_structure/core/navigation/routes.dart';
import 'package:flutter_demo_structure/util/media_picker.dart';
import 'package:flutter_demo_structure/util/permission_utils.dart';
import 'package:flutter_demo_structure/util/utils.dart';
import 'package:flutter_demo_structure/values/export.dart';
import 'package:flutter_demo_structure/values/string_constants.dart';
import 'package:flutter_demo_structure/widget/image_picker_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:images_picker/images_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin, MediaPickerListener {
  ValueNotifier showLoading = ValueNotifier<bool>(false);
  var style = TextButton.styleFrom(minimumSize: Size(double.maxFinite, 20));
  int? count;
  List<Media?>? pickedFilesList;
  List<PlatformFile>? pickedDocuments;
  FilesType? type;

  late MediaPickerHandler _mediaPickerHandler;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _mediaPickerHandler = MediaPickerHandler(this, _controller);
    _mediaPickerHandler.init();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                StringConstant.home,
                style: textBold.copyWith(fontSize: 30.sp),
              ),
              25.0.VBox,
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (count != null)
                    Text(
                      "Picked file count: $count",
                      style: textBold,
                    ),
                  10.0.VBox,
                  if (pickedFilesList != null)
                    Wrap(
                        direction: Axis.horizontal,
                        children: pickedFilesList!
                            .map(
                              (e) => e != null
                                  ? Image.file(
                                      File(e.thumbPath!),
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : SizedBox.shrink(),
                            )
                            .toList()),
                  if (pickedDocuments != null && type == FilesType.Audio ||
                      type == FilesType.Documents)
                    Wrap(
                        direction: Axis.horizontal,
                        children: pickedDocuments!
                            .map(
                              (e) => Image.file(
                                File(e.path!),
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                            .toList())
                ],
              ),
              25.0.VBox,
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => pickFile(FilesType.Image),
                          child: Text(StringConstant.pickImage),
                          style: style,
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () => pickFile(FilesType.Video),
                          child: Text(StringConstant.pickVideo),
                          style: style,
                        ),
                      ),
                    ],
                  ),
                  10.0.VBox,
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => pickFile(FilesType.Documents),
                          child: Text(StringConstant.pickDocuments),
                          style: style,
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () => pickFile(FilesType.Audio),
                          child: Text(StringConstant.pickAudio),
                          style: style,
                        ),
                      ),
                    ],
                  ),
                  20.0.VBox,
                  TextButton(
                    onPressed: () => Catcher.sendTestException(),
                    child: Text(
                      StringConstant.sendException,
                      textAlign: TextAlign.center,
                      style: textBold,
                    ),
                    style: style,
                  ),
                ],
              ),
              25.0.VBox,
              Column(
                children: [
                  TextButton(
                    child: Text('Photo Permission'),
                    onPressed: () async {
                      await PhotosPermission().request(
                        onPermanentlyDenied: () => Utils.showMessage(
                            'Permission denied always user need to allow manually'),
                        onGranted: () => Utils.showMessage('User Allowed to access photos'),
                        onPermissionDenied: () => Utils.showMessage('User Denied to access photos'),
                      );
                    },
                  )
                ],
              ),
              TextButton(
                onPressed: () {
                  appDB.logout();
                  navigator.pushNamedAndRemoveUntil(RouteName.loginPage);
                },
                child: Text(
                  StringConstant.logout,
                  style: textBold,
                ),
                style: TextButton.styleFrom(backgroundColor: Colors.grey),
              )
            ],
          ).wrapPaddingHorizontal(20.0),
        ),
      ),
    );
  }

  Future<void> pickFile(FilesType type) async {
    setState(() {
      pickedFilesList = null;
      pickedDocuments = null;
      this.type = null;
    });
    switch (type) {
      case FilesType.Image:
        pickedFilesList = _mediaPickerHandler.showDialog(
          context,
          PickFileType.IMAGE,
          maxPickFileCount: 5,
          cropOption: CropOption(aspectRatio: CropAspectRatio.wh16x9),
        );
        break;
      case FilesType.Video:
        pickedFilesList = _mediaPickerHandler.showDialog(
          context,
          PickFileType.VIDEO,
          maxPickFileCount: 5,
        );
        break;
      case FilesType.Documents:
        pickedDocuments = await MediaPicker.pickDocument(fileType: FileType.any);
        break;
      case FilesType.Audio:
        pickedDocuments =
            await MediaPicker.pickDocument(fileType: FileType.audio, allowMultiple: true);
        break;
    }
    if (pickedFilesList != null) {
      if (mounted) setState(() => count = pickedFilesList!.length);
    }
    if (pickedDocuments != null) {
      if (mounted) setState(() => count = pickedDocuments!.length);
    }
  }

  @override
  pickedFiles(List<Media?>? _pickedFilesList, PickFileType _pickFileType) {
    print('Requested Media type $_pickFileType');
    if (_pickedFilesList != null) {
      if (mounted)
        setState(() => {
              count = _pickedFilesList.length,
              pickedFilesList = _pickedFilesList,
            });
    }
  }
}

/// this enum only for identify pick type in real case we can directly call media picker
enum FilesType { Image, Video, Documents, Audio }
