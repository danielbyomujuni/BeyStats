import 'package:flutter/material.dart';

class Alert {
  Future<void> confirmDialog(BuildContext context,
      {required String title,
      required String description,
      required void Function() onSuccess,
      void Function()? onCancel}) async {
        return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(description),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                onSuccess();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                if (onCancel != null) {onCancel();}
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );


      }

  Future<void> showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sorry'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This functionality is not implemented yet'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
