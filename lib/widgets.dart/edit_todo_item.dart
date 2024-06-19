import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/objects/item.dart';
import 'package:todolist/providers/list_items.dart';

// ignore: must_be_immutable
class EditToDoItemModal extends ConsumerStatefulWidget {
  EditToDoItemModal({
    required this.index,
    required this.title,
    required this.description,
    required this.category,
    super.key,
  });
  final int index;
  final String title;
  final String description;
  TaskCategory category;

  @override
  ConsumerState<EditToDoItemModal> createState() {
    return _EditToDoItemModalState();
  }
}

class _EditToDoItemModalState extends ConsumerState<EditToDoItemModal> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.description);
  }

  void _editTodoItem() {
    final title = _titleController.text;
    final description = _descriptionController.text;
    if (title.isNotEmpty && description.isNotEmpty) {
      ref.read(listItemsProvider.notifier).updateItem(
            widget.index,
            title,
            description,
            widget.category,
          );
      Navigator.of(context).pop();
    }
  }

  void _deleteTodoItem() {
    final title = _titleController.text;
    final description = _descriptionController.text;
    if (title.isNotEmpty && description.isNotEmpty) {
      ref.read(listItemsProvider.notifier).deleteItem(widget.index);
      Navigator.of(context).pop();
    }
  }

  String categoryToString(TaskCategory category) {
    switch (category) {
      case TaskCategory.work:
        return 'Work';
      case TaskCategory.personal:
        return 'Personal';
      case TaskCategory.family:
        return 'Family';
      case TaskCategory.others:
        return 'Others';
      default:
        throw ArgumentError('Invalid category: $category');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.6,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _titleController,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'To Do:',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Description:',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButton(
                    isExpanded: true,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary),
                    dropdownColor: Theme.of(context).colorScheme.onSecondary,
                    value: widget.category,
                    items: TaskCategory.values.map((category) {
                      return DropdownMenuItem<TaskCategory>(
                        value: category,
                        child: Text(
                          categoryToString(category),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        widget.category = newValue!;
                      });
                    }),
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: _editTodoItem,
                      child: const Text('Save'),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _deleteTodoItem,
                      child: const Text('Delete'),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
