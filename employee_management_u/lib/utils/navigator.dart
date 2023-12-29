import 'package:flutter/material.dart';

navigateTo(BuildContext context, Widget destination) {
  try {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => destination,
        ));
  } catch (e) {
    print("==================== Error while navigating : $e");
  }
}

removeAllAndPush(BuildContext context, Widget destination) {
  try {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => destination),
      (route) => false,
    );
  } catch (e) {
    print("==================== Error while navigating : $e");
  }
}
