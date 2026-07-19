import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/schedule_data.dart';
import '../services/session_service.dart';
import '../services/schedule_status.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final weekday = _now.weekday;
    final sesi = SessionService.sesiUntukTanggal(_now);
    final status = ScheduleStatus.getStatus(_now);
    final hariNama = ScheduleData.namaHari[weekday];
    final tanggalStr = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(_now);
    final jamStr = DateFormat('HH:mm:ss').format(_now);

    final mapelHariIni =
        weekday <= 5 ? (ScheduleData.jadwalUntukSesi(sesi)[weekday] ?? []) : [];
    final jamList = weekday <= 5 ? ScheduleData.jamUntukHari(weekday) : [];
    final piketHariIni =
        weekday <= 5 ? ScheduleData.piketUntuk(sesi, weekday) : <String>[];

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('XI RPL B',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text(tanggalStr,
                      style: TextStyle(color: scheme.onSurface.withOpacity(0.6))),
                ],
              ),
              _SesiBadge(sesi: sesi),
            ],
          ),
          const SizedBox(height: 20),

          // Kartu status utama
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [scheme.primary, scheme.primary.withOpacity(0.75)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(jamStr,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1)),
                const SizedBox(height: 8),
                Text(status.label,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600)),
                if (status.detail != null && status.detail!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(status.detail!,
                        style: TextStyle(color: Colors.white.withOpacity(0.85))),
                  ),
                if (status.next != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(status.next!,
                        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Piket & wali kelas-style row
          Row(
            children: [
              Expanded(
                child: _InfoCard(
                  icon: Icons.cleaning_services_rounded,
                  title: 'Piket Hari Ini',
                  color: Colors.blue,
                  child: piketHariIni.isEmpty
                      ? const Text('Libur Piket', style: TextStyle(fontWeight: FontWeight.w600))
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: piketHariIni
                              .map((n) => Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text(n,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600, fontSize: 13)),
                                  ))
                              .toList(),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _InfoCard(
                  icon: Icons.calendar_today_rounded,
                  title: 'Minggu Ke-',
                  color: Colors.purple,
                  child: Text(
                    '${_weekNumber(_now)}',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          Text('Jadwal Hari Ini',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),

          if (weekday > 5)
            _EmptyState(text: 'Hari ini libur, selamat beristirahat! 🎉')
          else if (mapelHariIni.isEmpty)
            const _EmptyState(text: 'Tidak ada jadwal mapel tercatat.')
          else
            ...mapelHariIni.map((slot) {
              final jamMulai = jamList.firstWhere(
                (j) => j.jamKe == slot.jamMulai,
                orElse: () => jamList.first,
              );
              final jamAkhir = jamList.firstWhere(
                (j) => j.jamKe == slot.jamAkhir,
                orElse: () => jamList.last,
              );
              final isNow = status.label == slot.mapel;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _MapelTile(
                  mapel: slot.mapel,
                  guru: slot.guru,
                  waktu: '${jamMulai.mulai} - ${jamAkhir.selesai}',
                  highlight: isNow,
                ),
              );
            }),
        ],
      ),
    );
  }

  int _weekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final days = date.difference(firstDayOfYear).inDays;
    return ((days + firstDayOfYear.weekday) / 7).ceil();
  }
}

class _SesiBadge extends StatelessWidget {
  final String sesi;
  const _SesiBadge({required this.sesi});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text('SESI $sesi',
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final Widget child;
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 10),
            Text(title,
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            child,
          ],
        ),
      ),
    );
  }
}

class _MapelTile extends StatelessWidget {
  final String mapel;
  final String guru;
  final String waktu;
  final bool highlight;
  const _MapelTile({
    required this.mapel,
    required this.guru,
    required this.waktu,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlight ? scheme.primary.withOpacity(0.1) : Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: highlight ? scheme.primary.withOpacity(0.4) : Colors.black.withOpacity(0.05),
          width: highlight ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: highlight ? scheme.primary : scheme.primary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(mapel,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                if (guru.isNotEmpty)
                  Text(guru,
                      style: TextStyle(
                          fontSize: 12.5, color: scheme.onSurface.withOpacity(0.55))),
              ],
            ),
          ),
          Text(waktu,
              style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface.withOpacity(0.6))),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String text;
  const _EmptyState({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(text, textAlign: TextAlign.center),
    );
  }
}
