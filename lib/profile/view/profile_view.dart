import 'package:flutter/material.dart';
import 'package:flutter2/auth/cubit/auth_cubit.dart';
import 'package:flutter2/profile/bloc/profile_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late int confirmed = 1;
  bool get isConfirmed => confirmed == 1 ? true : false;

  late int blocked = 0;
  bool get isBlocked => blocked == 1 ? true : false;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // load profile
    final token = context.read<AuthCubit>().state.token;

    context.read<ProfileBloc>().add(LoadProfile(token: token!));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        // jika profile success
        if (state is ProfileSuccess) {
          final profile = state.profile.data;

          usernameController.text = profile!.username;
          emailController.text = profile.email;

          confirmed = profile.confirmed;
          blocked = profile.blocked;
        }

        // jika profile gagal
        if (state is ProfileFailure) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Load Profile Failed"),
              content: Text(state.message),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }
      },

      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text("Profile Page")),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              children: [
                buildProfileBuilder(),

                const SizedBox(height: 20),

                // status card
                buildStatusCard(),

                const Divider(),

                // form
                buildForm(),

                const SizedBox(height: 32),

                buildLogoutButton(context),
              ],
            ),
          ),
        );
      },
    );
  }

  SizedBox buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,

      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/login');
        },

        label: const Text("Logout"),

        icon: const Icon(Icons.logout),

        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.teal,
          side: const BorderSide(color: Colors.teal),
        ),
      ),
    );
  }

  Form buildForm() {
    return Form(
      key: _formKey,

      child: Column(
        children: [
          TextFormField(
            controller: usernameController,

            decoration: InputDecoration(
              labelText: 'Username',

              prefixIcon: const Icon(Icons.person),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),

            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Username wajib diisi";
              }

              return null;
            },
          ),

          const SizedBox(height: 8),

          TextFormField(
            controller: emailController,

            decoration: InputDecoration(
              labelText: 'Email',

              prefixIcon: const Icon(Icons.email),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),

            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Email wajib diisi";
              }

              return null;
            },
          ),

          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            height: 50,

            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);

                Navigator.pushNamed(context, '/update-profile');

                print("update profile");
              },

              label: const Text("Update Profile"),

              icon: const Icon(Icons.save),
            ),
          ),
        ],
      ),
    );
  }

  Card buildStatusCard() {
    return Card(
      elevation: 2,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Row(
          children: [
            // icon
            Icon(
              isConfirmed ? Icons.verified : Icons.warning,

              color: isConfirmed ? Colors.green : Colors.red,
            ),

            const SizedBox(width: 10),

            // text
            Expanded(
              child: Text(
                isConfirmed ? "Account Verified" : "Account not verified",

                style: TextStyle(
                  color: isConfirmed ? Colors.green : Colors.red,
                ),
              ),
            ),

            if (isBlocked)
              const Chip(
                label: Text("Blocked"),
                backgroundColor: Colors.deepOrangeAccent,
              ),
          ],
        ),
      ),
    );
  }

  Column buildProfileBuilder() {
    return Column(
      children: [
        const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),

        const SizedBox(height: 12),

        Text(
          usernameController.text,

          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 4),

        Text(emailController.text, style: TextStyle(color: Colors.grey[500])),
      ],
    );
  }
}
