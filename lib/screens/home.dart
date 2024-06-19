import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/objects/item.dart';
import 'package:todolist/providers/list_items.dart';
import 'package:todolist/widgets.dart/add_todo_item.dart';
import 'package:todolist/widgets.dart/todolistitems.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Future<void> todoitemsFuture;
  TaskCategory? selectedCategory; // New variable to hold selected category

  bool showCompleted = false;
  @override
  void initState() {
    todoitemsFuture = ref.read(listItemsProvider.notifier).loadItems();
    super.initState();
  }

  List<ListItem> filterByCategory(
      List<ListItem> list, TaskCategory? category, bool completed) {
    if (completed) {
      return list.where((item) => item.completed).toList();
    } else if (category == null) {
      return list.where((item) => !item.completed).toList();
    } else {
      return list
          .where((item) => item.category == category && !item.completed)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final todolist = ref.watch(listItemsProvider);
    List<ListItem> filteredList =
        filterByCategory(todolist, selectedCategory, showCompleted);

    return Scaffold(
      appBar: AppBar(
        title: const Text("To Do:"),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                      child: SizedBox(
                        height: 300,
                        width: 400,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          child: RichText(
                            text: TextSpan(
                                text: "To Do: A Task Tracking App.\n",
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontSize: 20,
                                ),
                                children: [
                                  TextSpan(
                                    text: "\n1. Touch and Hold to Edit a Task.",
                                    style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      fontSize: 15,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        "\n2. It confirms with you if the task is completed, then it is put in the Completed Tab.",
                                    style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      fontSize: 15,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        "\n3. The app will adjust to your device Theme. So if you want to try the other, close the app or not, and change your device theme(Light/Dark)",
                                    style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      fontSize: 15,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        "\n4. Completed Tasks can be seen on the last category.",
                                    style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      fontSize: 15,
                                    ),
                                  )
                                ]),
                          ),
                        ),
                      ));
                },
              );
            },
            icon: const Icon(Icons.help),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.6),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedCategory = null;
                        showCompleted = false;
                        filteredList = filterByCategory(
                            todolist, selectedCategory, showCompleted);
                      });
                    },
                    style: ButtonStyle(
                      elevation: const WidgetStatePropertyAll(7),
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                        return selectedCategory == null && !showCompleted
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(0.6);
                      }),
                    ),
                    child: const Text('All'),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedCategory = TaskCategory.personal;
                        showCompleted = false;
                        filteredList = filterByCategory(
                            todolist, selectedCategory, showCompleted);
                      });
                    },
                    style: ButtonStyle(
                      elevation: const WidgetStatePropertyAll(7),
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                        return selectedCategory == TaskCategory.personal &&
                                !showCompleted
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(0.6);
                      }),
                    ),
                    child: const Text('Personal'),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedCategory = TaskCategory.work;
                        showCompleted = false;
                        filteredList = filterByCategory(
                            todolist, selectedCategory, showCompleted);
                      });
                    },
                    style: ButtonStyle(
                      elevation: const WidgetStatePropertyAll(7),
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                        return selectedCategory == TaskCategory.work &&
                                !showCompleted
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(0.6);
                      }),
                    ),
                    child: const Text('Work'),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showCompleted = false;
                        selectedCategory = TaskCategory.family;
                        filteredList = filterByCategory(
                            todolist, selectedCategory, showCompleted);
                      });
                    },
                    style: ButtonStyle(
                      elevation: const WidgetStatePropertyAll(7),
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                        return selectedCategory == TaskCategory.family &&
                                !showCompleted
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(0.6);
                      }),
                    ),
                    child: const Text('Family'),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedCategory = TaskCategory.others;
                        showCompleted = false;
                        filteredList = filterByCategory(
                            todolist, selectedCategory, showCompleted);
                      });
                    },
                    style: ButtonStyle(
                      elevation: const WidgetStatePropertyAll(7),
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                        return selectedCategory == TaskCategory.others &&
                                !showCompleted
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(0.6);
                      }),
                    ),
                    child: const Text('Others'),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showCompleted = true;
                        selectedCategory = null;
                        filteredList = filterByCategory(
                            todolist, selectedCategory, showCompleted);
                      });
                    },
                    style: ButtonStyle(
                      elevation: const WidgetStatePropertyAll(7),
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                        return showCompleted
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(0.6);
                      }),
                    ),
                    child: const Text('Completed.'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.6),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: FutureBuilder(
                  future: todoitemsFuture,
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ToDoList(
                              todolist: filteredList,
                              showCompleted: showCompleted,
                            ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.onTertiary,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return const AddTodoItemModal();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
