// Data jadwal statis untuk XI RPL B - SMK Negeri 3 Palu
// Sumber: Jadwal Siswa Sesi A & B, Juli 2026

class JamPelajaran {
  final int jamKe; // 0 = UP (upacara/jam awal Senin)
  final String mulai;
  final String selesai;
  final bool isIstirahat;

  const JamPelajaran(this.jamKe, this.mulai, this.selesai,
      {this.isIstirahat = false});
}

class MapelSlot {
  final int jamMulai; // jam ke berapa mulai
  final int jamAkhir; // jam ke berapa berakhir (inklusif)
  final String mapel;
  final String guru;

  const MapelSlot(this.jamMulai, this.jamAkhir, this.mapel, this.guru);
}

class ScheduleData {
  // ---------- JAM PELAJARAN PER HARI ----------
  // Senin: UP + 10 jam pelajaran, istirahat setelah jam ke-2 dan ke-6
  static const List<JamPelajaran> jamSenin = [
    JamPelajaran(0, '07:00', '08:00'), // UP
    JamPelajaran(1, '08:00', '08:45'),
    JamPelajaran(2, '08:45', '09:30'),
    JamPelajaran(-1, '09:30', '09:45', isIstirahat: true),
    JamPelajaran(3, '09:45', '10:30'),
    JamPelajaran(4, '10:30', '11:15'),
    JamPelajaran(5, '11:15', '12:00'),
    JamPelajaran(6, '12:00', '12:45'),
    JamPelajaran(-2, '12:45', '13:15', isIstirahat: true),
    JamPelajaran(7, '13:15', '14:00'),
    JamPelajaran(8, '14:00', '14:45'),
    JamPelajaran(9, '14:45', '15:30'),
    JamPelajaran(10, '15:30', '16:15'),
  ];

  // Selasa, Rabu, Kamis: 11 jam pelajaran, istirahat setelah jam ke-3 dan ke-7
  static const List<JamPelajaran> jamSelasaKamis = [
    JamPelajaran(1, '07:00', '07:45'),
    JamPelajaran(2, '07:45', '08:30'),
    JamPelajaran(3, '08:30', '09:15'),
    JamPelajaran(-1, '09:15', '09:30', isIstirahat: true),
    JamPelajaran(4, '09:30', '10:15'),
    JamPelajaran(5, '10:15', '11:00'),
    JamPelajaran(6, '11:00', '11:45'),
    JamPelajaran(7, '11:45', '12:30'),
    JamPelajaran(-2, '12:30', '13:15', isIstirahat: true),
    JamPelajaran(8, '13:15', '14:00'),
    JamPelajaran(9, '14:00', '14:45'),
    JamPelajaran(10, '14:45', '15:30'),
    JamPelajaran(11, '15:30', '16:15'),
  ];

  // Jumat: 5 jam pelajaran, tanpa istirahat tercatat di tabel
  static const List<JamPelajaran> jamJumat = [
    JamPelajaran(0, '07:00', '07:30'), // UP singkat
    JamPelajaran(1, '07:30', '08:00'),
    JamPelajaran(2, '08:00', '08:30'),
    JamPelajaran(3, '08:30', '09:00'),
    JamPelajaran(4, '09:00', '09:30'),
    JamPelajaran(5, '09:30', '10:00'),
  ];

  static List<JamPelajaran> jamUntukHari(int weekday) {
    // weekday: 1=Senin ... 7=Minggu
    switch (weekday) {
      case 1:
        return jamSenin;
      case 2:
      case 3:
      case 4:
        return jamSelasaKamis;
      case 5:
        return jamJumat;
      default:
        return [];
    }
  }

  // ---------- JADWAL MAPEL SESI A ----------
  // key: weekday (1=Senin..5=Jumat)
  static const Map<int, List<MapelSlot>> sesiA = {
    1: [
      // -x- di jam 1 (UP), kosong
      MapelSlot(2, 3, 'Sejarah', '120 Suraiya'),
      MapelSlot(4, 5, 'Mapel Pilihan', '58 Ilman Pradhana'),
      MapelSlot(6, 7, 'Bahasa Inggris', '87 Ni Made Dewi Artati'),
      MapelSlot(8, 9, 'Bahasa Indonesia', '82 Muhamad Hasan M. Halidi'),
    ],
    2: [
      MapelSlot(1, 3, 'Bahasa Indonesia', '82 Muhamad Hasan M. Halidi'),
      MapelSlot(4, 5, 'Sejarah', '120 Suraiya'),
      MapelSlot(6, 7, 'Bahasa Inggris', '87 Ni Made Dewi Artati'),
      MapelSlot(8, 9, 'Pendidikan Agama dan Budi Pekerti', '21 Asrina'),
    ],
    3: [
      MapelSlot(1, 3, 'Pendidikan Agama dan Budi Pekerti', '21 Asrina'),
      MapelSlot(4, 6, 'Matematika', '37 Elsa Fiolin Tunggai'),
      MapelSlot(7, 9, 'Mapel Pilihan', '58 Ilman Pradhana'),
      MapelSlot(10, 11, 'Pendidikan Pancasila', '22 Bambang'),
    ],
    4: [
      MapelSlot(1, 3, 'Mapel Pilihan', '58 Ilman Pradhana'),
      MapelSlot(4, 5, 'Pendidikan Pancasila', '22 Bambang'),
      MapelSlot(6, 7, 'Bahasa Inggris', '87 Ni Made Dewi Artati'),
      MapelSlot(8, 10, 'Matematika', '37 Elsa Fiolin Tunggai'),
    ],
    5: [
      MapelSlot(4, 5, 'Pendidikan Jasmani, Olah raga dan Kesehatan', ''),
      MapelSlot(6, 7, 'Pendidikan Jasmani, Olah raga dan Kesehatan', ''),
    ],
  };

  // ---------- JADWAL MAPEL SESI B ----------
  static const Map<int, List<MapelSlot>> sesiB = {
    1: [
      MapelSlot(2, 4, 'Pemrograman Perangkat Bergerak', '58 Ilman Pradhana'),
      MapelSlot(7, 8, 'Pemrograman Web', '132 Muh. Nur Rahmat'),
    ],
    2: [
      MapelSlot(1, 2,
          'Pemrograman Berbasis Teks, Grafis, dan Multimedia', '58 Ilman Pradhana'),
      MapelSlot(3, 6, 'Basis Data', '96 Ratna Ambar Widuri'),
      MapelSlot(7, 10, 'Kreativitas, Inovasi, dan Kewirausahaan', '104 Rugaiyah R. Nampu'),
    ],
    3: [
      MapelSlot(1, 3, 'Pemrograman Perangkat Bergerak', '58 Ilman Pradhana'),
      MapelSlot(4, 8, 'Kreativitas, Inovasi, dan Kewirausahaan', '104 Rugaiyah R. Nampu'),
    ],
    4: [
      MapelSlot(1, 4, 'Pemrograman Web', '132 Muh. Nur Rahmat'),
      MapelSlot(5, 7, 'Kreativitas, Inovasi, dan Kewirausahaan', '104 Rugaiyah R. Nampu'),
      MapelSlot(8, 10, 'Basis Data', '96 Ratna Ambar Widuri'),
    ],
    5: [
      MapelSlot(4, 7,
          'Pemrograman Berbasis Teks, Grafis, dan Multimedia', '58 Ilman Pradhana'),
    ],
  };

  static Map<int, List<MapelSlot>> jadwalUntukSesi(String sesi) {
    return sesi == 'A' ? sesiA : sesiB;
  }

  static const List<String> namaHari = [
    '', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'
  ];

  // ---------- PIKET ----------
  static const Map<String, Map<int, List<String>>> piket = {
    'A': {
      1: ['Adzan Ramadhan', 'Andriani', 'Mohamad Gibran Sinubu', 'Putri Naomi Bati'],
      2: ['Baraka Pratama', 'Aisya Putri Wulandar', 'Husen Fahmi Al-Amrie', 'Syifa Ismi Nurfaziah'],
      3: ['Andi Ikhwan Alfatih', 'Elloy Balenta Manu', 'Ismayanti'],
      4: ['Dian Pamula', 'Helmi Afraezel', 'Made Mulyana Krisna Putra'],
      5: ['Kafqa Shiddiq', 'Mohammad Fuad Maulana', 'Muh. Ikhsan Al Musawa'],
    },
    'B': {
      1: ['Vincent', 'Hayatul Qurania', 'Mohammad Irwandy'],
      2: ['Yusuf', 'Reval Ramadhan', 'Claudia Maninggir'],
      3: ['Reyhan Syahputra Indra', 'Rifka Mehrunisa', 'Moh. Afzhal Putra Abadi'],
      4: ['Tiara Oktoviani', 'Rafa Zaky Yunus', 'Muhammad Naufal Abyan'],
      5: ['Rizki Sihardika Pratama', 'Wayan Gledy Alvreno', 'Yuchitya Afri Pratna'],
    },
  };

  static List<String> piketUntuk(String sesi, int weekday) {
    return piket[sesi]?[weekday] ?? [];
  }
}
