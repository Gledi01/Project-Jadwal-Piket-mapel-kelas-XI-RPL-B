import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;
import '../data/schedule_data.dart';
import 'session_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  static const _channelMapel = AndroidNotificationDetails(
    'mapel_channel',
    'Pengingat Pelajaran',
    channelDescription: 'Notifikasi jam pelajaran dan istirahat',
    importance: Importance.high,
    priority: Priority.high,
  );

  static const _channelPiket = AndroidNotificationDetails(
    'piket_channel',
    'Pengingat Piket',
    channelDescription: 'Notifikasi jadwal piket harian',
    importance: Importance.high,
    priority: Priority.high,
  );

  Future<void> init() async {
    if (_initialized) return;
    tzdata.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation('Asia/Makassar')); // WITA - Palu
    } catch (_) {
      // fallback ke UTC+8 manual jika lokasi tidak ditemukan
    }

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _plugin.initialize(initSettings);

    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.requestNotificationsPermission();
    await androidImpl?.requestExactAlarmsPermission();

    _initialized = true;
  }

  int _idFor(String prefix, int dayOffset, int slot) {
    // ID unik: kategori (2 digit) + hari offset 0-13 (2 digit) + slot (sisa digit)
    final catCode = prefix.hashCode.abs() % 90 + 1; // 1-90
    return catCode * 100000 + dayOffset * 1000 + (slot.abs() % 1000);
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  /// Menjadwalkan seluruh notifikasi untuk 14 hari ke depan
  /// (agar mencakup pergantian sesi A/B dan tetap ringan).
  Future<void> scheduleAllUpcoming({
    required bool notifMapel,
    required bool notifIstirahat,
    required bool notifPiket,
  }) async {
    await cancelAll();
    final now = DateTime.now();

    for (int i = 0; i < 14; i++) {
      final date = DateTime(now.year, now.month, now.day).add(Duration(days: i));
      final weekday = date.weekday;
      if (weekday == 6 || weekday == 7) continue; // Sabtu/Minggu libur

      final sesi = SessionService.sesiUntukTanggal(date);
      final jamList = ScheduleData.jamUntukHari(weekday);
      final mapelList = ScheduleData.jadwalUntukSesi(sesi)[weekday] ?? [];

      // --- Notif jam masuk & istirahat ---
      if (notifIstirahat) {
        int istSlot = 0;
        for (final jam in jamList) {
          if (jam.isIstirahat) {
            istSlot++;
            await _scheduleAt(
              id: _idFor('ist', i, istSlot),
              date: date,
              time: jam.mulai,
              title: '🍽️ Waktunya Istirahat',
              body: 'Istirahat sampai jam ${jam.selesai}. Selamat rehat sejenak!',
              details: _channelMapel,
            );
          }
        }
        // Notif jam masuk (jam pertama hari itu)
        if (jamList.isNotEmpty) {
          final first = jamList.first;
          await _scheduleAt(
            id: _idFor('masuk', i, 0),
            date: date,
            time: first.mulai,
            title: '🏫 Waktunya Masuk Kelas',
            body: 'Hari ${ScheduleData.namaHari[weekday]}, Sesi $sesi dimulai sekarang.',
            details: _channelMapel,
          );
        }
      }

      // --- Notif tiap mapel mulai (1 detik setelah jam mulai) ---
      if (notifMapel) {
        int mapelSlot = 0;
        for (final slot in mapelList) {
          mapelSlot++;
          final jamMulaiObj = jamList.firstWhere(
            (j) => j.jamKe == slot.jamMulai,
            orElse: () => jamList.isNotEmpty ? jamList.first : const JamPelajaran(1, '07:00', '07:00'),
          );
          await _scheduleAt(
            id: _idFor('mapel', i, mapelSlot),
            date: date,
            time: jamMulaiObj.mulai,
            title: '📚 ${slot.mapel}',
            body: slot.guru.isNotEmpty
                ? 'Pelajaran dimulai — ${slot.guru}'
                : 'Pelajaran dimulai sekarang',
            details: _channelMapel,
            extraSeconds: 1,
          );
        }
      }

      // --- Notif piket jam 06:15 ---
      if (notifPiket) {
        final anggotaPiket = ScheduleData.piketUntuk(sesi, weekday);
        if (anggotaPiket.isNotEmpty) {
          await _scheduleAt(
            id: _idFor('piket', i, 0),
            date: date,
            time: '06:15',
            title: '🧹 Jadwal Piket Hari Ini',
            body: 'Minggu $sesi: ${anggotaPiket.join(", ")}',
            details: _channelPiket,
          );
        }
      }
    }
  }

  Future<void> _scheduleAt({
    required int id,
    required DateTime date,
    required String time, // format "HH:mm"
    required String title,
    required String body,
    required AndroidNotificationDetails details,
    int extraSeconds = 0,
  }) async {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    var scheduled = tz.TZDateTime(
      tz.local,
      date.year,
      date.month,
      date.day,
      hour,
      minute,
    ).add(Duration(seconds: extraSeconds));

    // Skip jika waktu sudah lewat
    final nowTz = tz.TZDateTime.now(tz.local);
    if (scheduled.isBefore(nowTz)) return;

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      NotificationDetails(android: details),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
