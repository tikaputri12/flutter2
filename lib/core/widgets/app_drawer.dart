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
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 6,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, route);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              // ================= ICON =================
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 62,
                    width: 62,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: gradientColors,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: gradientColors.first.withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                  ),

                  Icon(
                    icon,
                    color: Colors.white,
                    size: 30,
                  ),

                  Positioned(
                    right: 6,
                    bottom: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        smallIcon,
                        size: 12,
                        color: gradientColors.first,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 16),

              // ================= TEXT =================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                height: 34,
                width: 34,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey.shade500,
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
      backgroundColor: const Color(0xffF4F7FC),

      child: Column(
        children: [
          // ================= HEADER =================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 60,
              left: 24,
              right: 24,
              bottom: 28,
            ),

            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff667eea),
                  Color(0xff764ba2),
                ],
              ),

              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(34),
                bottomRight: Radius.circular(34),
              ),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AVATAR
                Container(
                  padding: const EdgeInsets.all(5),

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    shape: BoxShape.circle,
                  ),

                  child: const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,

                    child: Icon(
                      Icons.flutter_dash_rounded,
                      size: 42,
                      color: Color(0xff667eea),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  "Bloc Cubit App",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 8),

                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    if (state is LoginSuccess) {
                      final data = state.login.data!.user;

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),

                        child: Row(
                          children: [
                            const Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                              size: 20,
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Text(
                                data!.username,

                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
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
                        horizontal: 14,
                        vertical: 10,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: const Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            color: Colors.white,
                            size: 20,
                          ),

                          SizedBox(width: 10),

                          Text(
                            "Unauthorized",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // ================= MENU =================
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),

              children: [
                buildMenuItem(
                  context: context,
                  icon: Icons.home_rounded,
                  smallIcon: Icons.star,
                  title: "Home",
                  subtitle: "Halaman utama aplikasi",
                  route: '/home',
                  gradientColors: [
                    const Color(0xff4facfe),
                    const Color(0xff00c6fb),
                  ],
                ),

                buildMenuItem(
                  context: context,
                  icon: Icons.calculate_rounded,
                  smallIcon: Icons.flash_on,
                  title: "Counter",
                  subtitle: "Counter Cubit",
                  route: '/counter',
                  gradientColors: [
                    const Color(0xffffb347),
                    const Color(0xffffcc33),
                  ],
                ),

                buildMenuItem(
                  context: context,
                  icon: Icons.article_rounded,
                  smallIcon: Icons.edit_note,
                  title: "Post List",
                  subtitle: "Menampilkan daftar posts",
                  route: '/posts',
                  gradientColors: [
                    const Color(0xff43e97b),
                    const Color(0xff38f9d7),
                  ],
                ),

                buildMenuItem(
                  context: context,
                  icon: Icons.category_rounded,
                  smallIcon: Icons.layers,
                  title: "Category",
                  subtitle: "CRUD category",
                  route: '/categories',
                  gradientColors: [
                    const Color(0xffa18cd1),
                    const Color(0xfffbc2eb),
                  ],
                ),

                buildMenuItem(
                  context: context,
                  icon: Icons.shopping_bag_rounded,
                  smallIcon: Icons.shopping_cart,
                  title: "Products",
                  subtitle: "Menampilkan daftar products",
                  route: '/products',
                  gradientColors: [
                    const Color(0xffff9966),
                    const Color(0xffff5e62),
                  ],
                ),

                buildMenuItem(
                  context: context,
                  icon: Icons.person_rounded,
                  smallIcon: Icons.verified,
                  title: "Profile",
                  subtitle: "Melihat profile user",
                  route: '/profile',
                  gradientColors: [
                    const Color(0xff11998e),
                    const Color(0xff38ef7d),
                  ],
                ),

                const SizedBox(height: 18),

                // ================= LOGOUT =================
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),

                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);

                      Navigator.pushNamed(
                        context,
                        '/login',
                      );
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffef4444),
                      foregroundColor: Colors.white,
                      elevation: 0,

                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    icon: const Icon(Icons.logout_rounded),

                    label: const Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}