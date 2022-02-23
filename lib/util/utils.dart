import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_structure/core/navigation/navigation_service.dart';
import 'package:flutter_demo_structure/values/export.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

enum MessageType { INFO, ERROR, WARNING }

class Utils {
  static Flushbar? _flushBar;

  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }

  static void launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static void shareText(String title, String desc) {
    Share.share(desc, subject: title);
  }

  static showMessage(
    String message, {
    MessageType type = MessageType.INFO,
  }) {
    debugPrint("ShowMessage: $message");

    try {
      if (_flushBar != null) _flushBar!.dismiss();
      _flushBar = Flushbar(
        messageText: Text(
          message,
          style: textBold.copyWith(color: AppColor.white),
        ),
        animationDuration: Duration.zero,
        backgroundColor: AppColor.primaryColor,
        duration: Duration(seconds: 3),
        boxShadows: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
      )..show(NavigationService.navigatorKey.currentContext!);
    } catch (onError) {
      debugPrint(onError.toString());
    }
  }
}
