import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogUtils {
  static void showCustomDialog({
    BuildContext context,
    String title,
    String content = null,
    String ok,
    String cancel,
    Function onAgree,
    Function onCancel,
    Widget child = null,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: new Text(title),
        content: child ?? new Text(content),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(ok),
            onPressed: onAgree,
          ),
          CupertinoDialogAction(
            child: Text(cancel),
            isDestructiveAction: true,
            onPressed: onCancel,
          )
        ],
      ),
    );
  }
}
