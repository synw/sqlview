import 'dart:async';
import 'package:sqlcool/sqlcool.dart';
import 'crudview/database_schema.dart' as crud;
import 'listview/database_schema.dart' as listview;

Db db = Db();

String _dbpath = "db.sqlite";
Completer _readyCompleter = Completer();

Future<void> get onConfReady => _readyCompleter.future;

initConf() async {
  await initDb();
  _readyCompleter.complete();
  print("Configuration completed");
}

Future<void> initDb() async {
  // get the database schemas
  List<DbTable> schema = crud.schema()..addAll(listview.schema());
  List<String> q = crud.populateQueries();
  // initialize the database
  await db
      .init(path: _dbpath, schema: schema, queries: q, verbose: true)
      .catchError((e) {
    throw ("Error initializing the database: ${e.message}");
  });
  // wait for the database to be ready
  await db.onReady;
  print("The database is ready");
}
