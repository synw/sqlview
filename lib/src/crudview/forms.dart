import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:sqlcool/sqlcool.dart';
import 'package:card_settings/card_settings.dart';

class _TableFormPageState extends State<TableFormPage> {
  _TableFormPageState(
      {@required this.db,
      @required this.schema,
      this.formLabel,
      this.autoLabel = true,
      this.updateWhere}) {
    formLabel ??= _autoLabel(schema.name);
  }

  final Db db;
  final DbTable schema;
  final bool autoLabel;
  String formLabel;
  String updateWhere;

  Map<String, dynamic> _data = <String, dynamic>{};
  bool _ready = false;
  bool _defaultValues = false;

  @override
  void initState() {
    if (updateWhere != null)
      _getInitialData().then((d) => setState(() {
            _data = d;
            _defaultValues = true;
            _ready = true;
          }));
    else
      _ready = true;
    super.initState();
  }

  Future<Map<String, dynamic>> _getInitialData() async {
    Map<String, dynamic> data;
    try {
      List<Map<String, dynamic>> res =
          await db.select(table: schema.name, where: updateWhere);
      data = res[0];
    } catch (e) {
      throw (e);
    }
    return data;
  }

  Future<void> _updateData(Map<String, String> row) async {
    try {
      await db.update(table: schema.name, where: updateWhere, row: row);
    } catch (e) {
      throw ("Can not update data $e");
    }
  }

  void _saveForm() {}

  @override
  Widget build(BuildContext context) {
    List<Widget> fields;
    switch (_defaultValues) {
      case true:
        fields = _buildFields(defaults: true);
        break;
      default:
        fields = _buildFields();
    }
    return _ready
        ? CardSettings(
            children: <Widget>[
              CardSettingsHeader(label: formLabel),
              ...fields,
              CardSettingsButton(label: "Save", onPressed: () => null)
            ],
          )
        : const Center(child: CircularProgressIndicator());
  }

  List<Widget> _buildFields({bool defaults = false}) {
    var fields = <Widget>[];
    schema.columns.forEach((DatabaseColumn column) {
      String label = column.name;
      if (autoLabel) label = _autoLabel(column.name);
      switch (column.type) {
        case DatabaseColumnType.boolean:
          if (!defaults) {
            fields.add(CardSettingsSwitch(label: label));
          } else
            fields.add(CardSettingsSwitch(
                label: label, initialValue: (_data[column.name] == true)));
          break;
        case DatabaseColumnType.integer:
          if (!defaults) {
            fields.add(CardSettingsInt(label: label));
          } else
            fields.add(CardSettingsInt(
                label: label,
                initialValue: int.tryParse(_data[column.name].toString())));
          break;
        case DatabaseColumnType.real:
          if (!defaults) {
            fields.add(CardSettingsDouble(label: label));
          } else
            fields.add(CardSettingsDouble(
                label: label,
                initialValue: double.tryParse(_data[column.name].toString())));
          break;
        case DatabaseColumnType.varchar:
          if (!defaults) {
            fields.add(CardSettingsText(label: label));
          } else
            fields.add(CardSettingsText(
                label: label, initialValue: _data[column.name].toString()));
          break;
        case DatabaseColumnType.text:
          if (!defaults) {
            fields.add(CardSettingsText(label: label, numberOfLines: 3));
          } else
            fields.add(CardSettingsText(
                label: label,
                numberOfLines: 3,
                initialValue: _data[column.name].toString()));
      }
    });
    return fields;
  }

  String _autoLabel(String value) {
    String s = value.replaceAll("_", " ");
    return _capitalize(s);
  }

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}

class TableFormPage extends StatefulWidget {
  TableFormPage(
      {@required this.db,
      @required this.schema,
      this.formLabel,
      this.autoLabel = true,
      this.updateWhere});

  final Db db;
  final DbTable schema;
  final String formLabel;
  final bool autoLabel;
  final String updateWhere;

  @override
  _TableFormPageState createState() => _TableFormPageState(
      db: db,
      schema: schema,
      formLabel: formLabel,
      autoLabel: autoLabel,
      updateWhere: updateWhere);
}
