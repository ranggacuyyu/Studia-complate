import 'package:flutter/material.dart';

class DetailNoteScreen extends StatefulWidget {
  final String title;
  final String course;
  final String date;
  final String desc;
  final String type; // 'Materi' atau 'Tugas'
  final bool isReminderActive;
  final String deadline;

  const DetailNoteScreen({
    super.key,
    required this.title,
    required this.course,
    required this.date,
    required this.desc,
    this.type = 'Materi',
    this.isReminderActive = true,
    this.deadline = '28 Oktober 2026 • 23:59 WIB',
  });

  @override
  State<DetailNoteScreen> createState() => _DetailNoteScreenState();
}

class _DetailNoteScreenState extends State<DetailNoteScreen> {
  bool _isCompleted = false;

  @override
  Widget build(BuildContext context) {
    final isTugas = widget.type == 'Tugas';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E3A34), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Color(0xFF1E3A34), size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur edit catatan terbuka')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFE76F51), size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Catatan berhasil dihapus')),
              );
              Navigator.pop(context);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. BANNER STATUS NOTIFIKASI & AGENDA
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isTugas ? const Color(0xFFFFF2EF) : const Color(0xFFE8F3EE),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isTugas ? const Color(0xFFE76F51).withOpacity(0.3) : const Color(0xFF52B788).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.isReminderActive ? Icons.notifications_active_rounded : Icons.notifications_off_outlined,
                    color: isTugas ? const Color(0xFFE76F51) : const Color(0xFF2D6A4F),
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isTugas ? 'Batas Waktu Pengumpulan' : 'Jadwal Agenda Kuliah',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isTugas ? const Color(0xFFC0392B) : const Color(0xFF1E3A34),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.deadline,
                          style: TextStyle(
                            fontSize: 12,
                            color: isTugas ? const Color(0xFFE76F51) : const Color(0xFF2D6A4F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 2. BADGE KATEGORI & TANGGAL PEMBUATAN
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E3A34),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.course,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Text(
                        widget.type,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
                Text(
                  widget.date,
                  style: const TextStyle(fontSize: 12, color: Colors.black45),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 3. JUDUL CATATAN
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A34),
                height: 1.3,
              ),
            ),

            const Divider(height: 32, thickness: 1, color: Color(0xFFE5E7EB)),

            // 4. KONTEN / RINCIAN CATATAN
            const Text(
              'Rincian & Pembahasan',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black45,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Text(
                widget.desc,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.7,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 5. STATUS SELESAI / CHECKLIST TUGAS
            InkWell(
              onTap: () {
                setState(() => _isCompleted = !_isCompleted);
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _isCompleted ? const Color(0xFFE8F3EE) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _isCompleted ? const Color(0xFF52B788) : const Color(0xFFE5E7EB),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                      color: _isCompleted ? const Color(0xFF2D6A4F) : Colors.black45,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _isCompleted ? 'Tugas / Materi Selesai Dipelajari' : 'Tandai Sebagai Selesai',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _isCompleted ? const Color(0xFF2D6A4F) : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}