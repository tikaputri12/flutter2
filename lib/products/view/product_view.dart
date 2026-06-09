import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/product_bloc.dart';
import 'create_product.dart';
import 'edit_product_page.dart';
import 'delete_product_page.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  String selectedCategory = "Semua";
  String searchQuery = "";

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && context.mounted) {
      context.read<ProductBloc>().add(
            GetProductEvent(token: token),
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

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Products",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token') ?? '';

          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CreateProductPage(token: token),
              ),
            );
          }
        },
      ),

      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductError) {
            return Center(child: Text(state.message));
          }

          if (state is ProductLoaded) {
            final allProducts = state.products;

            if (allProducts.isEmpty) {
              return const Center(child: Text("Data product kosong"));
            }

            // ================= CATEGORY =================
            final categories = <String>[
              "Semua",
              ...allProducts
                  .map((e) => e.categoryName ?? "Tanpa Category")
                  .toSet()
                  .toList(),
            ];

            if (!categories.contains(selectedCategory)) {
              selectedCategory = "Semua";
            }

            // ================= FILTER CATEGORY =================
            List filteredProducts = selectedCategory == "Semua"
                ? allProducts
                : allProducts
                    .where((p) => p.categoryName == selectedCategory)
                    .toList();

            // ================= SEARCH FILTER =================
            if (searchQuery.isNotEmpty) {
              filteredProducts = filteredProducts.where((product) {
                final name = product.name.toLowerCase();
                final desc = product.description.toLowerCase();
                final cat = (product.categoryName ?? "").toLowerCase();
                final query = searchQuery.toLowerCase();

                return name.contains(query) ||
                    desc.contains(query) ||
                    cat.contains(query);
              }).toList();
            }

            return Column(
              children: [
                // ================= SEARCH =================
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Cari product...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                // ================= CATEGORY =================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButtonFormField<String>(
                    value: selectedCategory,
                    isExpanded: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.category),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value!;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // ================= LIST =================
                Expanded(
                  child: filteredProducts.isEmpty
                      ? const Center(
                          child: Text("Product tidak ditemukan"),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            final color = _cardColor(index);

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    product.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    "Category: ${product.categoryName ?? '-'}",
                                  ),

                                  const SizedBox(height: 10),

                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: product.available
                                              ? Colors.green.withOpacity(0.15)
                                              : Colors.red.withOpacity(0.15),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          product.available
                                              ? "Available"
                                              : "Not Available",
                                        ),
                                      ),
                                      const Spacer(),
                                      Text("Stock: ${product.stock}"),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  // ================= EDIT & DELETE (NEW UI PREMIUM) =================
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(14),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    EditProductPage(
                                                  product: product,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color(0xFF7F7FD5),
                                                  Color(0xFF86A8E7),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.edit,
                                                    color: Colors.white,
                                                    size: 18),
                                                SizedBox(width: 6),
                                                Text(
                                                  "Edit",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 12),

                                      Expanded(
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(14),
                                          onTap: () async {
                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();

                                            final token =
                                                prefs.getString('token') ?? '';

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    DeleteProductPage(
                                                  token: token,
                                                  product: product,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color(0xFFFF416C),
                                                  Color(0xFFFF4B2B),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.delete,
                                                    color: Colors.white,
                                                    size: 18),
                                                SizedBox(width: 6),
                                                Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}