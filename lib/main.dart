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

  // Daftar menu untuk popup
  final List<PopupMenuItem<int>> _menuItems = const [
    PopupMenuItem(value: 0, child: ListTile(leading: Icon(Icons.home_rounded), title: Text('Home'))),
    PopupMenuItem(value: 1, child: ListTile(leading: Icon(Icons.calendar_month_rounded), title: Text('Kalender'))),
    PopupMenuItem(value: 2, child: ListTile(leading: Icon(Icons.cleaning_services_rounded), title: Text('Piket'))),
    PopupMenuItem(value: 3, child: ListTile(leading: Icon(Icons.settings_rounded), title: Text('Pengaturan'))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('XI RPL B'),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (value) {
              setState(() {
                _currentIndex = value;
              });
            },
            itemBuilder: (context) => _menuItems,
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
    );
  }
}
