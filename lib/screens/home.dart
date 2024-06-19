import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/providers/list_items.dart';
import 'package:todolist/widgets.dart/addtodoitem.dart';
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

  @override
  void initState() {
    todoitemsFuture = ref.read(listItemsProvider.notifier).loadItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final todolist = ref.watch(listItemsProvider);

    return Scaffold(
      appBar: AppBar(
          title: const Text("To Do:"),
          backgroundColor: Theme.of(context).colorScheme.onPrimary),
      body: Container(
        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.6),
        child: FutureBuilder(
          future: todoitemsFuture,
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ToDoList(
                      todolist: todolist,
                    ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
