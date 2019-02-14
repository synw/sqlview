# Sqlview

Crud page widget for Sqlite and Flutter using [Sqlcool](https://github.com/synw/sqlcool)

## Example

   ```dart
import 'package:flutter/material.dart';
import 'package:sqlcool/sqlcool.dart';
import 'package:sqlview/sqlview.dart';

class _PageExpensesState extends State<PageExpenses> {
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
            onUpdate: update,
            onDelete: delete,
            trailingBuilder: (_context, _item) {
              return IconButton(
                icon: Icon(Icons.location_off),
                onPressed: () => print("$_item"),
              );
            }),
        Positioned(
            right: 15.0,
            bottom: 15.0,
            child: FloatingActionButton(
              heroTag: "actionBtn",
              child: Icon(Icons.add),
              onPressed: () => print("Add action"),
            )),
      ],
    );
  }
}

update(BuildContext context, Map<String, dynamic> item) {
  // item is the json record
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update"),
          // ...
          // Update using the Sqlcool database
          // Map<String, String> row = {"name": "value"};
          // db.update(table: "mytable", row: row, where: 'id=${item["id"]}');
        );
      });
}

delete(BuildContext context, Map<String, dynamic> item) {
  // item is the json record
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete"),
          // ...
          // delete using the Sqlcool database
          // db.delete(table: "mytable", where: 'id=${item["id"]}');
        );
      });
}

class PageExpenses extends StatefulWidget {
  @override
  _PageExpensesState createState() => _PageExpensesState();
}

   ```
