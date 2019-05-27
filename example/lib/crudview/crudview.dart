import 'package:flutter/material.dart';
import 'package:sqlcool/sqlcool.dart';
import 'package:sqlview/sqlview.dart';
import '../conf.dart';

class _CrudPageState extends State<CrudPage> {
  SelectBloc bloc;

  @override
  void initState() {
    bloc =
        SelectBloc(database: db, table: "item", reactive: true, verbose: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CrudView(bloc: bloc, nameField: "varchar"),
      floatingActionButton:
          CrudAddActionButton(db: db, schema: db.schema.table("item")),
    );
  }
}

class CrudPage extends StatefulWidget {
  @override
  _CrudPageState createState() => _CrudPageState();
}
