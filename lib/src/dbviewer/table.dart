import 'package:flutter/material.dart';
import 'package:sqlcool/sqlcool.dart';

class _DbViewerTableState extends State<DbViewerTable> {
  _DbViewerTableState({@required this.db, @required this.table});

  final Db db;
  final DbTable table;

  List<Map<String, dynamic>> _rows;
  var _ready = false;

  Future<void> _getData() async {
    try {
      _rows = await db.select(table: table.name, limit: 100);
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    _getData().then((_) => setState(() => _ready = true));
  }

  @override
  Widget build(BuildContext context) {
    return _ready
        ? Scaffold(
            appBar: AppBar(title: Text("Table ${table.name}")),
            body: ListView.builder(
              itemCount: _rows.length,
              itemBuilder: (BuildContext context, int index) {
                final row = _rows[index];
                return ListTile(title: Text("$row"));
              },
            ))
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}

/// A table
class DbViewerTable extends StatefulWidget {
  /// Default constructor
  const DbViewerTable({@required this.db, @required this.table});

  /// The database
  final Db db;

  /// The table
  final DbTable table;

  @override
  _DbViewerTableState createState() =>
      _DbViewerTableState(db: db, table: table);
}
