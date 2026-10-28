import 'package:flutter/material.dart';

import 'detail_note_screen.dart';
import 'add_note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedAgendaTab = 0; // 0 = Hari Ini, 1 = Besok
  String _selectedFilter = 'Semua';

  // Data Dummy Notifikasi Agenda Kuliah & Tugas
  final List<Map<String, dynamic>> _agendaHariIni = [
    {
      'type': 'Kuliah',
      'title': 'Pemrograman Mobile (Praktikum)',
      'time': '08:00 - 10:30 WIB',
      'location': 'Lab Komputer 3',
      'isUrgent': false,
    },
    {
      'type': 'Tenggat Tugas',
      'title': 'Laporan Analisis Kebutuhan Sistem',
      'time': 'Batas: 23:59 WIB',
      'location': 'Portal E-Learning',
      'isUrgent': true,
    },
  ];

  final List<Map<String, dynamic>> _agendaBesok = [
    {
      'type': 'Kuliah',
      'title': 'Basis Data Lanjut',
      'time': '10:00 - 12:30 WIB',
      'location': 'Ruang Teori 401',
      'isUrgent': false,
    },
    {
      'type': 'Tenggat Tugas',
      'title': 'Kuis Online Arsitektur Komputer',
      'time': 'Batas: 17:00 WIB',
      'location': 'Portal Ujian',
      'isUrgent': false,
    },
  ];

  // Data Dummy Daftar Catatan
  final List<Map<String, String>> _notesList = [
    {
      'title': 'Arsitektur MVVM & State Management',
      'course': 'Pemrograman Mobile',
      'date': 'Hari ini, 09:15',
      'desc': 'Pemisahan business logic menggunakan provider/bloc agar widget tetap stateless dan mudah di-maintain.',
      'type': 'Materi',
    },
    {
      'title': 'Draft Revisi Perancangan Database',
      'course': 'Basis Data Lanjut',
      'date': 'Kemarin',
      'desc': 'Normalisasi tabel transaksi dan pembuatan relasi Foreign Key untuk modul order inventaris.',
      'type': 'Tugas',
    },
    {
      'title': 'Persiapan Topik Tugas Akhir',
      'course': 'Metodologi Penelitian',
      'date': '24 Okt 2026',
      'desc': 'Eksplorasi penggunaan framework Flutter untuk efisiensi sistem presensi berbasis lokasi geofencing.',
      'type': 'Materi',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final activeAgenda = _selectedAgendaTab == 0
        ? _agendaHariIni
        : _agendaBesok;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Halo, Mahasiswa',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A34),
              ),
            ),
            Text(
              'Semester 5 • Teknik Informatika',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: const Color(0xFFE8F3EE),
              child: IconButton(
                icon: const Icon(
                  Icons.notifications_active_outlined,
                  color: Color(0xFF1E3A34),
                  size: 22,
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          // 1. KOTAK FITUR UTAMA: NOTIFIKASI AGENDA KULIAH & TUGAS
          _buildAgendaNotificationSection(activeAgenda),

          const SizedBox(height: 24),

          // 2. SEARCH BAR
          TextField(
            decoration: InputDecoration(
              hintText: 'Cari catatan materi atau tugas...',
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: Colors.black45,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 3. FILTER CHIPS MATA KULIAH
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Semua'),
                _buildFilterChip('Pemrograman Mobile'),
                _buildFilterChip('Basis Data Lanjut'),
                _buildFilterChip('Metodologi Penelitian'),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 4. HEADER DAFTAR CATATAN
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Catatan Tersimpan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A34),
                ),
              ),
              Text(
                'Lihat Arsip',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF52B788),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 5. DAFTAR KARTU CATATAN
          ..._notesList.map((note) => _buildNoteCard(note)),
          const SizedBox(height: 60), // Beri ruang untuk FAB
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF1E3A34),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.edit_calendar_rounded),
        label: const Text(
          'Catatan Baru',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNoteScreen()),
          );
        },
      ),
    );
  }

  // WIDGET KARTU NOTIFIKASI AGENDA
  Widget _buildAgendaNotificationSection(
    List<Map<String, dynamic>> agendaList,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEAEAEA)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.event_note_rounded,
                    size: 20,
                    color: Color(0xFF1E3A34),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Agenda & Pengingat',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A34),
                    ),
                  ),
                ],
              ),
              // Segmented Tab Hari Ini / Besok
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    _buildAgendaTabBtn('Hari Ini', index: 0),
                    _buildAgendaTabBtn('Besok', index: 1),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...agendaList.map((agenda) {
            final isUrgent = agenda['isUrgent'] as bool;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUrgent
                    ? const Color(0xFFFFF2EF)
                    : const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isUrgent
                      ? const Color(0xFFE76F51).withOpacity(0.3)
                      : const Color(0xFFE5E7EB),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isUrgent
                          ? const Color(0xFFE76F51)
                          : const Color(0xFF1E3A34),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      agenda['type'] == 'Kuliah'
                          ? Icons.menu_book_rounded
                          : Icons.alarm_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          agenda['title'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isUrgent
                                ? const Color(0xFFC0392B)
                                : const Color(0xFF1E3A34),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${agenda['time']} • ${agenda['location']}',
                          style: TextStyle(
                            fontSize: 11,
                            color: isUrgent
                                ? const Color(0xFFE76F51)
                                : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAgendaTabBtn(String label, {required int index}) {
    final isSelected = _selectedAgendaTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedAgendaTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E3A34) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E3A34) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1E3A34)
                : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.white : const Color(0xFF1E3A34),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildNoteCard(Map<String, String> note) {
    final isTugas = note['type'] == 'Tugas';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isTugas
                    ? const Color(0xFFFFF2EF)
                    : const Color(0xFFE8F3EE),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                note['course']!,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isTugas
                      ? const Color(0xFFE76F51)
                      : const Color(0xFF2D6A4F),
                ),
              ),
            ),
            Text(
              note['date']!,
              style: const TextStyle(fontSize: 11, color: Colors.black45),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              note['title']!,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A34),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              note['desc']!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailNoteScreen(
                title: note['title']!,
                course: note['course']!,
                date: note['date']!,
                desc: note['desc']!,
                type: note['type']!,
                isReminderActive: true,
              ),
            ),
          );
        },
      ),
    );
  }
}
