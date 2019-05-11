import 'package:sqlcool/sqlcool.dart';

List<String> initQueries() {
  var qs = <String>[];
  var company = DbTable("company")
    ..varchar("name", unique: true)
    ..varchar("symbol", unique: true)
    ..index("symbol");
  var price = DbTable("price")
    ..integer("date")
    ..real("price")
    ..foreignKey("company");
  qs.addAll(company.queries);
  qs.addAll(price.queries);
  return qs;
}
