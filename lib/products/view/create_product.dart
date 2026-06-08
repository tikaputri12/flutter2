import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/product_bloc.dart';
import '../../categories/bloc/category_bloc.dart';

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

  final nameController =
      TextEditingController();

  final descController =
      TextEditingController();

  final stockController =
      TextEditingController();

  // SEARCH CATEGORY
  final searchController =
      TextEditingController();

  String searchCategory = "";

  int? selectedCategoryId;

  bool available = true;

  @override
  void initState() {
    super.initState();

    // GET CATEGORY
    context.read<CategoryBloc>().add(
          GetCategoryEvent(
            token: widget.token,
          ),
        );
  }

  @override
  void dispose() {

    nameController.dispose();
    descController.dispose();
    stockController.dispose();
    searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFFF5F7FA),

      appBar: AppBar(
        title: const Text(
          "Create Product",
        ),
        centerTitle: true,
      ),

      body:
          BlocBuilder<CategoryBloc, CategoryState>(

        builder: (context, state) {

          // LOADING
          if (state is CategoryLoading) {

            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          // ERROR
          if (state is CategoryError) {

            return Center(
              child: Text(
                state.message,
              ),
            );
          }

          // SUCCESS
          if (state is CategoryLoaded) {

            final categories =
                state.categories;

            // FILTER CATEGORY
            final filteredCategories =
                categories.where((category) {

              return category.name
                  .toLowerCase()
                  .contains(
                    searchCategory
                        .toLowerCase(),
                  );

            }).toList();

            // CEK APAKAH CATEGORY MASIH ADA
            final isSelectedExist =
                filteredCategories.any(
              (category) =>
                  category.id ==
                  selectedCategoryId,
            );

            // JIKA TIDAK ADA
            if (!isSelectedExist) {

              selectedCategoryId = null;
            }

            // DEFAULT CATEGORY
            if (selectedCategoryId ==
                    null &&
                filteredCategories
                    .isNotEmpty) {

              selectedCategoryId =
                  filteredCategories
                      .first.id;
            }

            return SingleChildScrollView(

              padding:
                  const EdgeInsets.all(16),

              child: Column(

                children: [

                  // SEARCH CATEGORY
                  TextField(

                    controller:
                        searchController,

                    decoration:
                        InputDecoration(

                      hintText:
                          "Cari category...",

                      filled: true,
                      fillColor:
                          Colors.white,

                      prefixIcon:
                          const Icon(
                        Icons.search,
                      ),

                      border:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius
                                .circular(
                          14,
                        ),

                        borderSide:
                            BorderSide.none,
                      ),

                      enabledBorder:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius
                                .circular(
                          14,
                        ),

                        borderSide:
                            BorderSide.none,
                      ),

                      focusedBorder:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius
                                .circular(
                          14,
                        ),

                        borderSide:
                            const BorderSide(
                          color:
                              Colors.blue,
                          width: 1.5,
                        ),
                      ),
                    ),

                    onChanged: (value) {

                      setState(() {

                        searchCategory =
                            value;
                      });
                    },
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  // DROPDOWN CATEGORY
                  DropdownButtonFormField<int>(

                    value:
                        selectedCategoryId,

                    isExpanded: true,

                    decoration:
                        InputDecoration(

                      labelText:
                          "Category",

                      filled: true,
                      fillColor:
                          Colors.white,

                      prefixIcon:
                          const Icon(
                        Icons
                            .category_outlined,
                      ),

                      border:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius
                                .circular(
                          14,
                        ),

                        borderSide:
                            BorderSide.none,
                      ),

                      enabledBorder:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius
                                .circular(
                          14,
                        ),

                        borderSide:
                            BorderSide.none,
                      ),

                      focusedBorder:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius
                                .circular(
                          14,
                        ),

                        borderSide:
                            const BorderSide(
                          color:
                              Colors.blue,
                          width: 1.5,
                        ),
                      ),
                    ),

                    items:
                        filteredCategories.map(
                      (category) {

                        return DropdownMenuItem<int>(

                          value:
                              category.id,

                          child: Text(
                            category.name,
                          ),
                        );
                      },
                    ).toList(),

                    onChanged: (value) {

                      setState(() {

                        selectedCategoryId =
                            value;
                      });
                    },
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  // PRODUCT NAME
                  TextField(

                    controller:
                        nameController,

                    decoration:
                        InputDecoration(

                      labelText:
                          "Product Name",

                      filled: true,
                      fillColor:
                          Colors.white,

                      prefixIcon:
                          const Icon(
                        Icons
                            .shopping_bag_outlined,
                      ),

                      border:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius
                                .circular(
                          14,
                        ),

                        borderSide:
                            BorderSide.none,
                      ),

                      enabledBorder:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius
                                .circular(
                          14,
                        ),

                        borderSide:
                            BorderSide.none,
                      ),

                      focusedBorder:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius
                                .circular(
                          14,
                        ),

                        borderSide:
                            const BorderSide(
                          color:
                              Colors.blue,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  // DESCRIPTION
                  TextField(

                    controller:
                        descController,

                    maxLines: 3,

                    decoration:
                        InputDecoration(

                      labelText:
                          "Description",

                      filled: true,
                      fillColor:
                          Colors.white,

                      prefixIcon:
                          const Padding(

                        padding:
                            EdgeInsets.only(
                          bottom: 60,
                        ),

                        child: Icon(
                          Icons
                              .description_outlined,
                        ),
                      ),

                      border:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius
                                .circular(
                          14,
                        ),

                        borderSide:
                            BorderSide.none,
                      ),

                      enabledBorder:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius
                                .circular(
                          14,
                        ),

                        borderSide:
                            BorderSide.none,
                      ),

                      focusedBorder:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius
                                .circular(
                          14,
                        ),

                        borderSide:
                            const BorderSide(
                          color:
                              Colors.blue,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  // STOCK
                  TextField(

                    controller:
                        stockController,

                    keyboardType:
                        TextInputType.number,

                    decoration:
                        InputDecoration(

                      labelText:
                          "Stock",

                      filled: true,
                      fillColor:
                          Colors.white,

                      prefixIcon:
                          const Icon(
                        Icons
                            .inventory_2_outlined,
                      ),

                      border:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius
                                .circular(
                          14,
                        ),

                        borderSide:
                            BorderSide.none,
                      ),

                      enabledBorder:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius
                                .circular(
                          14,
                        ),

                        borderSide:
                            BorderSide.none,
                      ),

                      focusedBorder:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius
                                .circular(
                          14,
                        ),

                        borderSide:
                            const BorderSide(
                          color:
                              Colors.blue,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  // AVAILABLE
                  Container(

                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),

                    decoration: BoxDecoration(

                      color: Colors.white,

                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                    ),

                    child: SwitchListTile(

                      value: available,

                      title: const Text(
                        "Available",
                      ),

                      secondary:
                          const Icon(
                        Icons
                            .check_circle_outline,
                      ),

                      onChanged: (value) {

                        setState(() {

                          available = value;
                        });
                      },
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // BUTTON
                  SizedBox(

                    width: double.infinity,

                    child: ElevatedButton(

                      style:
                          ElevatedButton.styleFrom(

                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 16,
                        ),

                        shape:
                            RoundedRectangleBorder(

                          borderRadius:
                              BorderRadius.circular(
                            14,
                          ),
                        ),
                      ),

                      onPressed: () {

                        // VALIDASI
                        if (selectedCategoryId ==
                            null) {

                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(

                            const SnackBar(
                              content: Text(
                                "Category wajib dipilih",
                              ),
                            ),
                          );

                          return;
                        }

                        context
                            .read<ProductBloc>()
                            .add(

                              CreateProductEvent(

                                token:
                                    widget.token,

                                idCategory:
                                    selectedCategoryId!,

                                name:
                                    nameController.text,

                                description:
                                    descController.text,

                                available:
                                    available,

                                stock:
                                    int.tryParse(
                                          stockController
                                              .text,
                                        ) ??
                                        0,

                                expired: null,
                              ),
                            );

                        Navigator.pop(
                          context,
                        );
                      },

                      child: const Text(

                        "Create Product",

                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
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
    );
  }
}