import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/strings.dart';
import '../services/tts.dart';
import '../services/progression.dart';
import '../services/packs.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = Strings.of(context);
    final prog = context.watch<Progression>();
    final packs = context.read<PacksRepo>().all();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chumcred Kids Lite'),
        actions: [
          IconButton(icon: const Icon(Icons.download), tooltip: 'Offline packs', onPressed: ()=>Navigator.pushNamed(context, '/packs')),
          IconButton(icon: const Icon(Icons.family_restroom), tooltip: tr('parent_dashboard'), onPressed: ()=>Navigator.pushNamed(context, '/parent')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(child: ListTile(
            title: Text('Level ${prog.level} • ⭐ ${prog.stars} • 🔥 Streak ${prog.streakDays}d'),
            subtitle: Text('Badges: ${prog.badges.join(', ')}'),
          )),
          const SizedBox(height: 8),
          Text('Units', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Wrap(spacing: 12, runSpacing: 12, children: [
            for(final u in packs) _UnitCard(title: u.title, unitId: u.id),
          ]),
        ],
      ),
    );
  }
}

class _UnitCard extends StatelessWidget {
  final String title;
  final String unitId;
  const _UnitCard({required this.title, required this.unitId});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _Lesson(unitId: unitId, title: title))),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(14), color: Colors.white),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.school, size: 42, color: Color(0xFF1F497D)),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }
}

class _Lesson extends StatefulWidget {
  final String unitId; final String title;
  const _Lesson({required this.unitId, required this.title});
  @override State<_Lesson> createState() => _LessonState();
}
class _LessonState extends State<_Lesson> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final repo = context.read<PacksRepo>();
    final unit = repo.byId(widget.unitId);
    final prog = context.read<Progression>();
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(unit.items[index], style: const TextStyle(fontSize: 72, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Wrap(spacing: 10, children: [
          ElevatedButton.icon(icon: const Icon(Icons.volume_up), label: const Text('Listen'), onPressed: () => TTS().speak(unit.items[index])),
          ElevatedButton.icon(icon: const Icon(Icons.check_circle), label: const Text('Mark Done'), onPressed: (){
            prog.addStars(2);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Great job! +2⭐')));
          }),
        ]),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton(onPressed: () => setState(()=> index = (index - 1) % unit.items.length), icon: const Icon(Icons.chevron_left, size: 40)),
          IconButton(onPressed: () => setState(()=> index = (index + 1) % unit.items.length), icon: const Icon(Icons.chevron_right, size: 40)),
        ])
      ])),
    );
  }
}
