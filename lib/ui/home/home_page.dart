import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_structure/core/db/app_db.dart';
import 'package:flutter_demo_structure/core/locator.dart';
import 'package:flutter_demo_structure/generated/l10n.dart';
import 'package:flutter_demo_structure/router/app_router.dart';
import 'package:flutter_demo_structure/util/media_picker.dart';
import 'package:flutter_demo_structure/util/permission_utils.dart';
import 'package:flutter_demo_structure/values/export.dart';
import 'package:flutter_demo_structure/widget/image_picker_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:images_picker/images_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, MediaPickerListener {
  ValueNotifier showLoading = ValueNotifier<bool>(false);
  var style =
      TextButton.styleFrom(minimumSize: const Size(double.maxFinite, 20));
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
                S.current.home,
                style: textBold.copyWith(fontSize: 30.sp),
              ),
              25.0.verticalSpace,
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (count != null)
                    Text(
                      "Picked file count: $count",
                      style: textBold,
                    ),
                  10.0.verticalSpace,
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
                                  : const SizedBox.shrink(),
                            )
                            .toList()),
                  if (pickedDocuments != null && type == FilesType.audio ||
                      type == FilesType.documents)
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
                          .toList(),
                    )
                ],
              ),
              25.0.verticalSpace,
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => pickFile(FilesType.image),
                          style: style,
                          child: Text(S.current.pickImage),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () => pickFile(FilesType.video),
                          style: style,
                          child: Text(S.current.pickVideo),
                        ),
                      ),
                    ],
                  ),
                  10.0.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => pickFile(FilesType.documents),
                          style: style,
                          child: Text(S.current.pickDocuments),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () => pickFile(FilesType.audio),
                          style: style,
                          child: Text(S.current.pickAudio),
                        ),
                      ),
                    ],
                  ),
                  20.0.verticalSpace,
                ],
              ),
              25.0.verticalSpace,
              Column(
                children: [
                  TextButton(
                    child: const Text('Photo Permission'),
                    onPressed: () async {
                      await PhotosPermission().request(
                        onPermanentlyDenied: () =>
                            ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Permission denied always user need to allow manually'),
                          ),
                        ),
                        onGranted: () =>
                            ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('User Allowed to access photos'),
                          ),
                        ),
                        onPermissionDenied: () =>
                            ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('User Denied to access photos'),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
              TextButton(
                onPressed: () {
                  appDB.logout();
                  locator<AppRouter>().replaceAll([const LoginRoute()]);
                },
                style: TextButton.styleFrom(backgroundColor: Colors.grey),
                child: Text(
                  S.current.logout,
                  style: textBold,
                ),
              )
            ],
          ),
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
      case FilesType.image:
        pickedFilesList = _mediaPickerHandler.showDialog(
          context,
          PickFileType.image,
          maxPickFileCount: 5,
          cropOption: CropOption(aspectRatio: CropAspectRatio.wh16x9),
        );
        break;
      case FilesType.video:
        pickedFilesList = _mediaPickerHandler.showDialog(
          context,
          PickFileType.video,
          maxPickFileCount: 5,
        );
        break;
      case FilesType.documents:
        pickedDocuments =
            await MediaPicker.pickDocument(fileType: FileType.any);
        break;
      case FilesType.audio:
        pickedDocuments = await MediaPicker.pickDocument(
            fileType: FileType.audio, allowMultiple: true);
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
  pickedFiles(List<Media?>? pickedFilesList, PickFileType pickFileType) {
    debugPrint('Requested Media type $pickFileType');
    if (pickedFilesList != null) {
      if (mounted) {
        setState(() => {
              count = pickedFilesList?.length,
              pickedFilesList = pickedFilesList,
            });
      }
    }
  }
}

/// this enum only for identify pick type in real case we can directly call media picker
enum FilesType { image, video, documents, audio }
