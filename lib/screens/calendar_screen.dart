import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../data/schedule_data.dart';
import '../services/session_service.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final weekday = _selectedDay.weekday;
    final isWeekend = weekday == 6 || weekday == 7;
    final sesi = SessionService.sesiUntukTanggal(_selectedDay);
    final mapelList = isWeekend ? <MapelSlot>[] : (ScheduleData.jadwalUntukSesi(sesi)[weekday] ?? []);
    final jamList = isWeekend ? <JamPelajaran>[] : ScheduleData.jamUntukHari(weekday);
    final piketList = isWeekend ? <String>[] : ScheduleData.piketUntuk(sesi, weekday);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('Kalender Jadwal',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TableCalendar(
                locale: 'id_ID',
                firstDay: DateTime(2026, 1, 1),
                lastDay: DateTime(2027, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                onDaySelected: (selected, focused) {
                  setState(() {
                    _selectedDay = selected;
                    _focusedDay = focused;
                  });
                },
                calendarFormat: CalendarFormat.month,
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: scheme.primary.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: scheme.primary,
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: TextStyle(color: scheme.error.withOpacity(0.7)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(_selectedDay),
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
              if (!isWeekend)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('SESI $sesi',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                ),
            ],
          ),
          const SizedBox(height: 14),

          if (isWeekend)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text('Libur ini Ntod, Hari minggu',
                  textAlign: TextAlign.center),
            )
          else ...[
            if (piketList.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue.withOpacity(0.2)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.cleaning_services_rounded,
                        color: Colors.blue, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Piket:',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                          const SizedBox(height: 2),
                          Text(piketList.join(', '), style: const TextStyle(fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],
            ...mapelList.map((slot) {
              final jamMulai = jamList.firstWhere(
                (j) => j.jamKe == slot.jamMulai,
                orElse: () => jamList.first,
              );
              final jamAkhir = jamList.firstWhere(
                (j) => j.jamKe == slot.jamAkhir,
                orElse: () => jamList.last,
              );
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.black.withOpacity(0.05)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 40,
                        decoration: BoxDecoration(
                          color: scheme.primary.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(slot.mapel,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 15)),
                            if (slot.guru.isNotEmpty)
                              Text(slot.guru,
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      color: scheme.onSurface.withOpacity(0.55))),
                          ],
                        ),
                      ),
                      Text('${jamMulai.mulai} - ${jamAkhir.selesai}',
                          style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: scheme.onSurface.withOpacity(0.6))),
                    ],
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}
