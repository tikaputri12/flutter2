import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/category_bloc.dart';
import '../models/category_model.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  void initState() {
    super.initState();
    loadCategory();
  }

  Future<void> loadCategory() async {
    final token = await getToken();

    if (token != null) {
      context.read<CategoryBloc>().add(
        GetCategoryEvent(token: token),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Category CRUD")),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showForm(context);
        },
        child: const Icon(Icons.add),
      ),

      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {

          if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CategoryError) {
            return Center(child: Text(state.message));
          }

          if (state is CategoryLoaded) {
            return ListView.builder(
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final item = state.categories[index];

                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.description),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showForm(context, category: item);
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final token = await getToken();

                          if (token != null) {
                            context.read<CategoryBloc>().add(
                              DeleteCategoryEvent(
                                id: item.id,
                                token: token,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return const Center(child: Text("No Data"));
        },
      ),
    );
  }

  void _showForm(BuildContext context, {CategoryModel? category}) {
    final nameController =
        TextEditingController(text: category?.name ?? "");
    final descController =
        TextEditingController(text: category?.description ?? "");

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(category == null ? "Create" : "Edit"),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {
                final token = await getToken();
                if (token == null) return;

                final model = CategoryModel(
                  id: category?.id ?? 0,
                  name: nameController.text,
                  description: descController.text,
                );

                if (category == null) {
                  context.read<CategoryBloc>().add(
                    CreateCategoryEvent(
                      category: model,
                      token: token,
                    ),
                  );
                } else {
                  context.read<CategoryBloc>().add(
                    UpdateCategoryEvent(
                      id: category.id,
                      category: model,
                      token: token,
                    ),
                  );
                }

                Navigator.pop(context);
                loadCategory();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}