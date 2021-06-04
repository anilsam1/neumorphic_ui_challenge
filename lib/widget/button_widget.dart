import 'package:flutter/material.dart';
import 'package:flutter_demo_structure/values/export.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  String label;
  VoidCallback callback;
  double? elevation;
  double? height;
  double? radius;
  double? padding;
  bool buttonColor;

  AppButton(this.label, this.callback,
      {double elevation = 0.0, this.height, this.radius, this.padding, this.buttonColor = false}) {
    this.elevation = elevation;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60.h,
      child: MaterialButton(
        elevation: this.elevation,
        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
        onPressed: callback,
        child: Text(
          label,
          style: textMedium.copyWith(color: AppColor.primaryColor, fontSize: 16.sp),
        ),
        color: buttonColor ? AppColor.white : AppColor.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColor.primaryColor, width: 2.w),
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
        ),
      ),
    );
  }
}
