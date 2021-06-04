import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demo_structure/core/db/app_db.dart';
import 'package:flutter_demo_structure/core/di/api/req_params.dart' as Req;
import 'package:flutter_demo_structure/core/di/api/response/api_base/api_base.dart';
import 'package:flutter_demo_structure/core/navigation/navigation_service.dart';
import 'package:flutter_demo_structure/core/navigation/routes.dart';
import 'package:flutter_demo_structure/res.dart';
import 'package:flutter_demo_structure/ui/auth/login/store/login_store.dart';
import 'package:flutter_demo_structure/values/colors.dart';
import 'package:flutter_demo_structure/values/export.dart';
import 'package:flutter_demo_structure/values/string_constants.dart';
import 'package:flutter_demo_structure/widget/app_utils.dart';
import 'package:flutter_demo_structure/widget/button_widget_inverse.dart';
import 'package:flutter_demo_structure/widget/loading.dart';
import 'package:flutter_demo_structure/widget/text_form_filed.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobx/mobx.dart';

import 'sign_up_widget.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isHidden = true;
  late GlobalKey<FormState> _formKey;
  late TextEditingController emailController, passwordController;
  late FocusNode emailNode, passwordNode;

  ValueNotifier<bool> showLoading = ValueNotifier<bool>(false);
  var socialId, type = "S";
  List<ReactionDisposer>? _disposers;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    emailNode = FocusNode();
    passwordNode = FocusNode();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailNode.dispose();
    passwordNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    addDisposer();
  }

  addDisposer() {
    debugPrint("Add reaction");
    _disposers ??= [
      // success reaction
      reaction((_) => authStore.loginResponse, (SingleResponse response) {
        showLoading.value = false;

        debugPrint("ONResponse Login: called $response");
        if (response.code == "1") {
          navigator.pushNamedAndRemoveUntil(RouteName.homePage);
          appDB.isLogin = true;
          //showMessage(response.message, type: MessageType.INFO);
        }
      }),
      // error reaction
      reaction((_) => authStore.errorMessage, (String? errorMessage) {
        showLoading.value = false;
        debugPrint("OnError Callled");
        if (errorMessage != null) {
          showMessage(errorMessage.toString(), type: MessageType.INFO);
        }
      }),
    ];
    debugPrint(_disposers!.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: 1.sw,
          height: 1.sh,
          child: SingleChildScrollView(
            child: ValueListenableBuilder(
              valueListenable: showLoading,
              builder: (context, bool value, child) => Loading(
                status: value,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    30.0.VBox,
                    getHeaderContent(),
                    getSignInForm(),
                    30.0.VBox,
                    SignUpWidget(
                      fromLogin: true,
                      onTap: () => navigator
                          .pushNamed(RouteName.signUpPage)
                          .then((value) => _formKey.currentState!.reset()),
                    ),
                    40.0.VBox,
                  ],
                ).wrapPadding(
                  padding: EdgeInsets.only(top: 0.h, left: 30.w, right: 30.w),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getHeaderContent() {
    return Column(
      children: [
        FlutterLogo(
          size: 0.15.sh,
        ),
        10.0.VBox,
        Text(
          StringConstant.welcomeBack.toUpperCase(),
          style: textBold.copyWith(
            color: AppColor.primaryColor,
            fontSize: 28.sp,
          ),
        ),
      ],
    );
  }

  Widget getSignInForm() {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            25.0.VBox,
            AppTextField(
              controller: emailController,
              label: StringConstant.email,
              hint: StringConstant.email,
              keyboardType: TextInputType.emailAddress,
              validators: emailValidator,
              focusNode: emailNode,
              prefixIcon: IconButton(
                onPressed: null,
                icon: Image.asset(
                  Res.email,
                  color: AppColor.primaryColor,
                  height: 26.0,
                  width: 26.0,
                ),
              ),
            ).wrapPaddingHorizontal(20),
            10.0.VBox,
            AppTextField(
              label: StringConstant.password,
              hint: StringConstant.password,
              obscureText: _isHidden,
              validators: passwordValidator,
              controller: passwordController,
              focusNode: passwordNode,
              keyboardType: TextInputType.visiblePassword,
              keyboardAction: TextInputAction.done,
              maxLines: 1,
              maxLength: 15,
              suffixIcon: Align(
                alignment: Alignment.centerRight,
                heightFactor: 1.0,
                widthFactor: 1.0,
                child: Text(
                  StringConstant.forgot,
                  style: textMedium.copyWith(
                    color: AppColor.brownColor,
                    fontSize: 14.0.sp,
                  ),
                ).wrapPaddingAll(12.0).addGestureTap(() => {
                      Future.delayed(Duration.zero, () {
                        passwordNode.unfocus();
                      }),
                    }),
              ),
              prefixIcon: IconButton(
                onPressed: null,
                icon: Image.asset(
                  Res.password,
                  color: AppColor.primaryColor,
                  height: 26.0,
                  width: 26.0,
                ),
              ),
            ).wrapPaddingHorizontal(20),
            16.0.VBox,
            AppButtonInverse(
              StringConstant.logIn.toUpperCase(),
              () {
                if (_formKey.currentState!.validate()) {
                  loginAndNavigateToHome();
                }
              },
              elevation: 0.0,
            ).wrapPaddingHorizontal(20),
          ],
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  loginAndNavigateToHome() async {
    var req = Map.of({
      Req.email: emailController.text.trim(),
      'latitude': emailController.text.trim(),
      'longitude': emailController.text.trim(),
      Req.deviceToken: appDB.fcmToken,
      Req.ip: "ipAddress",
      Req.loginType: type,
      Req.deviceType: "A",
      Req.deviceModel: 'info.model',
      Req.uuid: 'info.androidId',
    });
    if (type == "S") {
      req[Req.password] = passwordController.value.text;
    }
    showLoading.value = true;
    authStore.login(req);
  }

  removeDisposer() {
    _disposers!.forEach((element) {
      element.reaction.dispose();
    });
  }
}
