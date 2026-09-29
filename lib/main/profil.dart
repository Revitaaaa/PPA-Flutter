import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/login.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  // --- Konstanta Warna Tema ---
  static const Color primaryPink = Color(0xFFFF3F78);
  static const Color accentMaroon = Color(0xFFA31545);
  static const Color softPink = Color(0xFFFF719B);
  static const Color borderColor = Color(0xFFF3ECEE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Bagian Header Bergelombang
              _buildHeader(context),

              const SizedBox(height: 12),

              // Bagian Identitas Pengguna (Avatar, Nama, Email)
              _buildUserProfile(),

              const SizedBox(height: 28),

              // Daftar Kartu Menu Pengaturan
              _buildMenuList(context),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HEADER WIDGET =================
  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 145,
      child: Stack(
        children: [
          // Gelombang Berwarna Pink Gradasi
          ClipPath(
            clipper: HeaderClipper(),
            child: Container(
              height: 140,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [softPink, primaryPink],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Bar Navigasi Atas (Tombol Kembali, Judul, Notifikasi)
          Positioned(
            top: 42,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Tombol Kembali
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.28),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 15,
                        ),
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      'Profil',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                // Lonceng Notifikasi
                Stack(
                  children: [
                    const Icon(
                      Icons.notifications_none_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                    Positioned(
                      right: 1,
                      top: 1,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF1744),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= USER PROFILE WIDGET =================
  Widget _buildUserProfile() {
    return Column(
      children: [
        // Lingkaran Avatar
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: accentMaroon,
              width: 2,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.person_outline_rounded,
              size: 50,
              color: accentMaroon,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Nama Pengguna
        Text(
          'Revitaaa',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: accentMaroon,
          ),
        ),
        const SizedBox(height: 4),

        // Email Pengguna
        Text(
          'revita@email.com',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFD3527B),
          ),
        ),
      ],
    );
  }

  // ================= MENU LIST WIDGET =================
  Widget _buildMenuList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Menu Edit Profil
          _buildMenuCard(
            icon: Icons.person_outline_rounded,
            title: 'Edit Profil',
            iconColor: accentMaroon,
            titleColor: accentMaroon,
            onTap: () {
              // Navigasi ke halaman edit profil
            },
          ),
          const SizedBox(height: 12),

          // Menu Ubah Password
          _buildMenuCard(
            icon: Icons.lock_outline_rounded,
            title: 'Ubah Password',
            iconColor: accentMaroon,
            titleColor: accentMaroon,
            onTap: () {
              // Navigasi ke halaman ubah password
            },
          ),
          const SizedBox(height: 12),

          // Menu Keluar Akun
          _buildMenuCard(
            icon: Icons.logout_rounded,
            title: 'Keluar',
            iconColor: Colors.redAccent,
            titleColor: Colors.redAccent,
            onTap: () => _handleLogout(context),
          ),
        ],
      ),
    );
  }

  // ================= KOMPONEN KARTU MENU (REUSABLE) =================
  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required Color iconColor,
    required Color titleColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 21, color: iconColor),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
              color: Color(0xFFC7B1B8),
            ),
          ],
        ),
      ),
    );
  }

  // ================= LOGIKA LOGOUT =================
  void _handleLogout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(
          onLoginSuccess: () {},
        ),
      ),
      (route) => false,
    );
  }
}

// ================= CUSTOM CLIPPER GELOMBANG =================
class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 25);

    // Titik lengkung gelombang pertama
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height + 15,
      size.width * 0.5,
      size.height - 5,
    );

    // Titik lengkung gelombang kedua
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height - 25,
      size.width,
      size.height - 5,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}