import 'package:flutter/material.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginScreen({
    super.key,
    required this.onLoginSuccess,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  static const Color primaryPink = Color(0xFFE0245E);
  static const Color headerPink = Color(0xFFFF4B72);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // HEADER
              SizedBox(
                height: 175,
                child: Stack(
                  children: [
                    ClipPath(
                      clipper: HeaderClipper(),
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
                          onPressed: () {},
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

              // FORM
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Masuk ke Akun Anda',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: primaryPink,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'Silakan login untuk melanjutkan',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFFE9A1B7),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // EMAIL
                    const Text(
                      'Email atau Nomor HP',
                      style: TextStyle(
                        fontSize: 10,
                        color: primaryPink,
                      ),
                    ),

                    const SizedBox(height: 6),

                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'contoh@email.com',
                        hintStyle: const TextStyle(
                          fontSize: 9,
                          color: Color(0xFFE9A1B7),
                        ),
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: primaryPink,
                          size: 18,
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

                    const SizedBox(height: 13),

                    // PASSWORD
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 10,
                        color: primaryPink,
                      ),
                    ),

                    const SizedBox(height: 6),

                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Masukkan password',
                        hintStyle: const TextStyle(
                          fontSize: 9,
                          color: Color(0xFFE9A1B7),
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: primaryPink,
                          size: 18,
                        ),
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

                    const SizedBox(height: 15),

                    // TOMBOL MASUK
                    SizedBox(
                      width: double.infinity,
                      height: 43,
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onLoginSuccess();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryPink,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'Masuk',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    // LUPA PASSWORD
                    Center(
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Lupa Password?',
                          style: TextStyle(
                            fontSize: 9,
                            color: primaryPink,
                          ),
                        ),
                      ),
                    ),

                    // PEMBATAS
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            color: Color(0xFFF0C5D1),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'atau',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                            color: Color(0xFFF0C5D1),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // DAFTAR
                    SizedBox(
                      width: double.infinity,
                      height: 43,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryPink,
                          side: const BorderSide(
                            color: headerPink,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'Daftar Akun',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
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

// WAVE HEADER
class HeaderClipper extends CustomClipper<Path> {
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
