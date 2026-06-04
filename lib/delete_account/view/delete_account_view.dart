import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter2/delete_account/bloc/delete_account_bloc.dart';

class DeleteAccountView extends StatefulWidget {
  const DeleteAccountView({super.key});

  @override
  State<DeleteAccountView> createState() => _DeleteAccountViewState();
}

class _DeleteAccountViewState extends State<DeleteAccountView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  bool agreeDelete = false;

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  // Fungsi untuk menampilkan Pop-up ketika Gagal (Sama seperti pop-up Login Failed di video)
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28), // Membuat sudut melengkung halus sesuai mockup
          ),
          title: const Text(
            "Delete Failed",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "OK",
                style: TextStyle(color: Color(0xFF5E35B1), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Delete Account"),
          content: const Text(
            "This action cannot be undone. Are you sure you want to permanently delete your account?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(context);

                // Memicu Event ke BLoC untuk memproses ke server
                context.read<DeleteAccountBloc>().add(
                      DeleteAccountRequested(
                        password: passwordController.text,
                      ),
                    );
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeleteAccountBloc, DeleteAccountState>(
      listener: (context, state) {
        if (state is DeleteAccountSuccess) {
          // Jika sukses, lempar ke halaman login
          Navigator.pushReplacementNamed(context, '/login');
        } else if (state is DeleteAccountFailure) {
          // 🔥 BARU: Jika gagal (misal password salah), munculkan Pop-up Error Dialog
          _showErrorDialog(state.error);
        }
      },
      builder: (context, state) {
        // 🔥 BARU: Cek apakah BLoC sedang dalam status loading (memproses data)
        bool isLoading = state is DeleteAccountLoading;

        return Scaffold(
          backgroundColor: const Color(0xFFFFF8FA),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: isLoading ? null : () => Navigator.pop(context), // Kunci tombol back jika lagi loading
            ),
            title: const Text(
              "Delete Account",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red.shade700,
                      size: 80,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Delete Your Account",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Deleting your account is permanent. All your profile information and access to this application will be removed.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade700, height: 1.4),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "What will happen?",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(height: 10),
                          Text("• You will no longer be able to login"),
                          SizedBox(height: 4),
                          Text("• Your account will be marked as deleted"),
                          SizedBox(height: 4),
                          Text("• Your personal information will be inaccessible"),
                          SizedBox(height: 4),
                          Text("• This action cannot be undone"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    TextFormField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      enabled: !isLoading, // Kunci input jika sedang loading
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        labelStyle: const TextStyle(color: Color(0xFF5E35B1)),
                        prefixIcon: const Icon(Icons.lock_outline_rounded, color: Colors.black87),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: Colors.black87,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFF5E35B1), width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFF5E35B1), width: 2.0),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.red, width: 1.5),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.red, width: 2.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          child: Text(
                            "I understand that this action cannot be undone.",
                            style: TextStyle(fontSize: 15, height: 1.3),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: agreeDelete,
                            activeColor: const Color(0xFF5E35B1),
                            onChanged: isLoading
                                ? null // Matikan checkbox saat loading
                                : (value) {
                                    setState(() {
                                      agreeDelete = value ?? false;
                                    });
                                  },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF44336),
                          disabledBackgroundColor: const Color(0xFFF44336).withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
                        ),
                        // Tombol mati jika tidak dicentang atau aplikasi sedang loading
                        onPressed: (agreeDelete && !isLoading)
                            ? () {
                                if (_formKey.currentState!.validate()) {
                                  _showDeleteConfirmation();
                                }
                              }
                            : null,
                        child: isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.delete_forever_outlined, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    "Delete Account",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}