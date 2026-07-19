import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/settings_service.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>();
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        children: [
          Text('Pengaturan',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 20),

          _SectionTitle('Tampilan'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Mode Gelap', style: TextStyle(fontWeight: FontWeight.w600)),
                    value: settings.darkMode,
                    onChanged: (v) => settings.setDarkMode(v),
                  ),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('Warna Tema', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: AppThemeColor.values.map((c) {
                      final selected = settings.color == c;
                      return GestureDetector(
                        onTap: () => settings.setColor(c),
                        child: Column(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: c.seed,
                                shape: BoxShape.circle,
                                border: selected
                                    ? Border.all(color: scheme.onSurface, width: 2.5)
                                    : null,
                              ),
                              child: selected
                                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                                  : null,
                            ),
                            const SizedBox(height: 4),
                            Text(c.label, style: const TextStyle(fontSize: 11)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
          _SectionTitle('Notifikasi'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Jam Masuk & Istirahat',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Pengingat saat masuk kelas dan istirahat'),
                  value: settings.notifIstirahat,
                  onChanged: (v) async {
                    await settings.setNotifIstirahat(v);
                    await _reschedule(settings);
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Mapel Dimulai', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Notifikasi tiap pelajaran mulai'),
                  value: settings.notifMapel,
                  onChanged: (v) async {
                    await settings.setNotifMapel(v);
                    await _reschedule(settings);
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Piket Harian', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Pengingat piket jam 06:15'),
                  value: settings.notifPiket,
                  onChanged: (v) async {
                    await settings.setNotifPiket(v);
                    await _reschedule(settings);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          _SectionTitle('Tentang'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: scheme.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.school_rounded, color: scheme.primary),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text('Kelas XI RPL B',
                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text('Aplikasi jadwal & piket kelas',
                      style: TextStyle(fontSize: 13)),
                  const SizedBox(height: 14),
                  const Divider(),
                  const SizedBox(height: 6),
                  Text('Kelas', style: TextStyle(fontSize: 12, color: scheme.onSurface.withOpacity(0.5))),
                  const Text('XI RPL B', style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Text('Sekretaris',
                      style: TextStyle(fontSize: 12, color: scheme.onSurface.withOpacity(0.5))),
                  const Text('Wayan Gledy Alvreno', style: TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _reschedule(SettingsService settings) async {
    await NotificationService().scheduleAllUpcoming(
      notifMapel: settings.notifMapel,
      notifIstirahat: settings.notifIstirahat,
      notifPiket: settings.notifPiket,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10, top: 4),
      child: Text(text,
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5))),
    );
  }
}
