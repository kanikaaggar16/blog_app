import 'package:flutter/material.dart';

class Dialogbox
{
  information(BuildContext context,String title,String description)
  {
    return showDialogbox(
      context : context,
      barrierDismissible : true,
      builder: (BuildContext context)
        {
          return AlertDialog
            (
              title: Text(title),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(description)
                  ],
                ),
              ),
            actions: <Widget>[
              FlatButton(
                child: Text("Ok"),
                onPressed: ()
                {
                  return Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }
}

showDialogbox({BuildContext context, bool barrierDismissible, AlertDialog Function(BuildContext context) builder}) {
}