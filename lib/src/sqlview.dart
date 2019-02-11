import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sqlcool/sqlcool.dart';

class _CrudViewState extends State<CrudView> {
  _CrudViewState(
      {@required this.bloc,
      @required this.updateItemAction,
      @required this.deleteItemAction,
      this.trailingBuilder,
      this.nameField: "name"})
      : assert(bloc != null),
        assert(updateItemAction != null),
        assert(deleteItemAction != null),
        assert(nameField != null);

  final SelectBloc bloc;
  final Function deleteItemAction;
  final Function updateItemAction;
  final String nameField;
  Function trailingBuilder;
  bool _isInitialized = false;
  SlidableController _slidableController;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map>>(
      stream: this.bloc.items,
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
                print("ITEM ${item["name"]} ${item[nameField]}");
                return Slidable(
                  controller: _slidableController,
                  direction: Axis.horizontal,
                  delegate: SlidableBehindDelegate(),
                  actionExtentRatio: 0.25,
                  child: ListTile(
                    title: GestureDetector(
                      child:
                          Text(item[nameField] ?? "NULL TEXT $item $nameField"),
                      onTap: () => updateItemAction(context, item),
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
                      onTap: () => deleteItemAction(context, item),
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
}

class CrudView extends StatefulWidget {
  CrudView({
    @required this.bloc,
    @required this.updateItemAction,
    @required this.deleteItemAction,
    this.nameField: "name",
    this.trailingBuilder,
  });

  final SelectBloc bloc;
  final Function deleteItemAction;
  final Function updateItemAction;
  final String nameField;
  final Function trailingBuilder;

  @override
  _CrudViewState createState() => _CrudViewState(
      bloc: bloc,
      updateItemAction: updateItemAction,
      deleteItemAction: deleteItemAction,
      nameField: nameField,
      trailingBuilder: trailingBuilder);
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
