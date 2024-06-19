import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/objects/item.dart';
import 'package:todolist/providers/list_items.dart';

class AddTodoItemModal extends ConsumerStatefulWidget {
  const AddTodoItemModal({super.key});

  @override
  ConsumerState<AddTodoItemModal> createState() {
    return _AddTodoItemModalState();
  }
}

class _AddTodoItemModalState extends ConsumerState<AddTodoItemModal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  TaskCategory _selectedCategory = TaskCategory.personal;

  void _addTodoItem() {
    final title = _titleController.text;
    final description = _descriptionController.text;
    if (title.isNotEmpty && description.isNotEmpty) {
      ref.read(listItemsProvider.notifier).addItem(
            title,
            description,
            _selectedCategory,
          );
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
                  decoration: const InputDecoration(
                    labelText: 'To Do:',
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
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
                    value: _selectedCategory,
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
                        _selectedCategory = newValue!;
                      });
                    }),
                ElevatedButton(
                  onPressed: _addTodoItem,
                  child: const Text('Add'),
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
