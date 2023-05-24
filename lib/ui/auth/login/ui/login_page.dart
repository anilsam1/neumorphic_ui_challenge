import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_structure/core/db/app_db.dart';
import 'package:flutter_demo_structure/core/di/api/req_params.dart' as Req;
import 'package:flutter_demo_structure/core/di/api/response/api_base/api_base.dart';
import 'package:flutter_demo_structure/core/locator.dart';
import 'package:flutter_demo_structure/generated/l10n.dart';
import 'package:flutter_demo_structure/res.dart';
import 'package:flutter_demo_structure/router/app_router.dart';
import 'package:flutter_demo_structure/ui/auth/login/widget/sign_up_widget.dart';
import 'package:flutter_demo_structure/ui/auth/login/store/login_store.dart';
import 'package:flutter_demo_structure/values/export.dart';
import 'package:flutter_demo_structure/widget/button_widget_inverse.dart';
import 'package:flutter_demo_structure/widget/text_form_filed.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobx/mobx.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isHidden = true;
  late GlobalKey<FormState> _formKey;
  late TextEditingController emailController, passwordController;
  late FocusNode emailNode, passwordNode;
  late ValueNotifier<bool> showLoading;
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
    showLoading = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailNode.dispose();
    passwordNode.dispose();
    showLoading.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // addDisposer();
  }

  /// Login Api call

/*  void addDisposer() {
    _disposers ??= [
      // success reaction
      reaction((_) => authStore.loginResponse, (SingleResponse response) {
        showLoading.value = false;

        debugPrint("ONResponse Login: called $response");
        if (response.code == "1") {
          locator<AppRouter>().replaceAll([const HomeRoute()]);
          appDB.isLogin = true;
          //showMessage(response.message, type: MessageType.INFO);
        }
      }),
      // error reaction
      reaction((_) => authStore.errorMessage, (String? errorMessage) {
        showLoading.value = false;
        if (errorMessage != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(errorMessage)));
        }
      }),
    ];
  }*/

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                30.0.verticalSpace,
                getHeaderContent(),
                getSignInForm(),
                30.0.verticalSpace,
                SignUpWidget(
                  fromLogin: true,
                  onTap: () => locator<AppRouter>()
                      .push(const SignUpRoute())
                      .then((value) => _formKey.currentState?.reset()),
                ),
                40.0.verticalSpace,
              ],
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
        10.0.verticalSpace,
        Text(
          S.current.welcomeBack.toUpperCase(),
          style: textBold.copyWith(
            color: AppColor.primaryColor,
            fontSize: 28.spMin,
          ),
        ),
      ],
    );
  }

  Widget getSignInForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          25.0.verticalSpace,
          AppTextField(
            controller: emailController,
            label: S.current.email,
            hint: S.current.email,
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
          ),
          10.0.verticalSpace,
          AppTextField(
            label: S.current.password,
            hint: S.current.password,
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
              child: GestureDetector(
                onTap: () => Future.delayed(Duration.zero, () {
                  passwordNode.unfocus();
                }),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    S.current.forgot,
                    style: textMedium.copyWith(
                      color: AppColor.brownColor,
                      fontSize: 14.0.spMin,
                    ),
                  ),
                ),
              ),
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
          ),
          16.0.verticalSpace,
          AppButtonInverse(
            S.current.logIn.toUpperCase(),
            () {
              if (_formKey.currentState?.validate() ?? false) {
                locator<AppRouter>().replaceAll([const HomeRoute()]);
                appDB.isLogin = true;

                // loginAndNavigateToHome();
              }
            },
            elevation: 0.0,
          ),
        ],
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

  void removeDisposer() {
    for (var element in _disposers!) {
      element.reaction.dispose();
    }
  }
}
