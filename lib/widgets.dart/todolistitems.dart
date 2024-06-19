import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/objects/item.dart';
import 'package:todolist/providers/list_items.dart';
import 'package:todolist/widgets.dart/edittodoitem.dart';
import 'package:vibration/vibration.dart';

class ToDoList extends ConsumerWidget {
  const ToDoList({
    super.key,
    required this.todolist,
  });
  final List<ListItem> todolist;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void handleLongPressVibration() async {
      bool? hasVibration = await Vibration.hasVibrator();
      if (hasVibration!) {
        Vibration.vibrate(duration: 200);
      }
    }

    if (todolist.isEmpty) {
      return Center(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Text(
              'Woo Hoo! You\'re all done!',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 17,
                  ),
            ),
          ],
        ),
      );
    } else {
      return ListView.builder(
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.only(top: 2),
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).colorScheme.onSecondary.withOpacity(0.5)
              : Theme.of(context).colorScheme.primary.withOpacity(0.1),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: GestureDetector(
              onLongPress: () {
                handleLongPressVibration();
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return EditToDoItemModal(
                      index: index,
                      title: todolist[index].title,
                      description: todolist[index].description,
                      category: todolist[index].category,
                    );
                  },
                );
              },
              child: CheckboxListTile(
                // tileColor: Theme.of(context).colorScheme.onPrimary,
                value: todolist[index].completed,
                onChanged: (value) {
                  if (value == true) {
                    _showCompletionConfirmationDialog(context, ref, index);
                  } else {
                    ref.read(listItemsProvider.notifier).toggleCompleted(index);
                    todolist[index].completed = !todolist[index].completed;
                  }
                },
                title: Text(
                  todolist[index].title.toUpperCase(),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                ),
                subtitle: Text(
                  todolist[index].description.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                ),
              ),
            ),
          ),
        ),
        itemCount: todolist.length,
      );
    }
  }

  void _showCompletionConfirmationDialog(
      BuildContext context, WidgetRef ref, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Completion'),
          content: const Text(
              'Are you sure you want to mark this task as completed? The Task will be deleted once you do.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                ref.read(listItemsProvider.notifier).toggleCompleted(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
