import 'package:flutter/material.dart';
import '../data/schedule_data.dart';
import '../services/session_service.dart';

class PiketScreen extends StatefulWidget {
  const PiketScreen({super.key});

  @override
  State<PiketScreen> createState() => _PiketScreenState();
}

class _PiketScreenState extends State<PiketScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final currentSesi = SessionService.sesiUntukTanggal(DateTime.now());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: currentSesi == 'A' ? 0 : 1,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Jadwal Piket',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w800)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('Minggu Ini: $currentSesi',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Minggu A'),
              Tab(text: 'Minggu B'),
            ],
            labelColor: scheme.primary,
            indicatorColor: scheme.primary,
            unselectedLabelColor: scheme.onSurface.withOpacity(0.5),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _PiketList(sesi: 'A'),
                _PiketList(sesi: 'B'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PiketList extends StatelessWidget {
  final String sesi;
  const _PiketList({required this.sesi});

  static const _icons = {
    1: Icons.looks_one_rounded,
    2: Icons.looks_two_rounded,
    3: Icons.looks_3_rounded,
    4: Icons.looks_4_rounded,
    5: Icons.looks_5_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final data = ScheduleData.piket[sesi]!;
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final weekday = index + 1;
        final names = data[weekday]!;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: scheme.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(_icons[weekday], color: scheme.primary, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ScheduleData.namaHari[weekday],
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                        const SizedBox(height: 2),
                        Text('${names.length} orang',
                            style: TextStyle(
                                fontSize: 12, color: scheme.onSurface.withOpacity(0.5))),
                        const SizedBox(height: 8),
                        ...names.map((n) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  Icon(Icons.circle,
                                      size: 5, color: scheme.onSurface.withOpacity(0.4)),
                                  const SizedBox(width: 8),
                                  Text(n, style: const TextStyle(fontSize: 13.5)),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
