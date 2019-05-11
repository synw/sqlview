import 'package:flutter/material.dart';
import 'package:sqlcool/sqlcool.dart';
import 'package:sqlview/sqlview.dart';
import '../conf.dart';
import 'dialogs.dart';

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
        onUpdate: updateDialog,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => addDialog(context),
      ),
    );
  }
}

class CrudPage extends StatefulWidget {
  @override
  _CrudPageState createState() => _CrudPageState();
}
