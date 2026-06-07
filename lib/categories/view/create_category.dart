import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/category_bloc.dart';
import '../models/category_model.dart';

class CreateCategoryPage extends StatefulWidget {
  const CreateCategoryPage({super.key});

  @override
  State<CreateCategoryPage> createState() =>
      _CreateCategoryPageState();
}

class _CreateCategoryPageState
    extends State<CreateCategoryPage> {

  final nameController =
      TextEditingController();

  final descController =
      TextEditingController();

  Future<String?> getToken() async {

    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFFF5F7FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          "Create Category",
          style: TextStyle(
            color: Color(0xFF2D2D2D),
            fontWeight: FontWeight.bold,
          ),
        ),

        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            // ================= NAME =================
            TextField(
              controller: nameController,

              decoration: InputDecoration(

                hintText: "Nama kategori",

                prefixIcon: const Icon(
                  Icons.category_rounded,
                  color: Color(0xFF6C63FF),
                ),

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(16),

                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ================= DESCRIPTION =================
            TextField(
              controller: descController,
              maxLines: 4,

              decoration: InputDecoration(

                hintText: "Deskripsi kategori",

                prefixIcon: const Padding(
                  padding:
                      EdgeInsets.only(bottom: 70),

                  child: Icon(
                    Icons.description_rounded,
                    color: Color(0xFF6C63FF),
                  ),
                ),

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(16),

                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ================= BUTTON =================
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF6C63FF),

                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 16,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                ),

                onPressed: () async {

                  final token =
                      await getToken();

                  if (token == null) return;

                  final category =
                      CategoryModel(
                    id: 0,
                    name:
                        nameController.text,
                    description:
                        descController.text,
                  );

                  if (context.mounted) {

                    context
                        .read<CategoryBloc>()
                        .add(
                          CreateCategoryEvent(
                            category: category,
                            token: token,
                          ),
                        );

                    Navigator.pop(context);
                  }
                },

                child: const Text(
                  "Create Category",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}