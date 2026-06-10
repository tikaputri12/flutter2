import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/category_bloc.dart';
import '../models/category_model.dart';

class EditCategoryPage extends StatefulWidget {
  final CategoryModel category;

  const EditCategoryPage({
    super.key,
    required this.category,
  });

  @override
  State<EditCategoryPage> createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  late CategoryModel currentCategory;
  late TextEditingController nameController;
  late TextEditingController descController;
  late TextEditingController searchController;

  String searchQuery = "";
  final _formKey = GlobalKey<FormState>();

  // ── Modern Design Tokens ──────────────────────────────────────────
  static const _primary     = Color(0xFF6366F1); // Indigo
  static const _primaryDark = Color(0xFF4F46E5);
  static const _surface     = Color(0xFFFFFFFF);
  static const _bg          = Color(0xFFF8FAFC); // Slate background
  static const _border      = Color(0xFFE2E8F0);
  static const _labelColor  = Color(0xFF64748B);
  static const _textColor   = Color(0xFF0F172A);
  static const _accentPastel = Color(0xFFEEF2FF);

  @override
  void initState() {
    super.initState();
    currentCategory = widget.category;
    nameController = TextEditingController(text: currentCategory.name);
    descController = TextEditingController(text: currentCategory.description);
    searchController = TextEditingController();

    _fetchCategoriesFromApi();
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchCategoriesFromApi() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (mounted) {
      context.read<CategoryBloc>().add(GetCategoryEvent(token: token));
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  void _switchCategory(CategoryModel newCategory) {
    setState(() {
      currentCategory = newCategory;
      nameController.text = newCategory.name;
      descController.text = newCategory.description;
    });
  }

  InputDecoration _modernInputStyle(String label, IconData icon, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: _labelColor, fontSize: 14, fontWeight: FontWeight.w500),
      prefixIcon: Icon(icon, color: _primary.withOpacity(0.7), size: 22),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: _bg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: _border, width: 1)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: _primary, width: 1.8)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.redAccent, width: 1)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.redAccent, width: 1.8)),
    );
  }

  void _showSearchCategorySelection(List<CategoryModel> categories) {
    searchController.clear();
    setState(() => searchQuery = "");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredCategories = categories.where((c) {
              return c.name.toLowerCase().contains(searchQuery.toLowerCase());
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(color: _border, borderRadius: BorderRadius.circular(10)),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Cari Kategori",
                    style: TextStyle(color: _textColor, fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 16),
                  
                  TextField(
                    controller: searchController,
                    style: const TextStyle(color: _textColor, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "Cari nama kategori...",
                      hintStyle: const TextStyle(color: _labelColor),
                      prefixIcon: const Icon(Icons.search_rounded, color: _primary, size: 22),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, color: _labelColor, size: 18),
                              onPressed: () {
                                searchController.clear();
                                setModalState(() => searchQuery = "");
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: _bg,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onChanged: (value) {
                      setModalState(() => searchQuery = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  Expanded(
                    child: filteredCategories.isEmpty
                        ? const Center(
                            child: Text("Kategori tidak ditemukan", style: TextStyle(color: _labelColor)),
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: filteredCategories.length,
                            itemBuilder: (context, index) {
                              final item = filteredCategories[index];
                              final isCurrent = item.id == currentCategory.id;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: isCurrent ? _accentPastel : Colors.transparent,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: isCurrent ? _primary.withOpacity(0.3) : Colors.transparent),
                                ),
                                child: ListTile(
                                  title: Text(
                                    item.name,
                                    style: TextStyle(
                                      color: isCurrent ? _primaryDark : _textColor,
                                      fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                                    ),
                                  ),
                                  trailing: isCurrent
                                      ? const Icon(Icons.check_circle_rounded, color: _primary, size: 22)
                                      : const Icon(Icons.arrow_forward_ios_rounded, color: _border, size: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  onTap: () {
                                    _switchCategory(item);
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showConfirmationSheet() {
    if (!_formKey.currentState!.validate()) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(color: _surface, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 5, decoration: BoxDecoration(color: _border, borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: _primary.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.save_as_rounded, color: _primary, size: 32),
            ),
            const SizedBox(height: 16),
            const Text("Simpan Perubahan?", style: TextStyle(color: _textColor, fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(
              "Apakah Anda yakin ingin memperbarui kategori '${currentCategory.name}'?",
              textAlign: TextAlign.center,
              style: const TextStyle(color: _labelColor, fontSize: 14),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _border),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text("Batal", style: TextStyle(color: _labelColor, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final token = await getToken();
                      if (token == null) return;

                      final model = CategoryModel(
                        id: currentCategory.id,
                        name: nameController.text,
                        description: descController.text,
                      );

                      if (context.mounted) {
                        context.read<CategoryBloc>().add(
                              UpdateCategoryEvent(
                                id: currentCategory.id,
                                category: model,
                                token: token,
                              ),
                            );
                        Navigator.pop(context);
                        Navigator.pop(context, true);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: const Text("Ya, Simpan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: const Text(
          "Edit Category",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: _textColor, letterSpacing: -0.5),
        ),
        backgroundColor: _surface,
        foregroundColor: _textColor,
        elevation: 0,
        centerTitle: false,
        actions: [
          BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              final listCategories = state is CategoryLoaded ? state.categories : <CategoryModel>[];
              return IconButton(
                icon: const Icon(Icons.search_rounded, color: _primary, size: 26),
                tooltip: "Cari Kategori",
                onPressed: listCategories.isEmpty 
                    ? null 
                    : () => _showSearchCategorySelection(listCategories),
              );
            },
          ),
          const SizedBox(width: 12),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is CategoryLoading) {
                return const LinearProgressIndicator(backgroundColor: Colors.transparent, color: _primary, minHeight: 3);
              }
              return const SizedBox(height: 3);
            },
          ),
        ),
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _surface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(color: const Color(0xFF0F172A).withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 8)),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameController,
                          style: const TextStyle(color: _textColor, fontSize: 15, fontWeight: FontWeight.w500),
                          decoration: _modernInputStyle(
                            "Nama Kategori",
                            Icons.category_outlined,
                            suffixIcon: nameController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18, color: _labelColor),
                                    onPressed: () => setState(() => nameController.clear()),
                                  )
                                : null,
                          ),
                          validator: (value) => value!.isEmpty ? 'Nama kategori tidak boleh kosong' : null,
                          onChanged: (text) => setState(() {}),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: descController,
                          maxLines: 4,
                          style: const TextStyle(color: _textColor, fontSize: 15),
                          decoration: _modernInputStyle("Deskripsi", Icons.description_outlined),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 36),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _showConfirmationSheet,
                      icon: const Icon(Icons.check_rounded, color: Colors.white, size: 22),
                      label: const Text(
                        "Simpan Perubahan",
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.white, letterSpacing: -0.2),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primary,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shadowColor: _primary.withOpacity(0.3),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ).copyWith(
                        overlayColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.pressed)) return _primaryDark;
                          return null;
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}