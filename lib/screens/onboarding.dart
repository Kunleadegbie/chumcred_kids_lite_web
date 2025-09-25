import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/strings.dart';
import '../main.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = Strings.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Chumcred Kids Lite', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: const Color(0xFF1F497D), fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(tr('welcome_sub'), textAlign: TextAlign.center),
            const SizedBox(height: 18),
            DropdownButton<String>(
              value: Localizations.localeOf(context).languageCode,
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'yo', child: Text('Yorùbá')),
                DropdownMenuItem(value: 'ha', child: Text('Hausa')),
                DropdownMenuItem(value: 'ig', child: Text('Igbo')),
              ],
              onChanged: (val) { if (val != null) context.read<AppState>().setLocale(val); },
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              icon: const Icon(Icons.rocket_launch_outlined),
              label: Text(tr('start_learning')),
              onPressed: () => context.read<AppState>().completeOnboarding(),
            ),
          ],
        ),
      ),
    );
  }
}
