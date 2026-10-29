import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/note_model.dart';

class DetailNoteScreen extends StatefulWidget {
  final NoteModel note;

  const DetailNoteScreen({
    super.key,
    required this.note,
  });

  @override
  State<DetailNoteScreen> createState() => _DetailNoteScreenState();
}

class _DetailNoteScreenState extends State<DetailNoteScreen> {
  late bool _isCompleted;
  late String _title;
  late String _desc;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.note.isCompleted;
    _title = widget.note.title;
    _desc = widget.note.desc;
  }

  void _handleBack() {
    final updatedNote = widget.note.copyWith(
      title: _title,
      desc: _desc,
      isCompleted: _isCompleted,
    );
    Navigator.pop(context, {'action': 'update', 'note': updatedNote});
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Hapus Catatan?',
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A34)),
          ),
          content: const Text(
            'Apakah Anda yakin ingin menghapus catatan ini? Tindakan ini tidak dapat dibatalkan.',
            style: TextStyle(fontSize: 13, color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.black54)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE76F51),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pop(context); // close dialog
                Navigator.pop(context, {'action': 'delete', 'id': widget.note.id});
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _editNoteDialog() {
    final titleEditController = TextEditingController(text: _title);
    final descEditController = TextEditingController(text: _desc);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
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
              const Text(
                'Edit Catatan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A34),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: titleEditController,
                decoration: InputDecoration(
                  labelText: 'Judul',
                  filled: true,
                  fillColor: const Color(0xFFF8F9FA),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descEditController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Rincian Catatan',
                  filled: true,
                  fillColor: const Color(0xFFF8F9FA),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A34),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (titleEditController.text.trim().isNotEmpty) {
                      setState(() {
                        _title = titleEditController.text.trim();
                        _desc = descEditController.text.trim();
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Catatan berhasil diperbarui!'),
                          backgroundColor: Color(0xFF1E3A34),
                        ),
                      );
                    }
                  },
                  child: const Text('Simpan Perubahan', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _copyNoteContent() {
    Clipboard.setData(ClipboardData(text: '$_title\n\nMata Kuliah: ${widget.note.course}\n$_desc'));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Catatan berhasil disalin ke papan klip!'),
        backgroundColor: Color(0xFF1E3A34),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTugas = widget.note.type == 'Tugas';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF1E3A34),
              size: 20,
            ),
            onPressed: _handleBack,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.copy_rounded, color: Color(0xFF1E3A34), size: 20),
              tooltip: 'Salin Catatan',
              onPressed: _copyNoteContent,
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Color(0xFF1E3A34), size: 22),
              tooltip: 'Edit Catatan',
              onPressed: _editNoteDialog,
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Color(0xFFE76F51),
                size: 22,
              ),
              tooltip: 'Hapus Catatan',
              onPressed: _confirmDelete,
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
                  color: isTugas
                      ? const Color(0xFFFFF2EF)
                      : const Color(0xFFE8F3EE),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isTugas
                        ? const Color(0xFFE76F51).withValues(alpha: 0.3)
                        : const Color(0xFF52B788).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.note.isReminderActive
                          ? Icons.notifications_active_rounded
                          : Icons.notifications_off_outlined,
                      color: isTugas
                          ? const Color(0xFFE76F51)
                          : const Color(0xFF2D6A4F),
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isTugas
                                ? 'Batas Waktu Pengumpulan'
                                : 'Jadwal Agenda Kuliah',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isTugas
                                  ? const Color(0xFFC0392B)
                                  : const Color(0xFF1E3A34),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.note.deadline,
                            style: TextStyle(
                              fontSize: 12,
                              color: isTugas
                                  ? const Color(0xFFE76F51)
                                  : const Color(0xFF2D6A4F),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E3A34),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.note.course,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Text(
                          widget.note.type,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    widget.note.date,
                    style: const TextStyle(fontSize: 12, color: Colors.black45),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 3. JUDUL CATATAN
              Text(
                _title,
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
                  _desc,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.7,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 5. STATUS SELESAI / CHECKLIST
              InkWell(
                onTap: () {
                  setState(() => _isCompleted = !_isCompleted);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 1),
                      content: Text(
                        _isCompleted
                            ? 'Catatan/Tugas ditandai selesai!'
                            : 'Catatan/Tugas kembali aktif.',
                      ),
                      backgroundColor: _isCompleted
                          ? const Color(0xFF2D6A4F)
                          : const Color(0xFF1E3A34),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _isCompleted
                        ? const Color(0xFFE8F3EE)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _isCompleted
                          ? const Color(0xFF52B788)
                          : const Color(0xFFE5E7EB),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isCompleted
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: _isCompleted
                            ? const Color(0xFF2D6A4F)
                            : Colors.black45,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _isCompleted
                            ? 'Tugas / Materi Selesai Dipelajari'
                            : 'Tandai Sebagai Selesai',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _isCompleted
                              ? const Color(0xFF2D6A4F)
                              : Colors.black87,
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
      ),
    );
  }
}
