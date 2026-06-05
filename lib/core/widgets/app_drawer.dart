import 'package:flutter/material.dart';
import 'package:flutter2/login/bloc/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Widget buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String route,
    Color color = Colors.indigo,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),

      child: Card(
        elevation: 3,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),

        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 6,
          ),

          leading: Container(
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: color.withOpacity(0.1),

              borderRadius: BorderRadius.circular(14),
            ),

            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),

          title: Text(
            title,

            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          subtitle: Text(
            subtitle,

            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),

          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 18,
          ),

          onTap: () {
            Navigator.pop(context);

            Navigator.pushNamed(
              context,
              route,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey.shade100,

      child: ListView(
        padding: EdgeInsets.zero,

        children: [

          // HEADER
          Container(
            height: 240,

            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff4facfe),
                  Color(0xff00f2fe),
                ],

                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),

              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),

            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                mainAxisAlignment:
                    MainAxisAlignment.end,

                children: [

                  Container(
                    padding: const EdgeInsets.all(4),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius:
                          BorderRadius.circular(50),
                    ),

                    child: const CircleAvatar(
                      radius: 36,

                      backgroundColor: Colors.white,

                      child: Icon(
                        Icons.flutter_dash,
                        size: 45,
                        color: Colors.blue,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "Flutter Bloc App",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {

                      if (state is LoginSuccess) {

                        final data =
                            state.login.data!.user;

                        return Row(
                          children: [

                            const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 18,
                            ),

                            const SizedBox(width: 6),

                            Text(
                              data!.username,

                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        );
                      }

                      return const Row(
                        children: [

                          Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 18,
                          ),

                          SizedBox(width: 6),

                          Text(
                            "Unauthorized",

                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 15),

          // HOME
          buildMenuItem(
            context: context,
            icon: Icons.home_rounded,
            title: "Home",
            subtitle: "Halaman utama aplikasi",
            route: '/home',
            color: Colors.blue,
          ),

          // COUNTER
          buildMenuItem(
            context: context,
            icon: Icons.calculate_rounded,
            title: "Counter",
            subtitle: "Counter Cubit Feature",
            route: '/counter',
            color: Colors.orange,
          ),

          // POSTS
          buildMenuItem(
            context: context,
            icon: Icons.article_rounded,
            title: "Post List",
            subtitle: "Menampilkan daftar posts",
            route: '/posts',
            color: Colors.green,
          ),

          // CATEGORY
          buildMenuItem(
            context: context,
            icon: Icons.category_rounded,
            title: "Category",
            subtitle: "CRUD Category Feature",
            route: '/categories',
            color: Colors.purple,
          ),

          // PROFILE
          buildMenuItem(
            context: context,
            icon: Icons.person_rounded,
            title: "Profile",
            subtitle: "Melihat profile user",
            route: '/profile',
            color: Colors.teal,
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),

            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,

                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),

                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                ),
              ),

              onPressed: () {
                Navigator.pop(context);

                Navigator.pushNamed(
                  context,
                  '/login',
                );
              },

              icon: const Icon(Icons.logout),

              label: const Text(
                "Logout",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}