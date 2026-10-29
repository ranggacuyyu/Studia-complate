import 'package:flutter/material.dart';

import '../models/agenda_model.dart';
import '../models/note_model.dart';
import 'add_note_screen.dart';
import 'detail_note_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedAgendaTab = 0; // 0 = Hari Ini, 1 = Besok
  String _selectedFilter = 'Semua';
  final TextEditingController _searchController = TextEditingController();

  // Data Agenda Kuliah & Tenggat Tugas
  final List<AgendaModel> _agendaList = const [
    AgendaModel(
      id: 'a1',
      type: 'Kuliah',
      title: 'Pemrograman Mobile (Praktikum)',
      time: '08:00 - 10:30 WIB',
      location: 'Lab Komputer 3',
      isUrgent: false,
      isTomorrow: false,
    ),
    AgendaModel(
      id: 'a2',
      type: 'Tenggat Tugas',
      title: 'Laporan Analisis Kebutuhan Sistem',
      time: 'Batas: 23:59 WIB',
      location: 'Portal E-Learning',
      isUrgent: true,
      isTomorrow: false,
    ),
    AgendaModel(
      id: 'a3',
      type: 'Kuliah',
      title: 'Basis Data Lanjut',
      time: '10:00 - 12:30 WIB',
      location: 'Ruang Teori 401',
      isUrgent: false,
      isTomorrow: true,
    ),
    AgendaModel(
      id: 'a4',
      type: 'Tenggat Tugas',
      title: 'Kuis Online Arsitektur Komputer',
      time: 'Batas: 17:00 WIB',
      location: 'Portal Ujian',
      isUrgent: false,
      isTomorrow: true,
    ),
  ];

  // Daftar Catatan & Tugas
  late List<NoteModel> _notesList;

  @override
  void initState() {
    super.initState();
    _notesList = [
      const NoteModel(
        id: '1',
        title: 'Arsitektur MVVM & State Management',
        course: 'Pemrograman Mobile',
        date: 'Hari ini, 09:15',
        desc:
            'Pemisahan business logic menggunakan provider/bloc agar widget tetap stateless, rapi, dan mudah diuji secara modular.',
        type: 'Materi',
        deadline: '28 Okt 2026 • 10:30 WIB',
        isCompleted: false,
        priority: 'Sedang',
      ),
      const NoteModel(
        id: '2',
        title: 'Draft Revisi Perancangan Database',
        course: 'Basis Data Lanjut',
        date: 'Kemarin',
        desc:
            'Normalisasi tabel transaksi (3NF) dan pembuatan relasi Foreign Key untuk modul inventaris barang kampus.',
        type: 'Tugas',
        deadline: '29 Okt 2026 • 23:59 WIB',
        isCompleted: false,
        priority: 'Tinggi',
      ),
      const NoteModel(
        id: '3',
        title: 'Persiapan Topik Tugas Akhir',
        course: 'Metodologi Penelitian',
        date: '24 Okt 2026',
        desc:
            'Eksplorasi penggunaan framework Flutter untuk efisiensi sistem presensi berbasis lokasi geofencing dan biometrik.',
        type: 'Materi',
        deadline: '30 Okt 2026 • 14:00 WIB',
        isCompleted: true,
        priority: 'Rendah',
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter Catatan Berdasarkan Query Pencarian & Chip Kategori
  List<NoteModel> get _filteredNotes {
    final query = _searchController.text.trim().toLowerCase();
    return _notesList.where((note) {
      final matchesSearch = query.isEmpty ||
          note.title.toLowerCase().contains(query) ||
          note.desc.toLowerCase().contains(query) ||
          note.course.toLowerCase().contains(query);

      final matchesFilter = _selectedFilter == 'Semua' ||
          note.course == _selectedFilter ||
          note.type == _selectedFilter;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  // Tambah Catatan Baru dari AddNoteScreen
  Future<void> _navigateToAddNote() async {
    final newNote = await Navigator.push<NoteModel>(
      context,
      MaterialPageRoute(builder: (context) => const AddNoteScreen()),
    );

    if (newNote != null) {
      setState(() {
        _notesList.insert(0, newNote);
      });
    }
  }

  // Buka Detail Catatan
  Future<void> _navigateToDetailNote(NoteModel note) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => DetailNoteScreen(note: note),
      ),
    );

    if (result != null) {
      if (!mounted) return;
      if (result['action'] == 'delete') {
        setState(() {
          _notesList.removeWhere((item) => item.id == result['id']);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Catatan berhasil dihapus'),
            backgroundColor: Color(0xFFE76F51),
          ),
        );
      } else if (result['action'] == 'update') {
        final updated = result['note'] as NoteModel;
        setState(() {
          final index = _notesList.indexWhere((item) => item.id == updated.id);
          if (index != -1) {
            _notesList[index] = updated;
          }
        });
      }
    }
  }

  // Modal Notifikasi & Agenda Terkini
  void _showNotificationSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Pusat Notifikasi & Pengingat',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A34),
                    ),
                  ),
                  Icon(Icons.done_all_rounded, size: 20, color: Color(0xFF52B788)),
                ],
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF2EF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.alarm_rounded,
                    color: Color(0xFFE76F51),
                    size: 20,
                  ),
                ),
                title: const Text(
                  'Tenggat Tugas: Laporan Analisis Kebutuhan',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  'Batas waktu hari ini 23:59 WIB di Portal E-Learning',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              const Divider(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F3EE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    color: Color(0xFF2D6A4F),
                    size: 20,
                  ),
                ),
                title: const Text(
                  'Praktikum Pemrograman Mobile Dimulai',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  'Pukul 08:00 WIB di Lab Komputer 3',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  // Modal Profil Mahasiswa & Opsi Logout
  void _showProfileSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final totalNotes = _notesList.length;
        final completedNotes =
            _notesList.where((n) => n.isCompleted).length;
        final pendingTasks =
            _notesList.where((n) => n.type == 'Tugas' && !n.isCompleted).length;

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 18),
              const CircleAvatar(
                radius: 34,
                backgroundColor: Color(0xFF1E3A34),
                child: Text(
                  'M',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Mahasiswa Teknik Informatika',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A34),
                ),
              ),
              const Text(
                'NIM: 2201082001 • Semester 5',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 20),

              // Rangkuman Statistik
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('Catatan', '$totalNotes'),
                    Container(height: 24, width: 1, color: Colors.black12),
                    _buildStatItem('Tugas Aktif', '$pendingTasks'),
                    Container(height: 24, width: 1, color: Colors.black12),
                    _buildStatItem('Selesai', '$completedNotes'),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Tombol Logout
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFFE76F51)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: Color(0xFFE76F51),
                    size: 20,
                  ),
                  label: const Text(
                    'Keluar dari Akun (Logout)',
                    style: TextStyle(
                      color: Color(0xFFE76F51),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Tutup bottom sheet
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E3A34),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.black54),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeAgenda = _agendaList
        .where((agenda) => agenda.isTomorrow == (_selectedAgendaTab == 1))
        .toList();

    final filtered = _filteredNotes;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: GestureDetector(
          onTap: _showProfileSheet,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Halo, Mahasiswa 👋',
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
        ),
        actions: [
          // Tombol Notifikasi
          CircleAvatar(
            backgroundColor: const Color(0xFFE8F3EE),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_active_outlined,
                color: Color(0xFF1E3A34),
                size: 20,
              ),
              tooltip: 'Notifikasi Agenda',
              onPressed: _showNotificationSheet,
            ),
          ),
          const SizedBox(width: 8),

          // Avatar Profil Mahasiswa
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: _showProfileSheet,
              child: const CircleAvatar(
                radius: 19,
                backgroundColor: Color(0xFF1E3A34),
                child: Text(
                  'M',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          // 1. KOTAK FITUR UTAMA: AGENDA KULIAH & TUGAS
          _buildAgendaNotificationSection(activeAgenda),

          const SizedBox(height: 22),

          // 2. SEARCH BAR DINAMIS
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Cari catatan materi atau tugas...',
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: Colors.black45,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                    )
                  : null,
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

          // 3. FILTER CHIPS MATA KULIAH & TIPE
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Semua'),
                _buildFilterChip('Tugas'),
                _buildFilterChip('Materi'),
                _buildFilterChip('Pemrograman Mobile'),
                _buildFilterChip('Basis Data Lanjut'),
                _buildFilterChip('Metodologi Penelitian'),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 4. HEADER DAFTAR CATATAN & JUMLAH DATA
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Catatan & Tugas (${filtered.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A34),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedFilter = 'Semua';
                    _searchController.clear();
                  });
                },
                child: const Text(
                  'Reset Filter',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF52B788),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 5. DAFTAR KARTU CATATAN ATAU EMPTY STATE
          if (filtered.isEmpty)
            _buildEmptyState()
          else
            ...filtered.map((note) => _buildNoteCard(note)),

          const SizedBox(height: 80), // Ruang ekstra untuk FAB
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
        onPressed: _navigateToAddNote,
      ),
    );
  }

  // WIDGET KARTU NOTIFIKASI AGENDA
  Widget _buildAgendaNotificationSection(List<AgendaModel> agendaList) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEAEAEA)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
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
            final isUrgent = agenda.isUrgent;
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
                      ? const Color(0xFFE76F51).withValues(alpha: 0.3)
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
                      agenda.type == 'Kuliah'
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
                          agenda.title,
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
                          '${agenda.time} • ${agenda.location}',
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

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFE8F3EE),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 40,
              color: Color(0xFF1E3A34),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Tidak Ada Catatan Ditemukan',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A34),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Coba sesuaikan kata kunci pencarian atau ganti filter kategori.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 14),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _searchController.clear();
                _selectedFilter = 'Semua';
              });
            },
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Tampilkan Semua Catatan'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(NoteModel note) {
    final isTugas = note.type == 'Tugas';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: note.isCompleted
              ? const Color(0xFF52B788).withValues(alpha: 0.4)
              : const Color(0xFFEAEAEA),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
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
                    note.course,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isTugas
                          ? const Color(0xFFE76F51)
                          : const Color(0xFF2D6A4F),
                    ),
                  ),
                ),
                if (note.isCompleted) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F3EE),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Selesai',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D6A4F),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            Text(
              note.date,
              style: const TextStyle(fontSize: 11, color: Colors.black45),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              note.title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: note.isCompleted
                    ? Colors.black45
                    : const Color(0xFF1E3A34),
                decoration:
                    note.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              note.desc,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Colors.black26,
          size: 20,
        ),
        onTap: () => _navigateToDetailNote(note),
      ),
    );
  }
}
