import 'package:sqlcool/sqlcool.dart';

List<DbTable> schema() {
  var company = DbTable("company")
    ..varchar("name", unique: true)
    ..varchar("symbol", unique: true)
    ..index("symbol");
  var price = DbTable("price")
    ..integer("date")
    ..real("price")
    ..foreignKey("company");
  return [company, price];
}
