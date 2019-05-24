import 'package:flutter/material.dart';
import 'package:sqlcool/sqlcool.dart';
import 'package:sqlview/sqlview.dart';
import '../conf.dart';

class _CrudPageState extends State<CrudPage> {
  SelectBloc bloc;

  @override
  void initState() {
    bloc = SelectBloc(
      database: db,
      table: "item",
      reactive: true,
      verbose: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CrudView(
        bloc: bloc,
        nameField: "varchar",
        //onUpdate: updateDialog,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return TableFormPage(
                db: bloc.database,
                formLabel: "Add a row",
                schema: bloc.database.schema.table(bloc.table),
              );
            })),
      ),
    );
  }
}

class CrudPage extends StatefulWidget {
  @override
  _CrudPageState createState() => _CrudPageState();
}
