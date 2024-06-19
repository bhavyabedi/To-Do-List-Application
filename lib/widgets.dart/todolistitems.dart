import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/objects/item.dart';
import 'package:todolist/providers/list_items.dart';
import 'package:todolist/widgets.dart/edit_todo_item.dart';
import 'package:vibration/vibration.dart';

class ToDoList extends ConsumerWidget {
  const ToDoList({
    super.key,
    required this.todolist,
    required this.showCompleted,
  });
  final List<ListItem> todolist;
  final bool showCompleted;

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
              showCompleted
                  ? "No Completed Tasks. Better get to it!"
                  : 'Woo Hoo! You\'re all done!',
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
        itemBuilder: (context, index) => Dismissible(
          key: Key(todolist[index].title), // Ensure each item has a unique key
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {
            ref.read(listItemsProvider.notifier).deleteItem(index);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Task "${todolist[index].title}" deleted')),
            );
          },
          child: Container(
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
                  value: todolist[index].completed,
                  onChanged: (value) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(value!
                            ? 'Task Marked Completed'
                            : 'Task Marked Imcomplete'),
                      ),
                    );
                    ref
                        .read(listItemsProvider.notifier)
                        .toggleCompleted(index, todolist[index].title, value);
                    todolist[index].completed = !todolist[index].completed;
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
        ),
        itemCount: todolist.length,
      );
    }
  }
}
