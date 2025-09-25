import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/packs.dart';

class OfflinePacksScreen extends StatelessWidget {
  const OfflinePacksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<PacksRepo>();
    final all = repo.all();
    return Scaffold(
      appBar: AppBar(title: const Text('Offline Content Packs')),
      body: ListView.builder(
        itemCount: all.length,
        itemBuilder: (_, i){
          final u = all[i];
          return ListTile(
            leading: const Icon(Icons.download_done),
            title: Text(u.title),
            subtitle: Text('Items: ${u.items.length}'),
          );
        },
      ),
    );
  }
}
