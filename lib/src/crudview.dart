import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sqlcool/sqlcool.dart';

class _CrudViewState extends State<CrudView> {
  _CrudViewState(
      {@required this.bloc,
      @required this.onUpdate,
      this.onDelete,
      this.trailingBuilder,
      this.onTap,
      this.nameField: "name"})
      : assert(bloc != null),
        assert(onUpdate != null) {
    trailingBuilder = trailingBuilder ??
        (_c, _i) {
          return Text("");
        };
    onDelete = onDelete ?? _onDelete;
    onTap = onTap ?? () => {};
  }

  final SelectBloc bloc;
  final Function onUpdate;
  final String nameField;
  Function onDelete;
  Function onTap;
  Function trailingBuilder;
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
                    title: (onTap != null)
                        ? GestureDetector(
                            child: Text("${item[nameField]}"),
                            onTap: () => onTap(context, item),
                          )
                        : Text("${item[nameField]}"),
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

  _onDelete(_context, _item) {
    /// Default onDelete action
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete ${_item[nameField]}?"),
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
                /*bloc.database
                    .delete(
                        table: bloc.table,
                        where: 'id=${_item["id"]}',
                        verbose: bloc.verbose)
                    .catchError((e) {
                  throw (e);
                });*/
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}

class CrudView extends StatefulWidget {
  CrudView({
    @required this.bloc,
    @required this.onUpdate,
    this.onDelete,
    this.nameField: "name",
    this.trailingBuilder,
    this.onTap,
  });

  final SelectBloc bloc;
  final Function onDelete;
  final Function onUpdate;
  final String nameField;
  final Function trailingBuilder;
  final Function onTap;

  @override
  _CrudViewState createState() => _CrudViewState(
      bloc: bloc,
      onUpdate: onUpdate,
      onDelete: onDelete,
      nameField: nameField,
      trailingBuilder: trailingBuilder,
      onTap: onTap);
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
