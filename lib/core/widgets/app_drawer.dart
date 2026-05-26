import 'package:flutter/material.dart';
import 'package:flutter2/login/bloc/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.indigo],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.flutter_dash, size: 35, color: Colors.blue),
                ),
                SizedBox(height: 8),
                Text(
                  "Bloc Cubit",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    //jika sukses
                    if (state is LoginSuccess) {
                      final data = state.login.data!.user;
                      return Row(
                      children: [
                        Icon(Icons.person, color: Colors.white, size: 16),
                        SizedBox(height: 6),
                        Text(
                          data!.username,
                          style: TextStyle(color: Colors.white70, 
                          fontSize: 13,
                          ),
                        ),
                      ],
                    );
                    }
                    // jika gagal
                    return Row(
                      children: [
                        Icon(Icons.person, color: Colors.white, size: 16),
                        SizedBox(height: 6),
                        Text(
                          "Unauthorized",
                          style: TextStyle(color: Colors.white70, 
                          fontSize: 13,
                          ),
                        ),
                      ],
                    );
                    
                  },
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text("Home"),
            subtitle: const Text('counter'),
            leading: const Icon(Icons.home, size: 40, color: Colors.blue),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/home');
            },
          ),

          const Divider(),
          ListTile(
            title: const Text("Counter"),
            subtitle: const Text('counter'),
            leading: const Icon(
              Icons.engineering,
              size: 40,
              color: Colors.blue,
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/counter');
            },
          ),

          const Divider(),
          ListTile(
            title: Text("Post List"),
            subtitle: const Text('Software Engineer'),
            leading: const Icon(Icons.newspaper, size: 40, color: Colors.blue),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/posts');
            },
          ),

          const Divider(),
          ListTile(
            title: Text("Logout"),
            subtitle: const Text('Keluar dari aplikasi'),
            leading: const Icon(Icons.logout, size: 40, color: Colors.blue),
            trailing: const Icon(Icons.logout),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
