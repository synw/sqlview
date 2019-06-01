import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:sqlcool/sqlcool.dart';
import 'package:card_settings/card_settings.dart';

class _TableFormState extends State<TableForm> {
  _TableFormState(
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
  final Map<String, String> _values = <String, String>{};

  @override
  void initState() {
    schema.columns.forEach((DatabaseColumn column) {
      _values[column.name] = null;
    });
    if (updateWhere != null)
      _getInitialData().then((d) => setState(() {
            _data = d;
            _defaultValues = true;
            _data.forEach((String k, dynamic v) => _values[k] = "$v");
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

  void _saveForm(BuildContext context) {
    try {
      if (updateWhere != null)
        db.update(table: schema.name, where: updateWhere, row: _values);
      else
        db.insert(table: schema.name, row: _values);
    } catch (e) {
      throw (e);
    }
    Navigator.of(context).pop();
  }

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
              CardSettingsButton(
                  label: "Save", onPressed: () => _saveForm(context))
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
            fields.add(CardSettingsSwitch(
                label: label, onChanged: (v) => _values[column.name] = "$v"));
          } else
            fields.add(CardSettingsSwitch(
                label: label,
                onChanged: (v) => _values[column.name] = "$v",
                initialValue: (_data[column.name].toString() == "true")));
          break;
        case DatabaseColumnType.integer:
          if (!defaults) {
            fields.add(CardSettingsInt(
                label: label, onChanged: (v) => _values[column.name] = "$v"));
          } else
            fields.add(CardSettingsInt(
                label: label,
                onChanged: (v) => _values[column.name] = "$v",
                initialValue: int.tryParse(_data[column.name].toString())));
          break;
        case DatabaseColumnType.real:
          if (!defaults) {
            fields.add(CardSettingsDouble(
                label: label, onChanged: (v) => _values[column.name] = "$v"));
          } else
            fields.add(CardSettingsDouble(
                label: label,
                onChanged: (v) => _values[column.name] = "$v",
                initialValue: double.tryParse(_data[column.name].toString())));
          break;
        case DatabaseColumnType.varchar:
          if (!defaults) {
            fields.add(CardSettingsText(
                label: label, onChanged: (v) => _values[column.name] = "$v"));
          } else {
            String val = _data[column.name].toString();
            if (val == "null") val = "";
            fields.add(CardSettingsText(
                label: label,
                onChanged: (v) => _values[column.name] = "$v",
                initialValue: val));
          }
          break;
        case DatabaseColumnType.text:
          if (!defaults) {
            fields.add(CardSettingsText(
                label: label,
                onChanged: (v) => _values[column.name] = "$v",
                numberOfLines: 3));
          } else {
            String val = _data[column.name].toString();
            if (val == "null") val = "";
            fields.add(CardSettingsText(
                label: label,
                onChanged: (v) => _values[column.name] = "$v",
                numberOfLines: 3,
                initialValue: val));
          }
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

/// A form to insert or update rows
class TableForm extends StatefulWidget {
  /// The [schema] is the table schema. If [updateWhere] is not
  /// provided this will render an add form, otherwise this will
  /// render an update form
  TableForm(
      {@required this.db,
      @required this.schema,
      this.formLabel,
      this.autoLabel = true,
      this.updateWhere});

  /// The Sqlcool dataabse
  final Db db;

  /// The table schema
  final DbTable schema;

  /// The label to display for the form
  final String formLabel;

  /// Format fields labels from field name
  final bool autoLabel;

  /// The sql where condition to grab the row to update
  final String updateWhere;

  @override
  _TableFormState createState() => _TableFormState(
      db: db,
      schema: schema,
      formLabel: formLabel,
      autoLabel: autoLabel,
      updateWhere: updateWhere);
}
