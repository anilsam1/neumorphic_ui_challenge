import 'package:json_annotation/json_annotation.dart';

import 'package:flutter_demo_structure/core/di/api/response/base/base_response.dart';

part 'common_response.g.dart';

@JsonSerializable(explicitToJson: true)
class CommonResponse<T> extends BaseResponse<T> {
  CommonResponse({data, message, code});
  factory CommonResponse.fromJson(Map<String, dynamic> json,
          {Function()? fromJson}) =>
      CommonResponse<T>().parseJson(json, fromJson);

  @override
  get data {
    return data as T;
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'message': message,
        'code': code,
        'data': data,
      };
}
