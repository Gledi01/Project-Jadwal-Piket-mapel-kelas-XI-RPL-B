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

class _RootNavState extends State<RootNav> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    CalendarScreen(),
    PiketScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: isDark ? const Color(0xFF1A1D23) : Colors.white,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withOpacity(0.5),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded),
            label: 'Kalender',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cleaning_services_rounded),
            label: 'Piket',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}
