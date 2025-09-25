import 'package:flutter/material.dart';
import 'storage.dart';

class Progression extends ChangeNotifier {
  final AppStorage storage;
  int level = 1;
  int stars = 0;
  int streakDays = 0;
  DateTime? lastActive;
  List<String> badges = [];

  Progression(this.storage){
    level = storage.getInt('level') ?? 1;
    stars = storage.getInt('stars') ?? 0;
    streakDays = storage.getInt('streak') ?? 0;
    final last = storage.getString('lastActive');
    if(last != null) lastActive = DateTime.tryParse(last);
    badges = (storage.getString('badges') ?? '').split(',').where((e)=>e.isNotEmpty).toList();
    _updateStreak();
  }

  void _updateStreak(){
    final now = DateTime.now();
    if(lastActive == null) {
      streakDays = 1;
    } else {
      final diff = now.difference(lastActive!).inDays;
      if (diff == 0) {
        // same day, no change
      } else if (diff == 1) {
        streakDays += 1;
      } else if (diff > 1) {
        streakDays = 1; // reset
      }
    }
    lastActive = now;
    storage.setString('lastActive', now.toIso8601String());
    storage.setInt('streak', streakDays);
    notifyListeners();
  }

  void addStars(int n){
    stars += n;
    storage.setInt('stars', stars);
    if(stars >= level * 10) { level += 1; storage.setInt('level', level); _awardBadge('Level ' + level.toString()); }
    notifyListeners();
  }

  void _awardBadge(String badge){
    if(!badges.contains(badge)){
      badges.add(badge);
      storage.setString('badges', badges.join(','));
    }
  }
}
