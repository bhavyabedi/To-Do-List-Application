class ListItem {
  ListItem({
    required this.title,
    required this.description,
    this.completed = false,
  });

  final String title;
  final String description;
  bool completed;
}
