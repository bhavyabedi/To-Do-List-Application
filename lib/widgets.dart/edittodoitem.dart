import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/providers/list_items.dart';

class EditToDoItemModal extends ConsumerStatefulWidget {
  const EditToDoItemModal({
    required this.index,
    required this.title,
    required this.description,
    super.key,
  });
  final int index;
  final String title;
  final String description;

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
      ref
          .read(listItemsProvider.notifier)
          .updateItem(widget.index, title, description);
      Navigator.of(context).pop(); // Close the modal
    }
  }

  void _deleteTodoItem() {
    final title = _titleController.text;
    final description = _descriptionController.text;
    if (title.isNotEmpty && description.isNotEmpty) {
      ref.read(listItemsProvider.notifier).deleteItem(widget.index);
      Navigator.of(context).pop(); // Close the modal
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
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description:',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
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
