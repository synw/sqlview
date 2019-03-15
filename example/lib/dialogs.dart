import 'package:flutter/material.dart';
import 'conf.dart';

addDialog(BuildContext context) {
  final controller = TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Add item"),
        actions: <Widget>[
          FlatButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: const Text("Save"),
            onPressed: () async {
              Navigator.of(context).pop();
              db.insert(
                  table: "item",
                  row: {"name": controller.text}).catchError((e) {
                throw (e);
              });
            },
          ),
        ],
        content: TextField(
          controller: controller,
          autofocus: true,
        ),
      );
    },
  );
}

updateDialog(BuildContext context, Map<String, dynamic> item) {
  final controller = TextEditingController(text: item["name"]);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Update category"),
        content: TextField(
          controller: controller,
          autofocus: true,
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          FlatButton(
            child: const Text("Save"),
            onPressed: () {
              Navigator.of(context).pop(true);
              db
                  .update(
                      table: "item",
                      row: {"name": controller.text},
                      where: 'id=${item["id"]}')
                  .catchError((e) {
                throw (e);
              });
              ;
            },
          ),
        ],
      );
    },
  );
}
