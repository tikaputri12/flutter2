import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(child: Text("Menu")),
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