import 'package:flutter/material.dart';
import 'package:sqlcool/sqlcool.dart';
import 'form.dart';

class TableFormPage extends StatelessWidget {
  TableFormPage(
      {@required this.db,
      @required this.schema,
      this.formLabel,
      this.autoLabel = true,
      this.updateWhere});

  final Db db;
  final DbTable schema;
  final bool autoLabel;
  final String formLabel;
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
