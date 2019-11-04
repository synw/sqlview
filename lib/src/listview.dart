import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqlcool/sqlcool.dart';

import 'datatypes.dart';

class _InfiniteListViewState extends State<InfiniteListView> {
  _InfiniteListViewState(
      {@required this.db,
      @required this.table,
      @required this.itemsBuilder,
      this.columns = "*",
      this.where,
      this.orderBy,
      this.offset = 0,
      this.limit = 30,
      //this.searchColumn,
      //this.searchStartsWith = false,
      this.verbose = false})
      : _currentOffset = offset {
    /*if (searchColumn == null)
      _search = false;
    else
      _search = true;*/
  }

  final Db db;
  final String table;
  final String columns;
  final String where;
  final String orderBy;
  final int offset;
  final int limit;
  final ItemWidgetBuilder itemsBuilder;
  final bool verbose;
  //final String searchColumn;
  //final bool searchStartsWith;

  int _currentOffset;
  //bool _search;
  var _data = <Map<String, dynamic>>[];
  bool _ready = false;
  //final _controller = TextEditingController();
  final _subject = PublishSubject<String>();
  bool _foundData;

  Future<void> fetch({bool initial = false}) async {
    try {
      if (!initial) _currentOffset = _currentOffset + limit;
      //print("FETCH offset $_currentOffset");

      final res = await db.select(
          table: table,
          where: where,
          orderBy: orderBy,
          columns: columns,
          offset: _currentOffset,
          limit: limit,
          verbose: verbose);
      //res ??= <Map<String, dynamic>>[];
      if (res.isNotEmpty) {
        _foundData = true;
      } else {
        _foundData = false;
      }
      _data = <Map<String, dynamic>>[..._data, ...res];
      //_data.addAll(res);
      //print("DATA $_data");
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    fetch(initial: true).then((_) => setState(() => _ready = true));
    /*if (_search)
      _subject.stream
          .debounceTime(Duration(milliseconds: 500))
          .listen((dynamic text) {
        String w = where;
        String textSearch = "%$text%";
        if (searchStartsWith) {
          textSearch = "$text%";
        }
        if (text != "") if (where != null) {
          w = '$where AND $searchColumn LIKE "$textSearch"';
        } else
          w = '$searchColumn LIKE "$textSearch"';
        db
            .select(
                table: table,
                where: w,
                limit: limit,
                orderBy: orderBy,
                columns: columns,
                verbose: verbose)
            .then((List<Map<String, dynamic>> res) {
          res ??= <Map<String, dynamic>>[];
          setState(() => _data = res);
        });
      });*/
    super.initState();
  }

  @override
  void dispose() {
    _subject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_ready && _data.isEmpty) return const Center(child: Text("No data"));
    Widget w;
    _ready
        ? w = Column(children: <Widget>[
            /*if (_search)
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: TextField(
                        controller: _controller,
                        onChanged: (text) => _subject.add(text),
                      )),
                      Icon(Icons.search)
                    ],
                  )),*/
            Expanded(
                child: ListView.builder(
              itemBuilder: (context, index) {
                if (index < _data.length) {
                  //print("BUILD ITEM $index < ${_data.length}");
                  return itemsBuilder(context, _data[index]);
                } else {
                  if (!_foundData) {
                    //print("NO DATA");
                    return const Text("");
                  }
                  // print("FETCH $index > ${_data.length}");
                  fetch().then((_) => setState(() {}));
                  return const Center(child: CircularProgressIndicator());
                }
              },
              itemCount: _data.length + 1,
            ))
          ])
        : w = const Center(child: CircularProgressIndicator());
    return w;
  }
}

/// The infinite list view widget
class InfiniteListView extends StatefulWidget {
  /// Default constructor
  const InfiniteListView(
      {@required this.db,
      @required this.table,
      @required this.itemsBuilder,
      this.columns = "*",
      this.where,
      this.orderBy,
      this.offset = 0,
      this.limit = 30,
      //this.searchColumn,
      this.verbose = false})
      : assert(db != null),
        assert(table != null);

  /// The sqlcool database to use
  final Db db;

  /// The table name
  final String table;

  /// The columns to include
  final String columns;

  /// The sql where clause
  final String where;

  /// The sql order_by clause
  final String orderBy;

  /// The sql offset value
  final int offset;

  /// The sql limit value
  final int limit;

  /// The fueld to Use to search. Adds a search widget
  //final String searchColumn;

  /// The function to build the content widgets
  final ItemWidgetBuilder itemsBuilder;

  /// Verbosity of the methdds
  final bool verbose;

  @override
  _InfiniteListViewState createState() => _InfiniteListViewState(
      db: db,
      table: table,
      columns: columns,
      where: where,
      orderBy: orderBy,
      offset: offset,
      limit: limit,
      //searchColumn: searchColumn,
      itemsBuilder: itemsBuilder,
      verbose: verbose);
}
