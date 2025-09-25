import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'services/storage.dart';
import 'services/strings.dart';
import 'services/progression.dart';
import 'services/packs.dart';
import 'screens/onboarding.dart';
import 'screens/home.dart';
import 'screens/parent_dashboard.dart';
import 'screens/offline_packs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await AppStorage.create();
  final packs = await OfflinePacks.loadFromAssets();
  runApp(ChumcredApp(storage: storage, packs: packs));
}

class ChumcredApp extends StatelessWidget {
  final AppStorage storage;
  final List<ContentUnit> packs;
  const ChumcredApp({super.key, required this.storage, required this.packs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => storage),
        ChangeNotifierProvider(create: (_) => AppState(storage)),
        ChangeNotifierProvider(create: (_) => Progression(storage)),
        Provider(create: (_) => PacksRepo(packs)),
      ],
      child: Consumer<AppState>(builder: (context, state, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Chumcred Kids Lite',
          locale: Locale(state.localeCode),
          supportedLocales: const [
            Locale('en'), Locale('yo'), Locale('ha'), Locale('ig')
          ],
          localizationsDelegates: const [
            Strings.delegate, // ← ADD THIS LINE
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1F497D)),
            useMaterial3: true,
          ),
          routes: {
            '/': (_) => state.seenOnboarding ? const HomeScreen() : const OnboardingScreen(),
            '/parent': (_) => const ParentDashboardScreen(),
            '/packs': (_) => const OfflinePacksScreen(),
          },
        );
      }),
    );
  }
}

class AppState extends ChangeNotifier {
  final AppStorage storage;
  bool seenOnboarding = false;
  String localeCode = 'en';
  AppState(this.storage) {
    seenOnboarding = storage.getBool('seenOnboarding') ?? false;
    localeCode = storage.getString('locale') ?? 'en';
  }
  void completeOnboarding() { seenOnboarding = true; storage.setBool('seenOnboarding', true); notifyListeners(); }
  void setLocale(String code) { localeCode = code; storage.setString('locale', code); notifyListeners(); }
}
