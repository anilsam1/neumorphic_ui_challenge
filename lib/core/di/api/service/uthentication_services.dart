import 'package:flutter_demo_structure/core/locator.dart';
import 'package:flutter_demo_structure/core/di/api/http_client.dart';

class UserAuthService {
  final client = locator<HttpClient>();
}
