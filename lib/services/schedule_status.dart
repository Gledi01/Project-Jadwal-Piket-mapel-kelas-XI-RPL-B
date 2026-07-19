import '../data/schedule_data.dart';
import 'session_service.dart';

class CurrentStatus {
  final String label; // "Sedang: Matematika" / "Istirahat" / "Belum Masuk" / "Sudah Pulang" / "Libur"
  final String? detail; // guru, dsb
  final String? next; // info jam berikutnya
  const CurrentStatus(this.label, {this.detail, this.next});
}

class ScheduleStatus {
  static int _toMinutes(String hhmm) {
    final p = hhmm.split(':');
    return int.parse(p[0]) * 60 + int.parse(p[1]);
  }

  static CurrentStatus getStatus(DateTime now) {
    final weekday = now.weekday;
    if (weekday == 6 || weekday == 7) {
      return const CurrentStatus('Libur / Weekend');
    }

    final sesi = SessionService.sesiUntukTanggal(now);
    final jamList = ScheduleData.jamUntukHari(weekday);
    final mapelList = ScheduleData.jadwalUntukSesi(sesi)[weekday] ?? [];
    final nowMinutes = now.hour * 60 + now.minute;

    if (jamList.isEmpty) return const CurrentStatus('Libur');

    final firstMinutes = _toMinutes(jamList.first.mulai);
    final lastMinutes = _toMinutes(jamList.last.selesai);

    if (nowMinutes < firstMinutes) {
      return CurrentStatus('Belum Masuk',
          next: 'Masuk jam ${jamList.first.mulai}');
    }
    if (nowMinutes >= lastMinutes) {
      return const CurrentStatus('Sudah Pulang');
    }

    for (final jam in jamList) {
      final start = _toMinutes(jam.mulai);
      final end = _toMinutes(jam.selesai);
      if (nowMinutes >= start && nowMinutes < end) {
        if (jam.isIstirahat) {
          return CurrentStatus('Istirahat', next: 'Sampai jam ${jam.selesai}');
        }
        // cari mapel yang mencakup jam ke ini
        MapelSlot? current;
        for (final slot in mapelList) {
          if (jam.jamKe >= slot.jamMulai && jam.jamKe <= slot.jamAkhir) {
            current = slot;
            break;
          }
        }
        if (current != null) {
          return CurrentStatus(current.mapel,
              detail: current.guru, next: 'Sampai jam ${jam.selesai}');
        }
        return CurrentStatus('Jam ke-${jam.jamKe}', next: 'Sampai jam ${jam.selesai}');
      }
    }
    return const CurrentStatus('-');
  }
}
