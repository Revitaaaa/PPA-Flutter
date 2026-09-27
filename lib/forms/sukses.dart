import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../widgets/header.dart';
import '../widgets/navbar.dart';

class SuksesPage extends StatelessWidget {
  final String nomorLaporan;
  const SuksesPage({super.key, required this.nomorLaporan});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      showBackButton: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          children: [
            const Icon(Icons.check_circle, color: AppTheme.successGreen, size: 70),
            const SizedBox(height: 16),
            Text('Laporan Berhasil Dikirim', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.successGreen)),
            const SizedBox(height: 8),
            Text('Nomor Laporan Anda:', style: GoogleFonts.plusJakartaSans(color: AppTheme.textGrey)),
            Text(nomorLaporan, style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryPink)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryPink, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const NavbarPage())),
                child: Text('Kembali ke Beranda', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}