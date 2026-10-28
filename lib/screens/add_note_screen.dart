import 'package:flutter/material.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  // Pilihan Tipe: Catatan Materi atau Tugas Kuliah
  int _selectedTypeIndex = 0; 
  String _selectedCourse = 'Pemrograman Mobile';
  String _selectedPriority = 'Sedang';
  bool _enableReminder = true;

  DateTime _selectedDate = DateTime(2026, 10, 28);
  TimeOfDay _selectedTime = const TimeOfDay(hour: 23, minute: 59);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  final List<String> _courseList = [
    'Pemrograman Mobile',
    'Basis Data Lanjut',
    'Metodologi Penelitian',
    'Arsitektur Komputer',
    'Rekayasa Perangkat Lunak',
  ];

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2026, 1, 1),
      lastDate: DateTime(2027, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1E3A34),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E3A34),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1E3A34),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E3A34),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() => _selectedTime = picked);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTugas = _selectedTypeIndex == 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E3A34), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tulis Catatan / Agenda',
          style: TextStyle(
            color: Color(0xFF1E3A34),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. SELECTOR TIPE CATATAN
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F3EE),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTypeSegmentBtn(
                      label: 'Catatan Kuliah',
                      icon: Icons.menu_book_rounded,
                      index: 0,
                    ),
                  ),
                  Expanded(
                    child: _buildTypeSegmentBtn(
                      label: 'Tugas & Deadline',
                      icon: Icons.assignment_rounded,
                      index: 1,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // 2. INPUT JUDUL CATATAN
            const Text(
              'Judul Catatan',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF1E3A34)),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: isTugas ? 'Contoh: Laporan Analisis Modul 3' : 'Contoh: Catatan Arsitektur MVVM',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // 3. PILIHAN MATA KULIAH
            const Text(
              'Mata Kuliah',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF1E3A34)),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _selectedCourse,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.class_outlined, color: Color(0xFF1E3A34), size: 20),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
              ),
              items: _courseList.map((course) {
                return DropdownMenuItem(value: course, child: Text(course, style: const TextStyle(fontSize: 14)));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedCourse = val);
              },
            ),

            const SizedBox(height: 18),

            // 4. JADWAL / DEADLINE & WAKTU
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isTugas ? 'Batas Pengumpulan' : 'Tanggal Agenda',
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF1E3A34)),
                      ),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: _pickDate,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined, size: 18, color: Color(0xFF1E3A34)),
                              const SizedBox(width: 8),
                              Text(
                                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Waktu / Jam',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF1E3A34)),
                      ),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: _pickTime,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time_rounded, size: 18, color: Color(0xFF1E3A34)),
                              const SizedBox(width: 8),
                              Text(
                                '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')} WIB',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // 5. PENGINGAT NOTIFIKASI (SWITCH)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F3EE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.notifications_active_rounded, color: Color(0xFF1E3A34), size: 20),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Pasang Notifikasi Pengingat',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E3A34)),
                          ),
                          Text(
                            'Ingatkan pada H-1 dan 2 jam sebelum',
                            style: TextStyle(fontSize: 11, color: Colors.black54),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Switch(
                    value: _enableReminder,
                    activeColor: const Color(0xFF1E3A34),
                    onChanged: (val) => setState(() => _enableReminder = val),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 6. TINGKAT PRIORITAS
            const Text(
              'Tingkat Urgensi',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF1E3A34)),
            ),
            const SizedBox(height: 8),
            Row(
              children: ['Rendah', 'Sedang', 'Tinggi (Mendesak)'].map((priority) {
                final isSelected = _selectedPriority == priority;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(priority),
                    selected: isSelected,
                    selectedColor: priority.contains('Tinggi') ? const Color(0xFFE76F51) : const Color(0xFF1E3A34),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: isSelected ? Colors.transparent : const Color(0xFFE5E7EB)),
                    labelStyle: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    onSelected: (_) => setState(() => _selectedPriority = priority),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 18),

            // 7. ISI CATATAN / INSTRUKSI
            const Text(
              'Rincian Catatan / Instruksi Tugas',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF1E3A34)),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _descController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Tuliskan poin-poin materi atau instruksi pengumpulan tugas di sini...',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // 8. TOMBOL SIMPAN
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A34),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                icon: const Icon(Icons.save_rounded, color: Colors.white, size: 20),
                label: const Text(
                  'Simpan Agenda & Catatan',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Catatan & notifikasi berhasil dijadwalkan!'),
                      backgroundColor: Color(0xFF1E3A34),
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSegmentBtn({required String label, required IconData icon, required int index}) {
    final isSelected = _selectedTypeIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTypeIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E3A34) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: isSelected ? Colors.white : const Color(0xFF1E3A34)),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF1E3A34),
              ),
            ),
          ],
        ),
      ),
    );
  }
}