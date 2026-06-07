import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/category_bloc.dart';
import '../models/category_model.dart';

class DeleteCategoryPage extends StatelessWidget {

  final CategoryModel category;

  const DeleteCategoryPage({
    super.key,
    required this.category,
  });

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        title: const Text("Delete Category"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            const Text(
              "Category yang akan dihapus:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(16),
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Text(
                    category.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    category.description,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.redAccent,
                ),

                onPressed: () async {

                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text(
                        "Hapus Kategori",
                      ),
                      content: const Text(
                        "Apakah anda sudah yakin untuk menghapus kategori ini?",
                      ),
                      actions: [

                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context),
                          child:
                              const Text("Batal"),
                        ),

                        ElevatedButton(
                          onPressed: () async {

                            final token =
                                await getToken();

                            if (token != null &&
                                context.mounted) {

                              context
                                  .read<
                                      CategoryBloc>()
                                  .add(
                                    DeleteCategoryEvent(
                                      id: category.id,
                                      token: token,
                                    ),
                                  );
                            }

                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child:
                              const Text("Hapus"),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text(
                  "Delete Category",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}