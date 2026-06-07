import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/category_bloc.dart';
import '../models/category_model.dart';

class EditCategoryPage extends StatefulWidget {
  final CategoryModel category;

  const EditCategoryPage({
    super.key,
    required this.category,
  });

  @override
  State<EditCategoryPage> createState() =>
      _EditCategoryPageState();
}

class _EditCategoryPageState
    extends State<EditCategoryPage> {

  late TextEditingController nameController;
  late TextEditingController descController;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.category.name);

    descController =
        TextEditingController(
      text: widget.category.description,
    );
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        title: const Text("Edit Category"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Nama kategori",
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: descController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Deskripsi",
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {

                  final token = await getToken();

                  if (token == null) return;

                  final model = CategoryModel(
                    id: widget.category.id,
                    name: nameController.text,
                    description:
                        descController.text,
                  );

                  if (context.mounted) {

                    context
                        .read<CategoryBloc>()
                        .add(
                          UpdateCategoryEvent(
                            id: widget.category.id,
                            category: model,
                            token: token,
                          ),
                        );

                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text(
                          "Edit Kategori",
                        ),
                        content: const Text(
                          "Apakah anda yakin ingin mengedit kategori ini?",
                        ),
                        actions: [

                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context),
                            child:
                                const Text("Batal"),
                          ),

                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child:
                                const Text("Ya"),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const Text("Simpan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}