import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../widgets/header.dart';

class EdukasiPage extends StatelessWidget {
  const EdukasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      showBackButton: true,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Hotline Layanan Darurat', 
            style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const ListTile(
            tileColor: Colors.white,
            leading: Icon(Icons.phone, color: AppTheme.primaryPink),
            title: Text('SAPA 129'),
            subtitle: Text('KemenPPPA (Bebas Pulsa)'),
          ),
          const SizedBox(height: 10),
          const ListTile(
            tileColor: Colors.white,
            leading: Icon(Icons.local_police, color: Colors.blue),
            title: Text('Polisi 110'),
            subtitle: Text('Layanan Kepolisian'),
          ),
        ],
      ),
    );
  }
}