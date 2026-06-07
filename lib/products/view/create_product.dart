import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/product_bloc.dart';

class CreateProductPage extends StatefulWidget {
  final String token;

  const CreateProductPage({
    super.key,
    required this.token,
  });

  @override
  State<CreateProductPage> createState() =>
      _CreateProductPageState();
}

class _CreateProductPageState
    extends State<CreateProductPage> {

  final nameController = TextEditingController();
  final descController = TextEditingController();
  final stockController = TextEditingController();

  final categoryController =
      TextEditingController(text: "276");

  bool available = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        title: const Text("Create Product"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            TextField(
              controller: categoryController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Category ID",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Product Name",
                filled: true,
                fillColor: Colors.white,
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
                labelText: "Description",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Stock",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 16),

            SwitchListTile(
              value: available,
              title: const Text("Available"),
              onChanged: (value) {
                setState(() {
                  available = value;
                });
              },
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                ),

                onPressed: () {

                  context.read<ProductBloc>().add(
                        CreateProductEvent(
                          token: widget.token,
                          idCategory: int.parse(
                            categoryController.text,
                          ),
                          name: nameController.text,
                          description:
                              descController.text,
                          available: available,
                          stock: int.parse(
                            stockController.text,
                          ),
                          expired: null,
                        ),
                      );

                  Navigator.pop(context);
                },

                child: const Text(
                  "Create Product",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}