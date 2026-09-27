import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../widgets/header.dart';

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> laporan;

  const DetailPage({super.key, required this.laporan});

  @override
  Widget build(BuildContext context) {
    // Format tanggal sederhana agar tidak panjang dengan zona waktu
    String rawTanggal = laporan['tanggal_kejadian'] ?? '-';
    String tanggalFormatted = rawTanggal.contains('T')
        ? rawTanggal.split('T').first
        : rawTanggal;

    // Tentukan warna badge status
    String statusText = laporan['status_penanganan'] ?? 'Menunggu Verifikasi';
    Color bgColor = const Color(0xFFFEF3C7); // Kuning
    Color textColor = const Color(0xFFD97706);

    if (statusText == 'Sedang Diproses' || statusText == 'Diproses') {
      bgColor = const Color(0xFFDBEAFE); // Biru
      textColor = const Color(0xFF1D4ED8);
    } else if (statusText == 'Selesai') {
      bgColor = const Color(0xFFD1FAE5); // Hijau
      textColor = const Color(0xFF059669);
    }

    return BaseLayout(
      showBackButton: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nomor Laporan & Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'LAP-${laporan['id_laporan'] ?? ''}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryPink,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      statusText,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24, thickness: 1),

              // Detail Informasi
              _buildInfoItem('Kategori Kejadian', laporan['kategori'] ?? '-'),
              const SizedBox(height: 12),
              _buildInfoItem('Sebagai', laporan['sebagai'] ?? '-'),
              const SizedBox(height: 12),
              _buildInfoItem('Lokasi Kejadian', laporan['lokasi_kejadian'] ?? '-'),
              const SizedBox(height: 12),
              _buildInfoItem('Tanggal Kejadian', tanggalFormatted),
              const SizedBox(height: 16),

              Text(
                'Kronologi:',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFF0F0F2)),
                ),
                child: Text(
                  laporan['kronologi'] ?? 'Tidak ada kronologi.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppTheme.textDark,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: AppTheme.textGrey,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.textDark,
          ),
        ),
      ],
    );
  }
}