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

  Color _cardColor(int index) {
    final colors = [
      const Color(0xFF6C63FF),
      const Color(0xFF43C6AC),
      const Color(0xFFFFB347),
      const Color(0xFF56CCF2),
      const Color(0xFFBB6BD9),
    ];

    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      // ================= APPBAR =================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF2D2D2D),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Category",
          style: TextStyle(
            color: Color(0xFF2D2D2D),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      // ================= FLOAT BUTTON =================
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6C63FF),
        elevation: 3,
        onPressed: () => _showForm(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),

      // ================= BODY =================
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {

          if (state is CategoryLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF6C63FF),
              ),
            );
          }

          if (state is CategoryError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is CategoryLoaded) {

            if (state.categories.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.folder_open_rounded,
                      size: 70,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Belum ada kategori",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.categories.length,
              itemBuilder: (context, index) {

                final item = state.categories[index];
                final color = _cardColor(index);

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [

                      // ICON
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.category_rounded,
                          color: color,
                          size: 26,
                        ),
                      ),

                      const SizedBox(width: 14),

                      // TEXT
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [

                            Text(
                              item.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF2D2D2D),
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              item.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ACTION BUTTON
                      Row(
                        children: [

                          IconButton(
                            onPressed: () =>
                                _showForm(context, category: item),
                            icon: Icon(
                              Icons.edit_rounded,
                              color: color,
                            ),
                          ),

                          IconButton(
                            onPressed: () =>
                                _confirmDelete(context, item),
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return const Center(
            child: Text("No Data"),
          );
        },
      ),
    );
  }

  // ================= DELETE =================
  void _confirmDelete(BuildContext context, CategoryModel item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text(
          "Hapus Kategori",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Yakin ingin menghapus "${item.name}"?',
        ),
        actions: [

          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () async {

              Navigator.pop(context);

              final token = await getToken();

              if (token != null && context.mounted) {
                context.read<CategoryBloc>().add(
                      DeleteCategoryEvent(
                        id: item.id,
                        token: token,
                      ),
                    );
              }
            },
            child: const Text(
              "Hapus",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ================= FORM =================
  void _showForm(BuildContext context, {CategoryModel? category}) {

    final nameController =
        TextEditingController(text: category?.name ?? "");

    final descController =
        TextEditingController(text: category?.description ?? "");

    showDialog(
      context: context,
      builder: (_) {

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Text(
                  category == null
                      ? "Tambah Kategori"
                      : "Edit Kategori",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Nama kategori",
                    prefixIcon: const Icon(
                      Icons.label_outline_rounded,
                      color: Color(0xFF6C63FF),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF5F7FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Deskripsi",
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 45),
                      child: Icon(
                        Icons.description_outlined,
                        color: Color(0xFF6C63FF),
                      ),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF5F7FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [

                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text("Batal"),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),

                        onPressed: () async {

                          final token = await getToken();

                          if (token == null) return;

                          final model = CategoryModel(
                            id: category?.id ?? 0,
                            name: nameController.text,
                            description: descController.text,
                          );

                          if (context.mounted) {

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
                          }
                        },

                        child: const Text(
                          "Simpan",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}