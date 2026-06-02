import 'package:flutter/material.dart';
import 'package:flutter2/auth/cubit/auth_cubit.dart';
import 'package:flutter2/core/widgets/app_drawer.dart';
import 'package:flutter2/profile/bloc/profile_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({super.key});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    final token =
        context.read<AuthCubit>().state.token;

    context.read<ProfileBloc>().add(
      LoadProfile(token: token!),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        context.watch<ProfileBloc>().state
            is ProfileUpdating;

    return BlocConsumer<
      ProfileBloc,
      ProfileState
    >(
      listener: (context, state) {
        if (state is ProfileSuccess) {
          final profile = state.profile.data;

          usernameController.text =
              profile!.username;

          emailController.text =
              profile.email;
        }

        if (state
            is ProfileUpdateSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(
            const SnackBar(
              content: Text(
                "Profile updated successfully",
              ),
            ),
          );

          Navigator.pop(context);

          Navigator.pushNamed(
            context,
            '/profile',
          );
        }

        if (state is ProfileFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(
            SnackBar(
              content:
                  Text(state.message),
            ),
          );
        }
      },

      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(
              child:
                  CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Edit Profile",
            ),
          ),

          drawer: const AppDrawer(),

          body: SingleChildScrollView(
            padding:
                const EdgeInsets.all(20),

            child: Form(
              key: _formKey,

              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    child: Icon(
                      Icons.person,
                      size: 50,
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  TextFormField(
                    controller:
                        usernameController,

                    decoration:
                        InputDecoration(
                      labelText:
                          "Username",

                      prefixIcon:
                          const Icon(
                        Icons.person,
                      ),

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),
                    ),

                    validator: (value) {
                      if (value ==
                              null ||
                          value
                              .trim()
                              .isEmpty) {
                        return "Username wajib diisi";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  TextFormField(
                    controller:
                        emailController,

                    keyboardType:
                        TextInputType
                            .emailAddress,

                    decoration:
                        InputDecoration(
                      labelText:
                          "Email",

                      prefixIcon:
                          const Icon(
                        Icons.email,
                      ),

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),
                    ),

                    validator: (value) {
                      if (value ==
                              null ||
                          value
                              .trim()
                              .isEmpty) {
                        return "Email wajib diisi";
                      }

                      if (!value
                          .contains('@')) {
                        return "Format email tidak valid";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  SizedBox(
                    width:
                        double.infinity,
                    height: 50,

                    child:
                        ElevatedButton.icon(
                      icon: isLoading
                          ? SizedBox(
                              width:
                                  18,
                              height:
                                  18,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth:
                                    2,
                              ),
                            )
                          : const Icon(
                              Icons
                                  .save,
                            ),

                      label: Text(
                        isLoading
                            ? "Saving..."
                            : "Save Changes",
                      ),

                      onPressed:
                          isLoading
                              ? null
                              : () {
                                  print(
                                    "Save changes pressed",
                                  );

                                  print(
                                    "Username: ${usernameController.text}",
                                  );

                                  print(
                                    "Email: ${emailController.text}",
                                  );

                                  if (_formKey
                                      .currentState!
                                      .validate()) {
                                    context
                                        .read<
                                          ProfileBloc
                                        >()
                                        .add(
                                          UpdateProfileEvent(
                                            username:
                                                usernameController
                                                    .text,

                                            email:
                                                emailController
                                                    .text,
                                          ),
                                        );
                                  }
                                },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}