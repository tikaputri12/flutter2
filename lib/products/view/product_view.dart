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

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {

    final prefs =
        await SharedPreferences.getInstance();

    final token =
        prefs.getString('token');

    if (token != null && context.mounted) {

      context.read<ProductBloc>().add(
            GetProductEvent(
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

      // ================= FLOATING BUTTON =================
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),

        onPressed: () async {

          final prefs =
              await SharedPreferences.getInstance();

          final token =
              prefs.getString('token') ?? '';

          if (context.mounted) {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CreateProductPage(
                  token: token,
                ),
              ),
            );
          }
        },
      ),

      // ================= BODY =================
      body: BlocBuilder<ProductBloc, ProductState>(

        builder: (context, state) {

          // ================= LOADING =================
          if (state is ProductLoading) {

            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // ================= ERROR =================
          if (state is ProductError) {

            return Center(
              child: Text(state.message),
            );
          }

          // ================= SUCCESS =================
          if (state is ProductLoaded) {

            if (state.products.isEmpty) {

              return const Center(
                child: Text("Data product kosong"),
              );
            }

            // ================= CATEGORY =================
            final categories = <String>{
              "Semua",

              ...state.products
                  .map((e) => e.categoryName)
                  .whereType<String>()
                  .where(
                    (e) => e.trim().isNotEmpty,
                  ),
            }.toList();

            // ================= FILTER =================
            final filteredProducts =
                selectedCategory == "Semua"

                    ? state.products

                    : state.products.where(
                        (product) {

                          return product.categoryName ==
                              selectedCategory;
                        },
                      ).toList();

            return Column(

              children: [

                // ================= DROPDOWN =================
                Padding(
                  padding: const EdgeInsets.all(16),

                  child: DropdownButtonFormField<String>(

                    value: selectedCategory,
                    isExpanded: true,

                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,

                      labelText: "Pilih Category",

                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(14),

                        borderSide: BorderSide.none,
                      ),
                    ),

                    items: categories.map(
                      (category) {

                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      },
                    ).toList(),

                    onChanged: (value) {

                      setState(() {
                        selectedCategory = value!;
                      });
                    },
                  ),
                ),

                // ================= LIST PRODUCT =================
                Expanded(

                  child: ListView.builder(

                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),

                    itemCount:
                        filteredProducts.length,

                    itemBuilder: (context, index) {

                      final product =
                          filteredProducts[index];

                      final color =
                          _cardColor(index);

                      return Container(

                        margin:
                            const EdgeInsets.only(
                          bottom: 16,
                        ),

                        padding:
                            const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius:
                              BorderRadius.circular(18),

                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(
                                0.05,
                              ),

                              blurRadius: 10,

                              offset:
                                  const Offset(0, 4),
                            ),
                          ],
                        ),

                        child: Row(

                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            // ================= ICON =================
                            Container(
                              width: 55,
                              height: 55,

                              decoration: BoxDecoration(
                                color:
                                    color.withOpacity(0.12),

                                borderRadius:
                                    BorderRadius.circular(
                                  14,
                                ),
                              ),

                              child: Icon(
                                Icons.shopping_bag_rounded,
                                color: color,
                                size: 28,
                              ),
                            ),

                            const SizedBox(width: 16),

                            // ================= CONTENT =================
                            Expanded(

                              child: Column(

                                crossAxisAlignment:
                                    CrossAxisAlignment.start,

                                children: [

                                  // CATEGORY
                                  Container(

                                    padding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),

                                    decoration: BoxDecoration(
                                      color:
                                          color.withOpacity(
                                        0.12,
                                      ),

                                      borderRadius:
                                          BorderRadius.circular(
                                        20,
                                      ),
                                    ),

                                    child: Text(

                                      product.categoryName ??
                                          "Tanpa Kategori",

                                      style: TextStyle(
                                        color: color,
                                        fontWeight:
                                            FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  // NAME
                                  Text(
                                    product.name,

                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  // DESCRIPTION
                                  Text(
                                    product.description,

                                    maxLines: 2,

                                    overflow:
                                        TextOverflow.ellipsis,

                                    style:
                                        const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  // AVAILABLE + STOCK
                                  Row(
                                    children: [

                                      Container(

                                        padding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),

                                        decoration:
                                            BoxDecoration(

                                          color:
                                              product.available

                                                  ? Colors.green
                                                      .withOpacity(
                                                    0.12,
                                                  )

                                                  : Colors.red
                                                      .withOpacity(
                                                    0.12,
                                                  ),

                                          borderRadius:
                                              BorderRadius.circular(
                                            20,
                                          ),
                                        ),

                                        child: Text(

                                          product.available
                                              ? "Available"
                                              : "Not Available",

                                          style: TextStyle(

                                            color:
                                                product.available
                                                    ? Colors.green
                                                    : Colors.red,

                                            fontWeight:
                                                FontWeight.w600,

                                            fontSize: 12,
                                          ),
                                        ),
                                      ),

                                      const Spacer(),

                                      Text(
                                        "Stock : ${product.stock}",

                                        style:
                                            const TextStyle(
                                          fontWeight:
                                              FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 14),

                                  // ================= BUTTON =================
                                  Row(
                                    children: [

                                      // EDIT
                                      Expanded(
                                        child:
                                            OutlinedButton.icon(

                                          icon: const Icon(
                                            Icons.edit,
                                          ),

                                          label:
                                              const Text(
                                            "Edit",
                                          ),

                                          onPressed:
                                              () async {

                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();

                                            final token =
                                                prefs.getString(
                                                      'token',
                                                    ) ??
                                                    '';

                                            if (context
                                                .mounted) {

                                              Navigator.push(
                                                context,

                                                MaterialPageRoute(
                                                  builder:
                                                      (_) =>
                                                          EditProductPage(
                                                    token:
                                                        token,
                                                    product:
                                                        product,
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),

                                      const SizedBox(width: 10),

                                      // DELETE
                                      Expanded(
                                        child:
                                            ElevatedButton.icon(

                                          style:
                                              ElevatedButton
                                                  .styleFrom(
                                            backgroundColor:
                                                Colors.red,
                                          ),

                                          icon: const Icon(
                                            Icons.delete,
                                          ),

                                          label:
                                              const Text(
                                            "Delete",
                                          ),

                                          onPressed:
                                              () async {

                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();

                                            final token =
                                                prefs.getString(
                                                      'token',
                                                    ) ??
                                                    '';

                                            if (context
                                                .mounted) {

                                              Navigator.push(
                                                context,

                                                MaterialPageRoute(
                                                  builder:
                                                      (_) =>
                                                          DeleteProductPage(
                                                    token:
                                                        token,
                                                    product:
                                                        product,
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
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