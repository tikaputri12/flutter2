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

  //initstate
  @override
  void initState(){
    super.initState();
 //load profile
 final token = context.read<AuthCubit>().state.token;
 context.read<ProfileBloc>().add(LoadProfile(token: token!));
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        //jika state login success
        if(state is ProfileSuccess){
          final profile = state.profile.data;

          usernameController.text = profile!.username;
          emailController.text = profile.email;
          confirmed = profile.confirmed;
          blocked = profile.blocked;
        }

        //jika state login failure
        if(state is ProfileFailure){
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Load Profile Failed"),
              content: Text("$state.message"),
              actions: [
                TextButton(
                  child: Text("OK"),
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
          appBar: AppBar(title: Text("Profile Page")),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                buildProfileBuilder(),
                SizedBox(height: 20),

                //widget status card
                buildStatusCard(),
                Divider(),

                //form
                buildForm(),

                SizedBox(height: 32),
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
        label: Text("Logout"),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.teal,
          side: BorderSide(color: Colors.teal),
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
              prefixIcon: Icon(Icons.person),
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

          SizedBox(height: 8),

          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'email',
              prefixIcon: Icon(Icons.email),
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

          SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                print("Update profile ditekan");
              },
              label: Text("Update Profile"),
              icon: Icon(Icons.save),
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
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            //icon
            Icon(
              isConfirmed ? Icons.verified : Icons.warning,
              color: isConfirmed ? Colors.green : Colors.red,
            ),
            //text
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
        CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
        SizedBox(height: 12),
        Text(
          usernameController.text,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(emailController.text, style: TextStyle(color: Colors.grey[500])),
      ],
    );
  }
}
