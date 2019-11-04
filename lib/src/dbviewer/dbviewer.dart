import 'package:flutter/material.dart';
import 'package:sqlcool/sqlcool.dart';

import 'table.dart';

class _DbViewerState extends State<DbViewer> {
  _DbViewerState({@required this.db})
      : assert(db.hasSchema,
            "The database has no schema, the viewer is unavailable");

  final Db db;

  Map<DbTable, int> _tableNumRows;
  var _ready = false;

  Future<Map<DbTable, int>> countRows() async {
    await db.onReady;
    final tnr = <DbTable, int>{};
    for (final table in db.schema.tables) {
      //print("NR COUNT ${table.name}");
      final v = await db.count(table: table.name);
      tnr[table] = v;
    }
    //print("NR $tnr");
    return tnr;
  }

  @override
  void initState() {
    super.initState();
    countRows().then((tnr) => setState(() {
          _tableNumRows = tnr;
          _ready = true;
        }));
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Center(child: CircularProgressIndicator());
    }
    final rows = <Widget>[];
    _tableNumRows.forEach((table, n) => rows.add(GestureDetector(
            child: ListTile(
          title: Text("${table.name}"),
          trailing: Text("$n rows"),
          onTap: () => Navigator.of(context).push<DbViewerTable>(
              MaterialPageRoute(builder: (BuildContext context) {
            return DbViewerTable(db: db, table: table);
          })),
        ))));
    return Scaffold(
        appBar: AppBar(title: const Text("Tables")),
        body: ListView(children: rows));
  }
}

/// A widget to view the database
class DbViewer extends StatefulWidget {
  /// Provide a [db]
  const DbViewer({@required this.db});

  /// The database to view
  final Db db;

  @override
  _DbViewerState createState() => _DbViewerState(db: db);
}
