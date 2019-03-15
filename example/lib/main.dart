import 'package:flutter/material.dart';
import 'package:sqlcool/sqlcool.dart';
import 'package:sqlview/sqlview.dart';
import 'conf.dart';
import 'dialogs.dart';

class _PageCrudExampleState extends State<PageCrudExample> {
  SelectBloc bloc;

  bool _dbIsReady = false;

  @override
  void initState() {
    db.onReady.then((_) {
      print("The database is ready");
      bloc = SelectBloc(
          database: db, table: "item", reactive: true, verbose: true);
      setState(() => _dbIsReady = true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_dbIsReady
          ? const CircularProgressIndicator()
          : CrudView(
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

class PageCrudExample extends StatefulWidget {
  @override
  _PageCrudExampleState createState() => _PageCrudExampleState();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dataview Demo',
      home: PageCrudExample(),
    );
  }
}

initDb() async {
  String q = """CREATE TABLE item (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL
  )""";
  String q1 = 'INSERT INTO item(name) VALUES("row 1")';
  String q2 = 'INSERT INTO item(name) VALUES("row 2")';
  String q3 = 'INSERT INTO item(name) VALUES("row 3")';
  String dbpath = "item.sqlite";
  await db
      .init(path: dbpath, queries: [q, q1, q2, q3], verbose: true)
      .catchError((e) {
    throw ("Error initializing the database: ${e.message}");
  });
}

void main() {
  initDb();
  runApp(MyApp());
}
