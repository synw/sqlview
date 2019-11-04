import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqlcool/sqlcool.dart';

import 'form_page.dart';

/// Get the floating action button to add a record
FloatingActionButton addFloatingActionButton(
    {@required BuildContext context,
    @required Db db,
    @required DbTable schema}) {
  return FloatingActionButton(
    child: const Icon(Icons.add),
    onPressed: () => Navigator.of(context)
        .push<TableFormPage>(MaterialPageRoute(builder: (BuildContext context) {
      return TableFormPage(
        db: db,
        formLabel: "Add a row",
        schema: schema,
      );
    })),
  );
}

/// A floating action button to add a row
class CrudAddActionButton extends StatelessWidget {
  /// Default constructor: provide a [Db] and a [DbTable] schema
  const CrudAddActionButton({@required this.db, @required this.schema});

  /// The database to use
  final Db db;

  /// The table schema
  final DbTable schema;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () => Navigator.of(context).push<TableFormPage>(
          MaterialPageRoute(builder: (BuildContext context) {
        return TableFormPage(
          db: db,
          formLabel: "Add a row",
          schema: schema,
        );
      })),
    );
  }
}
