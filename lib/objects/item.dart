enum TaskCategory {
  work,
  personal,
  family,
  others,
}

class ListItem {
  ListItem({
    required this.title,
    required this.description,
    required this.category,
    this.completed = false,
  });
  final TaskCategory category;
  final String title;
  final String description;

  bool completed;
}
