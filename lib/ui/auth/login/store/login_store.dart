import 'package:flutter/material.dart';
import 'package:flutter_demo_structure/core/api/base_response/base_response.dart';
import 'package:flutter_demo_structure/core/exceptions/app_exceptions.dart';
import 'package:flutter_demo_structure/data/model/request/login_request_model.dart';
import 'package:flutter_demo_structure/data/model/response/user_profile_response.dart';
import 'package:mobx/mobx.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStoreBase with _$LoginStore;

abstract class _LoginStoreBase with Store {
  @observable
  BaseResponse<UserData>? loginResponse;

  @observable
  String? errorMessage;

  _LoginStoreBase();

  @action
  Future login(LoginRequestModel data) async {
    try {
      errorMessage = null;
      /*  var commonStoreFuture =
          ObservableFuture<SingleResponse>(authRepo.signIn(data));
      loginResponse = await commonStoreFuture;*/

      await Future.delayed(const Duration(seconds: 5), () {});
      loginResponse = BaseResponse(message: "Success", code: "1");
    } on AppException catch (e) {
      errorMessage = e.toString();
    } catch (e, st) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: st);
      errorMessage = e.toString();
    }
  }
}
