import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/category_bloc.dart';
import 'create_category.dart';
import 'edit_category_page.dart';
import 'delete_category_page.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() =>
      _CategoryViewState();
}

class _CategoryViewState
    extends State<CategoryView> {

  Future<String?> getToken() async {

    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString('token');
  }

  @override
  void initState() {
    super.initState();
    loadCategory();
  }

  Future<void> loadCategory() async {

    final token = await getToken();

    if (token != null && context.mounted) {

      context.read<CategoryBloc>().add(
            GetCategoryEvent(
              token: token,
            ),
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

      backgroundColor:
          const Color(0xFFF5F7FA),

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

          onPressed: () =>
              Navigator.pop(context),
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

      // ================= FLOATING BUTTON =================
      floatingActionButton:
          FloatingActionButton(

        backgroundColor:
            const Color(0xFF6C63FF),

        elevation: 3,

        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),

        onPressed: () {

          Navigator.push(
            context,

            MaterialPageRoute(
              builder: (_) =>
                  const CreateCategoryPage(),
            ),
          );
        },
      ),

      // ================= BODY =================
      body:
          BlocBuilder<CategoryBloc, CategoryState>(

        builder: (context, state) {

          // ================= LOADING =================
          if (state is CategoryLoading) {

            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF6C63FF),
              ),
            );
          }

          // ================= ERROR =================
          if (state is CategoryError) {

            return Center(
              child: Text(
                state.message,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            );
          }

          // ================= SUCCESS =================
          if (state is CategoryLoaded) {

            // EMPTY
            if (state.categories.isEmpty) {

              return const Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

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

            // ================= LIST =================
            return ListView.builder(

              padding:
                  const EdgeInsets.all(16),

              itemCount:
                  state.categories.length,

              itemBuilder: (context, index) {

                final item =
                    state.categories[index];

                final color =
                    _cardColor(index);

                return Container(

                  margin:
                      const EdgeInsets.only(
                    bottom: 14,
                  ),

                  padding:
                      const EdgeInsets.all(16),

                  decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(18),

                    boxShadow: [

                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.04),

                        blurRadius: 10,

                        offset:
                            const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Row(

                    children: [

                      // ================= ICON =================
                      Container(

                        width: 52,
                        height: 52,

                        decoration: BoxDecoration(
                          color:
                              color.withOpacity(
                            0.12,
                          ),

                          borderRadius:
                              BorderRadius.circular(
                            14,
                          ),
                        ),

                        child: Icon(
                          Icons.category_rounded,
                          color: color,
                          size: 26,
                        ),
                      ),

                      const SizedBox(width: 14),

                      // ================= CONTENT =================
                      Expanded(

                        child: Column(

                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            Text(
                              item.name,

                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                                fontSize: 16,
                                color:
                                    Color(0xFF2D2D2D),
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              item.description,

                              maxLines: 2,

                              overflow:
                                  TextOverflow.ellipsis,

                              style:
                                  const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ================= ACTION =================
                      Row(

                        children: [

                          // EDIT
                          IconButton(

                            icon: Icon(
                              Icons.edit_rounded,
                              color: color,
                            ),

                            onPressed: () {

                              Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder: (_) =>
                                      EditCategoryPage(
                                    category: item,
                                  ),
                                ),
                              );
                            },
                          ),

                          // DELETE
                          IconButton(

                            icon: const Icon(
                              Icons
                                  .delete_outline_rounded,

                              color:
                                  Colors.redAccent,
                            ),

                            onPressed: () {

                              Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder: (_) =>
                                      DeleteCategoryPage(
                                    category: item,
                                  ),
                                ),
                              );
                            },
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
}