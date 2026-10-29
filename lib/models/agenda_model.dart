class AgendaModel {
  final String id;
  final String type; // 'Kuliah' atau 'Tenggat Tugas'
  final String title;
  final String time;
  final String location;
  final bool isUrgent;
  final bool isTomorrow;

  const AgendaModel({
    required this.id,
    required this.type,
    required this.title,
    required this.time,
    required this.location,
    this.isUrgent = false,
    this.isTomorrow = false,
  });
}

