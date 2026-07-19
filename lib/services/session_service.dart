// Menentukan Sesi A/B berdasarkan tanggal.
// Anchor: Senin, 20 Juli 2026 adalah awal minggu Sesi A.
// Selanjutnya bergantian tiap minggu: A, B, A, B, ...

class SessionService {
  static final DateTime _anchorMonday = DateTime(2026, 7, 20);

  /// Mengembalikan awal minggu (Senin) dari tanggal [date].
  static DateTime startOfWeek(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    final diff = d.weekday - DateTime.monday; // Senin=1
    return d.subtract(Duration(days: diff));
  }

  /// Mengembalikan 'A' atau 'B' untuk minggu yang memuat [date].
  static String sesiUntukTanggal(DateTime date) {
    final monday = startOfWeek(date);
    final anchorMonday = DateTime(
        _anchorMonday.year, _anchorMonday.month, _anchorMonday.day);
    final diffWeeks = monday.difference(anchorMonday).inDays ~/ 7;
    // modulo bisa negatif di Dart untuk bilangan negatif, normalisasi ke 0/1:
    final normalized = ((diffWeeks % 2) + 2) % 2;
    return normalized == 0 ? 'A' : 'B';
  }
}
