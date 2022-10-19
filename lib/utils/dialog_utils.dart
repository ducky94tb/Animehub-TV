import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogUtils {
  static void showCustomDialog({
    BuildContext context,
    String title,
    String content,
    String ok,
    String cancel,
    Function onAgree,
    Function onCancel,
    Widget child,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: child ??
              Text(
                content,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.left,
              ),
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(ok),
            onPressed: onAgree,
          ),
          CupertinoDialogAction(
            child: Text(cancel),
            onPressed: onCancel,
          )
        ],
      ),
    );
  }
}
