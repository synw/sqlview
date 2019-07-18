import 'package:flutter/material.dart';
import 'package:sqlview/sqlview.dart';
import 'data.dart' as data;
import '../conf.dart';

class _ListViewPageState extends State<ListViewPage> {
  bool hasData = false;

  @override
  void initState() {
    data
        .init()
        .then((_) => setState(() => hasData = true))
        .catchError((dynamic e) => throw (e));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: hasData
          ? InfiniteListView(
              db: db,
              table: "company",
              limit: 35,
              //searchColumn: "name",
              orderBy: "name",
              itemsBuilder: (context, item) {
                return ListTile(
                    title: Text(item['name']), trailing: Text(item["symbol"]));
              },
              verbose: true)
          : Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: const Text("Loading data ..."),
                ),
                const CircularProgressIndicator(),
              ],
            )),
    );
  }
}

class ListViewPage extends StatefulWidget {
  @override
  _ListViewPageState createState() => _ListViewPageState();
}
