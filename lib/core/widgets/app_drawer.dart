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
    required List<Color> gradientColors,
    required IconData smallIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, route);
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F5FF),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: const Color(0xFFB9A7D9).withOpacity(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7C5CFF).withOpacity(0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              // ICON (lebih premium & soft glow)
              Container(
                height: 54,
                width: 54,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      gradientColors.first.withOpacity(0.9),
                      gradientColors.last.withOpacity(0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: gradientColors.first.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(icon, color: Colors.white, size: 26),

                    Positioned(
                      right: 6,
                      bottom: 6,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          smallIcon,
                          size: 10,
                          color: Color(0xFF7C5CFF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 14),

              // TEXT (lebih clean & luxury feel)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2B1B4A),
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EBFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Color(0xFF7C5CFF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF4F1FF),

      child: Column(
        children: [
          // HEADER (lebih smooth & elegant)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 70,
              left: 24,
              right: 24,
              bottom: 26,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 59, 48, 106),
                  Color.fromARGB(255, 84, 57, 165),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                  child: const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.flutter_dash_rounded,
                      size: 38,
                      color: Color(0xFF6D4CFF),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                const Text(
                  " suga app ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),

                const SizedBox(height: 6),

                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    if (state is LoginSuccess) {
                      final data = state.login.data!.user;

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                data!.username,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Text(
                        "Unauthorized",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // MENU
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                buildMenuItem(
                  context: context,
                  icon: Icons.home_rounded,
                  smallIcon: Icons.auto_awesome,
                  title: "Home",
                  subtitle: "Halaman utama aplikasi",
                  route: '/home',
                  gradientColors: [
                    const Color(0xFF6D4CFF),
                    const Color(0xFF9F8BFF),
                  ],
                ),

                buildMenuItem(
                  context: context,
                  icon: Icons.calculate_rounded,
                  smallIcon: Icons.bolt,
                  title: "Counter",
                  subtitle: "Counter Cubit",
                  route: '/counter',
                  gradientColors: [
                    const Color.fromARGB(255, 232, 160, 45),
                    const Color(0xFFFFD54F),
                  ],
                ),

                buildMenuItem(
                  context: context,
                  icon: Icons.article_rounded,
                  smallIcon: Icons.edit_note,
                  title: "Post List",
                  subtitle: "Daftar posts",
                  route: '/posts',
                  gradientColors: [
                    const Color(0xFF4DD0E1),
                    const Color(0xFF26C6DA),
                  ],
                ),

                buildMenuItem(
                  context: context,
                  icon: Icons.category_rounded,
                  smallIcon: Icons.grid_view_rounded,
                  title: "Category",
                  subtitle: "CRUD category",
                  route: '/categories',
                  gradientColors: [
                    const Color(0xFFBA68C8),
                    const Color(0xFFE1BEE7),
                  ],
                ),

                buildMenuItem(
                  context: context,
                  icon: Icons.shopping_bag_rounded,
                  smallIcon: Icons.shopping_cart,
                  title: "Products",
                  subtitle: "Daftar produk",
                  route: '/products',
                  gradientColors: [
                    const Color(0xFFFF8A65),
                    const Color(0xFFFFAB91),
                  ],
                ),

                buildMenuItem(
                  context: context,
                  icon: Icons.person_rounded,
                  smallIcon: Icons.verified,
                  title: "Profile",
                  subtitle: "User profile",
                  route: '/profile',
                  gradientColors: [
                    const Color(0xFF26A69A),
                    const Color(0xFF80CBC4),
                  ],
                ),

                const SizedBox(height: 18),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF5350),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.logout),
                    label: const Text("Logout"),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}