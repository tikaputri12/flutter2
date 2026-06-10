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

  // ── Design tokens ──────────────────────────────────────────────
  static const _primary     = Color(0xFF6C47FF);   // indigo-violet
  static const _primaryDark = Color(0xFF4B2FCC);
  static const _surface     = Color(0xFFFFFFFF);
  static const _bg          = Color(0xFFF3F4FB);
  static const _border      = Color(0xFFE2E4F0);
  static const _labelColor  = Color(0xFF8B8FA8);
  static const _textColor   = Color(0xFF1A1D2E);

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: _labelColor, fontSize: 14),
      prefixIcon: Icon(icon, color: _labelColor, size: 20),
      filled: true,
      fillColor: _surface,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _border, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _primary, width: 2),
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
      backgroundColor: _bg,
      // ── App Bar ──────────────────────────────────────────────────
      appBar: AppBar(
        title: const Text(
          "Edit Product",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(24),
          ),
        ),
      ),
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Text(state.message)),
                  ],
                ),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.all(16),
              ),
            );
          }
        },
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const Center(
                child: CircularProgressIndicator(color: _primary),
              );
            }

            if (state is CategoryError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off,
                        color: _labelColor, size: 48),
                    const SizedBox(height: 12),
                    Text(state.message,
                        style: const TextStyle(color: _labelColor)),
                  ],
                ),
              );
            }

            if (state is CategoryLoaded) {
              final categories = state.categories;

              // FIX: pastikan selectedCategoryId valid
              final safeCategoryExists =
                  categories.any((c) => c.id == selectedCategoryId);

              if (!safeCategoryExists && categories.isNotEmpty) {
                selectedCategoryId = categories.first.id;
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Section label ───────────────────────────
                    _sectionLabel("Product Info"),
                    const SizedBox(height: 14),

                    // ── Card: Name + Description + Stock ────────
                    _card(
                      children: [
                        TextField(
                          controller: nameController,
                          style: const TextStyle(
                              color: _textColor, fontSize: 15),
                          decoration: _inputStyle(
                              "Product Name", Icons.label_outline),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: descriptionController,
                          maxLines: 3,
                          style: const TextStyle(
                              color: _textColor, fontSize: 15),
                          decoration: _inputStyle(
                              "Description", Icons.notes_outlined),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: stockController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              color: _textColor, fontSize: 15),
                          decoration: _inputStyle(
                              "Stock", Icons.inventory_2_outlined),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    _sectionLabel("Category & Status"),
                    const SizedBox(height: 14),

                    // ── Card: Category dropdown ──────────────────
                    _card(
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: _surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: _border, width: 1.5),
                          ),
                          child: DropdownButtonFormField<int>(
                            value: categories.any(
                                    (c) => c.id == selectedCategoryId)
                                ? selectedCategoryId
                                : null,
                            icon: const Icon(Icons.expand_more,
                                color: _labelColor),
                            dropdownColor: _surface,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                              prefixIcon: const Icon(
                                  Icons.grid_view_rounded,
                                  color: _labelColor,
                                  size: 20),
                              labelText: "Category",
                              labelStyle: const TextStyle(
                                  color: _labelColor, fontSize: 14),
                            ),
                            items: categories.map((c) {
                              return DropdownMenuItem<int>(
                                value: c.id,
                                child: Text(
                                  c.name,
                                  style: const TextStyle(
                                      color: _textColor, fontSize: 15),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCategoryId = value;
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 14),

                        // ── Availability toggle ──────────────────
                        Container(
                          decoration: BoxDecoration(
                            color: _surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: _border, width: 1.5),
                          ),
                          child: SwitchListTile(
                            value: available,
                            activeColor: _primary,
                            inactiveThumbColor: _labelColor,
                            title: const Text(
                              "Available",
                              style: TextStyle(
                                color: _textColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            subtitle: Text(
                              available
                                  ? "Visible to customers"
                                  : "Hidden from customers",
                              style: TextStyle(
                                color: available
                                    ? _primary
                                    : _labelColor,
                                fontSize: 12,
                              ),
                            ),
                            secondary: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: available
                                    ? _primary.withOpacity(0.1)
                                    : _border,
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                              child: Icon(
                                available
                                    ? Icons.storefront_outlined
                                    : Icons.store_mall_directory_outlined,
                                color: available
                                    ? _primary
                                    : _labelColor,
                                size: 20,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() => available = value);
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // ── Save Button ──────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: updateProduct,
                        icon: const Icon(Icons.check_circle_outline,
                            color: Colors.white),
                        label: const Text(
                          "Save Changes",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ).copyWith(
                          overlayColor:
                              WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.pressed)) {
                              return _primaryDark.withOpacity(0.15);
                            }
                            return null;
                          }),
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

  // ── Helper widgets ─────────────────────────────────────────────

  Widget _sectionLabel(String text) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: _primary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: _textColor,
            fontWeight: FontWeight.w700,
            fontSize: 14,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }

  Widget _card({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C47FF).withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}