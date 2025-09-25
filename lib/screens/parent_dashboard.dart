import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/progression.dart';

class ParentDashboardScreen extends StatelessWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<Progression>();
    final weeklyGoal = (p.level*10);
    final progressPct = (p.stars % weeklyGoal) / weeklyGoal;

    return Scaffold(
      appBar: AppBar(title: const Text('Parent Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('This Week Goal: $weeklyGoal stars', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: progressPct.clamp(0,1)),
          const SizedBox(height: 8),
          Text('Current: ${p.stars % weeklyGoal} / $weeklyGoal'),
          const SizedBox(height: 16),
          Text('Streak: ${p.streakDays} days • Level: ${p.level} • Badges: ${p.badges.join(', ')}'),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.email_outlined),
            label: const Text('Email Weekly Summary'),
            onPressed: (){
              final subject = Uri.encodeComponent('Chumcred Weekly Summary');
              final body = Uri.encodeComponent('Level: ${p.level}%0AStars: ${p.stars}%0AStreak: ${p.streakDays} days%0ABadges: ${p.badges.join(', ')}');
              launchUrl(Uri.parse('mailto:?subject=$subject&body=$body'));
            },
          )
        ]),
      ),
    );
  }
}
