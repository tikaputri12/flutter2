import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/product_bloc.dart';
import '../models/product_model.dart';
import '../../categories/bloc/category_bloc.dart';

class EditProductPage extends StatefulWidget {
  final ProductModel product;

  const EditProductPage({
    super.key,
    required this.product,
  });

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController stockController;

  bool available = false;

  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();

    loadCategory();

    nameController =
        TextEditingController(text: widget.product.name);

    descriptionController =
        TextEditingController(text: widget.product.description);

    stockController =
        TextEditingController(text: widget.product.stock.toString());

    available = widget.product.available;

    selectedCategoryId = widget.product.idCategory;
  }

  Future<void> loadCategory() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (context.mounted) {
      context.read<CategoryBloc>().add(
            GetCategoryEvent(token: token),
          );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    stockController.dispose();
    super.dispose();
  }

  InputDecoration inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.deepPurple),
      ),
    );
  }

  Future<void> updateProduct() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    context.read<ProductBloc>().add(
          UpdateProductEvent(
            token: token,
            id: widget.product.id,
            idCategory: selectedCategoryId ?? widget.product.idCategory,
            name: nameController.text,
            description: descriptionController.text,
            stock: int.tryParse(stockController.text) ?? 0,
            available: available,
          ),
        );

    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pop(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Edit Product"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CategoryError) {
              return Center(child: Text(state.message));
            }

            if (state is CategoryLoaded) {
              final categories = state.categories;

              // FIX: pastikan selectedCategoryId valid
              final safeCategoryExists = categories
                  .any((c) => c.id == selectedCategoryId);

              if (!safeCategoryExists && categories.isNotEmpty) {
                selectedCategoryId = categories.first.id;
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: inputStyle("Name"),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: descriptionController,
                      decoration: inputStyle("Description"),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: stockController,
                      keyboardType: TextInputType.number,
                      decoration: inputStyle("Stock"),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonFormField<int>(
                        value: categories.any(
                          (c) => c.id == selectedCategoryId,
                        )
                            ? selectedCategoryId
                            : null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          labelText: "Category",
                        ),
                        items: categories.map((c) {
                          return DropdownMenuItem<int>(
                            value: c.id,
                            child: Text(c.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategoryId = value;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: SwitchListTile(
                        value: available,
                        title: const Text("Available"),
                        onChanged: (value) {
                          setState(() => available = value);
                        },
                      ),
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: updateProduct,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "UPDATE PRODUCT",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}