import 'package:flutter/material.dart';
import 'package:flutter_demo_structure/res.dart';
import 'package:flutter_demo_structure/values/export.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBarWidget extends StatefulWidget {
  final Widget? actionMenu;
  final double paddingStart;
  final Color backgroundColor;

  const AppBarWidget({
    this.actionMenu,
    this.paddingStart = 10.0,
    this.backgroundColor = AppColor.white,
    super.key,
  });

  @override
  _AppBarWidgetState createState() => _AppBarWidgetState();
}

var paddingTop = (kToolbarHeight - 20).toDouble();

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      padding: EdgeInsets.only(top: paddingTop),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Image.asset(
              Res.back,
              height: 20.h,
              width: 80.w,
            ),
          ),
          const Spacer(),
          widget.actionMenu ?? Container()
        ],
      ),
    );
  }
}
