import 'package:flutter/material.dart';
import 'package:sqlcool/sqlcool.dart';
import 'form.dart';

/// A page to display a form
class TableFormPage extends StatelessWidget {
  /// The [schema] is the table schema. If [updateWhere] is not
  /// provided this will render an add form, otherwise this will
  /// render an update form
  TableFormPage(
      {@required this.db,
      @required this.schema,
      this.formLabel,
      this.autoLabel = true,
      this.updateWhere});

  /// The Sqlcool dataabse
  final Db db;

  /// The table schema
  final DbTable schema;

  /// The label to display for the form
  final bool autoLabel;

  /// Format fields labels from field name
  final String formLabel;

  /// The sql where condition to grab the row to update
  final String updateWhere;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TableForm(
        db: db,
        schema: schema,
        autoLabel: autoLabel,
        formLabel: formLabel,
        updateWhere: updateWhere,
      ),
    );
  }
}
