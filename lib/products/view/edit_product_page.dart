import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/product_bloc.dart';

class EditProductPage extends StatefulWidget {
  final String token;
  final dynamic product;

  const EditProductPage({
    super.key,
    required this.token,
    required this.product,
  });

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late TextEditingController nameController;
  late TextEditingController descController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.product.name);
    descController = TextEditingController(text: widget.product.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: "Description"),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<ProductBloc>().add(
                        UpdateProductEvent(
                          token: widget.token,
                          id: widget.product.id,
                          name: nameController.text,
                          description: descController.text,

                          // 🔥 TAMBAHAN WAJIB (BIAR TIDAK ERROR API)
                          idCategory: widget.product.idCategory,
                          stock: widget.product.stock,
                          available: widget.product.available,
                          expired: widget.product.expired,
                        ),
                      );

                  Navigator.pop(context);
                },
                child: const Text("Update"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}