import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ContentUnit{
  final String id;
  final String title;
  final List<String> items; // e.g., ["A","B","C"]
  ContentUnit(this.id, this.title, this.items);
}

class PacksRepo{
  final List<ContentUnit> units;
  PacksRepo(this.units);
  ContentUnit byId(String id) => units.firstWhere((e)=>e.id==id);
  List<ContentUnit> all() => units;
  static ContentUnit fromMap(Map<String,dynamic> m) => ContentUnit(m['id'], m['title'], (m['items'] as List).map((e)=>e.toString()).toList());
}

class OfflinePacks {
  static Future<List<ContentUnit>> loadFromAssets() async {
    final data = await rootBundle.loadString('assets/packs/basics.json');
    final List list = jsonDecode(data);
    return list.map((e)=>PacksRepo.fromMap(e)).toList();
  }
}
