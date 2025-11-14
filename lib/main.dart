import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'providers/account_provider.dart';
import 'providers/activation_provider.dart';
import 'screens/accounts_screen.dart';
import 'screens/activation_screen.dart';
import 'screens/journal_screen.dart';
import 'services/activation_service.dart';
import 'services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final databaseService = await DatabaseService.init();
  final activationService = ActivationService(databaseService);
  runApp(AlRawayApp(
    databaseService: databaseService,
    activationService: activationService,
  ));
}

class AlRawayApp extends StatelessWidget {
  const AlRawayApp({super.key, required this.databaseService, required this.activationService});

  final DatabaseService databaseService;
  final ActivationService activationService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AccountProvider(databaseService)..loadAccounts()),
        ChangeNotifierProvider(create: (_) => ActivationProvider(activationService)..load()),
      ],
      child: MaterialApp(
        title: 'الرعوي',
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.teal,
          fontFamily: 'Roboto',
        ),
        home: const HomeShell(),
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  final _screens = const [
    AccountsScreen(),
    JournalScreen(),
    ActivationScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.people_alt), label: 'الحسابات'),
          NavigationDestination(icon: Icon(Icons.book), label: 'قيد اليومية'),
          NavigationDestination(icon: Icon(Icons.lock), label: 'التفعيل'),
        ],
        onDestinationSelected: (value) => setState(() => _index = value),
      ),
    );
  }
}
