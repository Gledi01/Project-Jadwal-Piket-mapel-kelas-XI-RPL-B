import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'theme/app_theme.dart';
import 'services/settings_service.dart';
import 'services/notification_service.dart';
import 'screens/home_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/piket_screen.dart';
import 'screens/settings_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  final settings = SettingsService();
  await settings.load();

  await NotificationService().init();
  await NotificationService().scheduleAllUpcoming(
    notifMapel: settings.notifMapel,
    notifIstirahat: settings.notifIstirahat,
    notifPiket: settings.notifPiket,
  );

  runApp(
    ChangeNotifierProvider.value(
      value: settings,
      child: const KelasRapiApp(),
    ),
  );
}

class KelasRapiApp extends StatelessWidget {
  const KelasRapiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>();
    return MaterialApp(
      title: 'XI RPL B',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(settings.color),
      darkTheme: AppTheme.dark(settings.color),
      themeMode: settings.darkMode ? ThemeMode.dark : ThemeMode.light,
      supportedLocales: const [Locale('id', 'ID')],
      locale: const Locale('id', 'ID'),
      home: const RootNav(),
    );
  }
}

class RootNav extends StatefulWidget {
  const RootNav({super.key});

  @override
  State<RootNav> createState() => _RootNavState();
}

class _RootNavState extends State<RootNav> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final _pages = const [
    HomeScreen(),
    CalendarScreen(),
    PiketScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _pages.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        toolbarHeight: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: scheme.primary,
          unselectedLabelColor: scheme.onSurface.withOpacity(0.5),
          indicatorColor: scheme.primary,
          tabs: const [
            Tab(icon: Icon(Icons.home_rounded), text: 'Home'),
            Tab(icon: Icon(Icons.calendar_month_rounded), text: 'Kalender'),
            Tab(icon: Icon(Icons.cleaning_services_rounded), text: 'Piket'),
            Tab(icon: Icon(Icons.settings_rounded), text: 'Pengaturan'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
    );
  }
}
