import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:dio/dio.dart';
import '../conf.dart';
import 'models.dart';

var dio = Dio();

/// Get initial data if necessary
Future<void> init() async {
  int countCompanies = await db.count(table: "company", verbose: true);
  if (countCompanies > 0) return;
  await _fetchAndSave();
}

Future<void> _fetchAndSave() async {
  List<Company> companies = await _fetch();
  var data = <Map<String, String>>[];
  companies.forEach((company) {
    data.add({"name": company.name, "symbol": company.symbol});
  });
  db
      .batchInsert(
          table: "company",
          rows: data,
          confligAlgoritm: ConflictAlgorithm.replace,
          verbose: true)
      .catchError((dynamic e) {
    throw (e);
  });
}

Future<List<Company>> _fetch() async {
  try {
    var comp = <Company>[];
    String url =
        "https://financialmodelingprep.com/api/stock/list/all?datatype=json";
    Response response = await Dio().get(url);
    List<dynamic> data = json.decode(response.data);
    data.forEach((item) {
      var c = Company.fromJson(item);
      comp.add(c);
    });
    return comp;
  } catch (e) {
    throw (e);
  }
}
