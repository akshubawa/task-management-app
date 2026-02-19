/// Request body for POST /tasks. dueDate format: MM-DD-YYYY (e.g. 03-03-2026).
class CreateTaskBody {
  CreateTaskBody({
    required this.title,
    required this.priority,
    this.dueDate,
  });

  final String title;
  final String priority;
  final String? dueDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'title': title,
      'priority': priority,
    };
    if (dueDate != null && dueDate!.isNotEmpty) {
      map['dueDate'] = dueDate;
    }
    return map;
  }
}
