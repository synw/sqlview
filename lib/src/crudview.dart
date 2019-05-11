import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sqlcool/sqlcool.dart';
import 'datatypes.dart';

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
    trailingBuilder = trailingBuilder ?? (_, __) => const Text("");
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
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: bloc.items,
      builder: (BuildContext context,
          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          _isInitialized = true;
          if (snapshot.data.isEmpty) {
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
                  delegate: const SlidableBehindDelegate(),
                  actionExtentRatio: 0.25,
                  child: ListTile(
                    title: _BuildedItem(
                      builder: titleBuilder,
                      item: item,
                    ),
                    trailing: _BuildedItem(
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
              child: const Text("No data"),
            );
          } else {
            return Center(child: const CircularProgressIndicator());
          }
        }
      },
    );
  }

  void _onDelete(BuildContext _context, Map<String, dynamic> _item) {
    /// Default onDelete action
    String _name;
    (nameBuilder == null)
        ? _name = "${_item[nameField]}"
        : _name = nameBuilder(_context, _item);
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete $_name?"),
          actions: <Widget>[
            FlatButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            RaisedButton(
              child: const Text("Delete"),
              color: Colors.red,
              textColor: Colors.white,
              onPressed: () {
                bloc.database
                    .delete(
                        table: bloc.table,
                        where: 'id=${_item["id"]}',
                        verbose: bloc.verbose)
                    .catchError((dynamic e) {
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

/// An almost ready to use page for crud operations
class CrudView extends StatefulWidget {
  /// Basic constructor: needs a [SelectBloc]
  CrudView(
      {@required this.bloc,
      this.nameField,
      this.onUpdate,
      this.onDelete,
      this.trailingBuilder,
      this.titleBuilder,
      this.nameBuilder});

  /// The bloc defining the query
  final SelectBloc bloc;

  /// The field used to represent the item
  final String nameField;

  /// Delete item action
  final ItemActionBuilder onDelete;

  /// Update item action
  final ItemActionBuilder onUpdate;

  /// Builder for the list view trailing widget
  final ItemWidgetBuilder trailingBuilder;

  /// Builder for the list view title
  final ItemWidgetBuilder titleBuilder;

  /// Builder for the name: used as an alternative to [nameField]
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

class _BuildedItem extends StatelessWidget {
  _BuildedItem({@required this.builder, @required this.item})
      : assert(builder != null),
        assert(item != null);

  final ItemWidgetBuilder builder;
  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    return builder(context, item);
  }
}
