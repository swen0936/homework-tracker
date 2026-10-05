class Assignment {
  final String title;
  final DateTime? dueDate;
  bool isCompleted;

  Assignment({
    required this.title,
    this.dueDate,
    this.isCompleted = false,
  });
}