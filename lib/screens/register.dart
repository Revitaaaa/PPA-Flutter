import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const Color primaryPink = Color(0xFFE0245E);
  static const Color headerPink = Color(0xFFFF4B72);
  static const Color hintPink = Color(0xFFE9A1B7);

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _konfirmasiPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureKonfirmasi = true;

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _tanggalController.dispose();
    _alamatController.dispose();
    _emailController.dispose();
    _noHpController.dispose();
    _passwordController.dispose();
    _konfirmasiPasswordController.dispose();
    super.dispose();
  }

  // ============================================================
  // PILIH TANGGAL LAHIR
  // ============================================================
  Future<void> _pilihTanggal() async {
    final DateTime? tanggal = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );

    if (tanggal != null) {
      setState(() {
        _tanggalController.text =
            '${tanggal.day.toString().padLeft(2, '0')}/'
            '${tanggal.month.toString().padLeft(2, '0')}/'
            '${tanggal.year}';
      });
    }
  }

  // ============================================================
  // DAFTAR
  // ============================================================
  void _daftar() {
    if (_namaController.text.isEmpty ||
        _nikController.text.isEmpty ||
        _tanggalController.text.isEmpty ||
        _alamatController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _noHpController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _konfirmasiPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua data harus diisi.'),
        ),
      );
      return;
    }

    if (_passwordController.text !=
        _konfirmasiPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Konfirmasi password tidak sama.'),
        ),
      );
      return;
    }

    // Sementara hanya simulasi berhasil.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registrasi berhasil. Silakan login.'),
      ),
    );

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================
  Widget _buildField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    VoidCallback? onTap,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: primaryPink,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          onTap: onTap,
          readOnly: onTap != null,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 9,
              color: hintPink,
            ),
            prefixIcon: Icon(
              icon,
              color: primaryPink,
              size: 18,
            ),
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 13,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(
                color: headerPink,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(
                color: primaryPink,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ========================================================
              // HEADER
              // ========================================================
              SizedBox(
                height: 175,
                child: Stack(
                  children: [
                    ClipPath(
                      clipper: RegisterHeaderClipper(),
                      child: Container(
                        height: 140,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFFF719B),
                              Color(0xFFFF3F78),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Tombol kembali
                    Positioned(
                      left: 15,
                      top: 18,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 17,
                          ),
                        ),
                      ),
                    ),

                    // Logo
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.pink.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.handshake_outlined,
                            color: headerPink,
                            size: 36,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ========================================================
              // FORM
              // ========================================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Daftar Akun',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: primaryPink,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'Buat akun baru untuk melaporkan kasus dan\nmemantau status laporan.',
                      style: TextStyle(
                        fontSize: 11,
                        color: hintPink,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // NAMA
                    _buildField(
                      label: 'Nama Lengkap',
                      hint: 'Dafa',
                      icon: Icons.person_outline,
                      controller: _namaController,
                    ),

                    const SizedBox(height: 11),

                    // NIK
                    _buildField(
                      label: 'Nomor Induk Keluarga',
                      hint: '1234567890',
                      icon: Icons.credit_card_outlined,
                      controller: _nikController,
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 11),

                    // TANGGAL LAHIR
                    _buildField(
                      label: 'Tanggal Lahir',
                      hint: '234567890',
                      icon: Icons.calendar_month_outlined,
                      controller: _tanggalController,
                      onTap: _pilihTanggal,
                      suffixIcon: const Icon(
                        Icons.calendar_today_outlined,
                        color: primaryPink,
                        size: 17,
                      ),
                    ),

                    const SizedBox(height: 11),

                    // ALAMAT
                    _buildField(
                      label: 'Alamat',
                      hint: 'Perum. qwertyui',
                      icon: Icons.location_on_outlined,
                      controller: _alamatController,
                    ),

                    const SizedBox(height: 11),

                    // EMAIL
                    _buildField(
                      label: 'Email',
                      hint: 'contoh@email.com',
                      icon: Icons.email_outlined,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 11),

                    // NOMOR HP
                    _buildField(
                      label: 'Nomor HP',
                      hint: '08123456789',
                      icon: Icons.phone_outlined,
                      controller: _noHpController,
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: 11),

                    // PASSWORD
                    _buildField(
                      label: 'Password',
                      hint: 'contoh@email.com',
                      icon: Icons.lock_outline,
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: headerPink,
                          size: 17,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 11),

                    // KONFIRMASI PASSWORD
                    _buildField(
                      label: 'Konfirmasi Password',
                      hint: 'contoh@email.com',
                      icon: Icons.lock_outline,
                      controller: _konfirmasiPasswordController,
                      obscureText: _obscureKonfirmasi,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureKonfirmasi
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: headerPink,
                          size: 17,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureKonfirmasi =
                                !_obscureKonfirmasi;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 13),

                    // ==================================================
                    // TOMBOL
                    // ==================================================
                    SizedBox(
                      width: double.infinity,
                      height: 43,
                      child: ElevatedButton(
                        onPressed: _daftar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFC92C5B),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'Daftar',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ==================================================
                    // LINK LOGIN
                    // ==================================================
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Sudah punya akun? ',
                            style: TextStyle(
                              fontSize: 9,
                              color: hintPink,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 9,
                                color: primaryPink,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================================================================
// WAVE HEADER
// ================================================================
class RegisterHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height - 25);

    path.quadraticBezierTo(
      size.width * 0.25,
      size.height + 15,
      size.width * 0.5,
      size.height - 5,
    );

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
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}