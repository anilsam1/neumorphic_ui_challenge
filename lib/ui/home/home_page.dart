import 'package:flutter/material.dart';
import 'package:flutter_demo_structure/core/db/app_db.dart';
import 'package:flutter_demo_structure/core/navigation/navigation_service.dart';
import 'package:flutter_demo_structure/core/navigation/routes.dart';
import 'package:flutter_demo_structure/values/export.dart';
import 'package:flutter_demo_structure/values/string_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueNotifier showLoading = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                StringConstant.home,
                style: textBold.copyWith(fontSize: 30.sp),
              ),
              25.0.VBox,
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
          ),
        ),
      ),
    );
  }
}
