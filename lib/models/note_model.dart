class NoteModel {
  final String id;
  final String title;
  final String course;
  final String date;
  final String desc;
  final String type; // 'Materi' atau 'Tugas'
  final String deadline;
  final bool isCompleted;
  final bool isReminderActive;
  final String priority; // 'Rendah', 'Sedang', 'Tinggi'

  const NoteModel({
    required this.id,
    required this.title,
    required this.course,
    required this.date,
    required this.desc,
    this.type = 'Materi',
    this.deadline = 'Hari ini • 23:59 WIB',
    this.isCompleted = false,
    this.isReminderActive = true,
    this.priority = 'Sedang',
  });

  NoteModel copyWith({
    String? id,
    String? title,
    String? course,
    String? date,
    String? desc,
    String? type,
    String? deadline,
    bool? isCompleted,
    bool? isReminderActive,
    String? priority,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      course: course ?? this.course,
      date: date ?? this.date,
      desc: desc ?? this.desc,
      type: type ?? this.type,
      deadline: deadline ?? this.deadline,
      isCompleted: isCompleted ?? this.isCompleted,
      isReminderActive: isReminderActive ?? this.isReminderActive,
      priority: priority ?? this.priority,
    );
  }
}

