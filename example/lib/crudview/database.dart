import 'package:sqlcool/sqlcool.dart';

List<String> initQueries() {
  var qs = <String>[];
  var table = DbTable("item")..varchar("name");
  qs.addAll(table.queries);
  qs.add('INSERT INTO item(name) VALUES("row 1")');
  qs.add('INSERT INTO item(name) VALUES("row 2")');
  qs.add('INSERT INTO item(name) VALUES("row 3")');
  return qs;
}
