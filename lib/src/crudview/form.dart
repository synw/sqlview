import 'package:card_settings/card_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqlcool/sqlcool.dart';

class _TableFormState extends State<TableForm> {
  _TableFormState(
      {@required this.db,
      @required this.schema,
      this.formLabel,
      this.autoLabel = true,
      this.updateWhere,
      this.defaultValues}) {
    formLabel ??= _autoLabel(schema.name);
  }

  final Db db;
  final DbTable schema;
  final bool autoLabel;
  String formLabel;
  String updateWhere;
  final Map<String, dynamic> defaultValues;

  bool _ready = false;
  bool _defaultValues = false;
  var _values = <String, dynamic>{};

  @override
  void initState() {
    schema.columns.forEach((DbColumn column) {
      if (column.type != DbColumnType.timestamp &&
          column.type != DbColumnType.blob) _values[column.name] = null;
    });
    if (updateWhere != null) {
      _getInitialData().then((d) => setState(() {
            //_data = d;
            _defaultValues = true;
            d.forEach((String k, dynamic v) => _values[k] = "$v");
            _ready = true;
          }));
    } else {
      if (defaultValues != null) {
        _defaultValues = true;
        _values = defaultValues;
      }
      _ready = true;
    }
    super.initState();
  }

  Future<Map<String, dynamic>> _getInitialData() async {
    Map<String, dynamic> data;
    try {
      final res = await db.select(table: schema.name, where: updateWhere);
      data = res[0];
    } catch (e) {
      rethrow;
    }
    return data;
  }

  void _saveForm(BuildContext context) {
    print("SAVE FORM $_values");
    // check for nulls
    final vals = <String, String>{};
    _values.forEach((String k, dynamic v) {
      if (v == "null") v = "NULL";
      vals[k] = "$v";
    });
    // save
    try {
      if (updateWhere != null) {
        db.update(table: schema.name, where: updateWhere, row: vals);
      } else {
        db.insert(table: schema.name, row: vals);
      }
    } catch (e) {
      rethrow;
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
    final fields = <Widget>[];
    schema.columns.forEach((DbColumn column) {
      var label = column.name;
      if (autoLabel) label = _autoLabel(column.name);
      switch (column.type) {
        case DbColumnType.boolean:
          if (!defaults) {
            fields.add(CardSettingsSwitch(
                label: label, onChanged: (v) => _values[column.name] = "$v"));
          } else {
            fields.add(CardSettingsSwitch(
                label: label,
                onChanged: (v) => _values[column.name] = "$v",
                initialValue: _values[column.name].toString() == "true"));
          }
          break;
        case DbColumnType.integer:
          if (!defaults) {
            fields.add(CardSettingsInt(
                label: label, onChanged: (v) => _values[column.name] = "$v"));
          } else {
            fields.add(CardSettingsInt(
                label: label,
                onChanged: (v) => _values[column.name] = "$v",
                initialValue: int.tryParse(_values[column.name].toString())));
          }
          break;
        case DbColumnType.real:
          if (!defaults) {
            fields.add(CardSettingsDouble(
                label: label, onChanged: (v) => _values[column.name] = "$v"));
          } else {
            fields.add(CardSettingsDouble(
                label: label,
                onChanged: (v) => _values[column.name] = "$v",
                initialValue:
                    double.tryParse(_values[column.name].toString())));
          }
          break;
        case DbColumnType.varchar:
          if (!defaults) {
            fields.add(CardSettingsText(
                label: label, onChanged: (v) => _values[column.name] = "$v"));
          } else {
            var val = _values[column.name].toString();
            if (val == "null") val = "";
            fields.add(CardSettingsText(
                label: label,
                onChanged: (v) => _values[column.name] = "$v",
                initialValue: val));
          }
          break;
        case DbColumnType.text:
          if (!defaults) {
            fields.add(CardSettingsText(
                label: label,
                onChanged: (v) => _values[column.name] = "$v",
                numberOfLines: 3));
          } else {
            var val = _values[column.name].toString();
            if (val == "null") val = "";
            fields.add(CardSettingsText(
                label: label,
                onChanged: (v) => _values[column.name] = "$v",
                numberOfLines: 3,
                initialValue: val));
          }
          break;
        case DbColumnType.timestamp:
          break;
        case DbColumnType.blob:
          break;
      }
    });
    return fields;
  }

  String _autoLabel(String value) {
    final s = value.replaceAll("_", " ");
    return _capitalize(s);
  }

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}

/// A form to insert or update rows
class TableForm extends StatefulWidget {
  /// The [schema] is the table schema. If [updateWhere] is not
  /// provided this will render an add form, otherwise this will
  /// render an update form
  const TableForm(
      {@required this.db,
      @required this.schema,
      this.formLabel,
      this.autoLabel = true,
      this.updateWhere,
      this.defaultValues});

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

  /// Pass default values for add form
  final Map<String, dynamic> defaultValues;

  @override
  _TableFormState createState() => _TableFormState(
      db: db,
      schema: schema,
      formLabel: formLabel,
      autoLabel: autoLabel,
      updateWhere: updateWhere,
      defaultValues: defaultValues);
}
