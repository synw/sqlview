# Sqlview

Crud page widget for Sqlite and Flutter using [Sqlcool](https://github.com/synw/sqlcool)

## Example

   ```dart
import 'package:flutter/material.dart';
import 'package:sqlcool/sqlcool.dart';
import 'sqlview.dart';

class _MyCrudPageState extends State<MyCrudPage> {

  final SelectBloc bloc = SelectBloc(
          table: "mytable",
          columns: "id,name",
          where: 'name LIKE "%joe%"',
          orderBy: 'name ASC',
          reactive: true,
          verbose: true,
        );

  @override
  Widget build(BuildContext context) {
    return Stack(
    children: <Widget>[
        CrudView(
          bloc: bloc,
          updateItemAction: update, 
          deleteItemAction: delete,
          trailing: (_context, _item) {
            return IconButton(
                icon: Icons.location_off,
                onPressed: () => print("$_item"),
              }
          ),
        ),
        Positioned(
            right: 15.0,
            bottom: 15.0,
            child: FloatingActionButton(
              heroTag: "actionBtn",
              child: Icon(Icons.add),
              onPressed: () => add(context),
            )),
      ],
    );
  }
}

add(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
        return AlertDialog(
            // ...
            // Save using the Sqlcool database
            // Map<String, String> row = {"name": "value"};
            // db.add(table: "mytable", row: row);
            );
        }
    );
}

update(BuildContext context, Map<String, dynamic> item) {
    // item is the json record
    showDialog(
        context: context,
        builder: (BuildContext context) {
        return AlertDialog(
            // ...
            // Update using the Sqlcool database
            // Map<String, String> row = {"name": "value"};
            // db.update(table: "mytable", row: row, where: 'id=${item["id"]}');
            );
    );
}

delete(BuildContext context, Map<String, dynamic> item) {
    // item is the json record
    showDialog(
        context: context,
        builder: (BuildContext context) {
        return AlertDialog(
            // ...
            // delete using the Sqlcool database
            // db.delete(table: "mytable", where: 'id=${item["id"]}');
            );
        }
    );
}

class MyCrudPage extends StatefulWidget {
  @override
  _MyCrudPageState createState() => _MyCrudPageState();
}
   ```
