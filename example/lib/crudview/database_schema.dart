import 'package:sqlcool/sqlcool.dart';

List<DbTable> schema() {
  var table = DbTable("item")
    ..boolean("boolean", defaultValue: false)
    ..varchar("varchar")
    ..integer('integer_number', defaultValue: 1)
    ..real("double_number", defaultValue: 0)
    ..text("text", defaultValue: "");
  return [table];
}

List<String> populateQueries() {
  var qs = <String>[];
  qs.add('INSERT INTO item(varchar) VALUES("row 1")');
  qs.add('INSERT INTO item(varchar) VALUES("row 2")');
  qs.add('INSERT INTO item(varchar) VALUES("row 3")');
  return qs;
}
