import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sqlcool/sqlcool.dart';

typedef void ItemActionBuilder(BuildContext context, Map<String, dynamic> item);
typedef Widget ItemWidgetBuilder(
    BuildContext context, Map<String, dynamic> item);
typedef String ItemStringBuilder(
    BuildContext context, Map<String, dynamic> item);

class _CrudViewState extends State<CrudView> {
  _CrudViewState(
      {@required this.bloc,
      this.onUpdate,
      this.onDelete,
      this.trailingBuilder,
      this.titleBuilder,
      this.nameBuilder,
      this.nameField})
      : assert(bloc != null) {
    nameField = nameField ?? "name";
    trailingBuilder = trailingBuilder ??
        (_, __) {
          return Text("");
        };
    onDelete = onDelete ?? _onDelete;
    onUpdate = onUpdate ?? (_, __) => null;
    titleBuilder = titleBuilder ?? _buildTitle;
  }

  final SelectBloc bloc;
  String nameField;
  ItemActionBuilder onUpdate;
  ItemActionBuilder onDelete;
  ItemWidgetBuilder trailingBuilder;
  ItemWidgetBuilder titleBuilder;
  ItemStringBuilder nameBuilder;

  bool _isInitialized = false;
  SlidableController _slidableController;

  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map>>(
      stream: bloc.items,
      builder: (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
        if (snapshot.hasData) {
          _isInitialized = true;
          if (snapshot.data.length == 0) {
            return Center(
              child: Icon(
                Icons.do_not_disturb_alt,
                color: Colors.grey[200],
                size: 75.0,
              ),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                var item = snapshot.data[index];
                return Slidable(
                  controller: _slidableController,
                  direction: Axis.horizontal,
                  delegate: SlidableBehindDelegate(),
                  actionExtentRatio: 0.25,
                  child: ListTile(
                    title: BuildedItem(
                      builder: titleBuilder,
                      item: item,
                    ),
                    trailing: BuildedItem(
                      builder: trailingBuilder,
                      item: item,
                    ),
                  ),
                  actions: <Widget>[
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () => onDelete(context, item),
                    ),
                    IconSlideAction(
                      caption: 'Edit',
                      color: Colors.blue,
                      icon: Icons.edit,
                      onTap: () => onUpdate(context, item),
                    ),
                  ],
                );
              });
        } else {
          if (_isInitialized) {
            return Center(
              child: Text("No data"),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      },
    );
  }

  void _onDelete(BuildContext _context, Map<String, dynamic> _item) {
    /// Default onDelete action
    String _name;
    (nameBuilder == null)
        ? _name = _item[nameField]
        : _name = nameBuilder(_context, _item);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete $_name?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            RaisedButton(
              child: Text("Delete"),
              color: Colors.red,
              textColor: Colors.white,
              onPressed: () {
                bloc.database
                    .delete(
                        table: bloc.table,
                        where: 'id=${_item["id"]}',
                        verbose: bloc.verbose)
                    .catchError((e) {
                  throw (e);
                });
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTitle(BuildContext _, Map<String, dynamic> item) {
    return Text("${item[nameField]}");
  }
}

class CrudView extends StatefulWidget {
  CrudView(
      {@required this.bloc,
      this.nameField,
      this.onUpdate,
      this.onDelete,
      this.trailingBuilder,
      this.titleBuilder,
      this.nameBuilder});

  final SelectBloc bloc;
  final String nameField;
  final ItemActionBuilder onDelete;
  final ItemActionBuilder onUpdate;
  final ItemWidgetBuilder trailingBuilder;
  final ItemWidgetBuilder titleBuilder;
  final ItemStringBuilder nameBuilder;

  @override
  _CrudViewState createState() => _CrudViewState(
      bloc: bloc,
      nameField: nameField,
      onUpdate: onUpdate,
      onDelete: onDelete,
      trailingBuilder: trailingBuilder,
      titleBuilder: titleBuilder,
      nameBuilder: nameBuilder);
}

class BuildedItem extends StatelessWidget {
  BuildedItem({@required this.builder, @required this.item})
      : assert(builder != null),
        assert(item != null);

  final Function builder;
  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    return builder(context, item);
  }
}
