import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../core/theme.dart';
import '../widgets/header.dart';
import 'sukses.dart';

class KonfirmasiPage extends StatefulWidget {
  final String kategori;
  final String sebagai;
  final String lokasi;
  final String tanggal;
  final String kronologi;
  final List<String> files;

  const KonfirmasiPage({
    super.key,
    required this.kategori,
    required this.sebagai,
    required this.lokasi,
    required this.tanggal,
    required this.kronologi,
    required this.files,
  });

  @override
  State<KonfirmasiPage> createState() => _KonfirmasiPageState();
}

class _KonfirmasiPageState extends State<KonfirmasiPage> {
  bool _loading = false;

  Future<void> _kirimLaporan() async {
    setState(() => _loading = true);
    String idNomor = 'LAP-001';

    // Konversi format tanggal dari DD-MM-YYYY menjadi YYYY-MM-DD untuk kolom date MySQL
    String formatTanggalKejadian = widget.tanggal;
    if (widget.tanggal.contains('-')) {
      final parts = widget.tanggal.split('-');
      if (parts.length == 3 && parts[0].length == 2) {
        formatTanggalKejadian = "${parts[2]}-${parts[1]}-${parts[0]}";
      }
    }

    final body = {
      'id_pengguna': 1,
      'nama_pelapor': 'Revitaaa',
      'kategori': widget.kategori,
      'sebagai': widget.sebagai,
      'lokasi_kejadian': widget.lokasi,
      'tanggal_kejadian': formatTanggalKejadian,
      'kronologi': widget.kronologi,
      'bukti_lampiran': widget.files.isNotEmpty ? widget.files.join(', ') : null,
    };

    try {
      final res = await http.post(
        Uri.parse('${AppTheme.apiUrl}/lapor'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      print('STATUS: ${res.statusCode}');
      print('RESPONSE: ${res.body}');

      final data = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        if (data['status'] == 'success' && data['data'] != null) {
          idNomor = 'LAP-${data['data']['id_laporan'] ?? data['data']['nomor_laporan']}';
        }
        if (!mounted) return;
        setState(() => _loading = false);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => SuksesPage(nomorLaporan: idNomor)),
        );
      } else {
        if (!mounted) return;
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan: ${data['message'] ?? res.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('ERROR CONNECTION: $e');
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kesalahan jaringan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      showBackButton: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            // Kotak Tanya Konfirmasi
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F9FD),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: AppTheme.primaryPink,
                    child: Icon(Icons.assignment_turned_in, color: Colors.white, size: 24),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Apakah Anda yakin ingin\nmengirim laporan ini?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pastikan semua data sudah benar sebelum dikirim.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppTheme.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Ringkasan Data
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFEBEBF0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _row('Kategori', widget.kategori),
                  const SizedBox(height: 8),
                  _row('Lokasi', widget.lokasi),
                  const SizedBox(height: 8),
                  _row('Tanggal', widget.tanggal),
                  const SizedBox(height: 8),
                  _row('Berkas', '${widget.files.length} file terlampir'),
                ],
              ),
            ),
            const Spacer(),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.primaryPink),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Batal',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppTheme.primaryPink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryPink,
                      ),
                      onPressed: _loading ? null : _kirimLaporan,
                      child: _loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Kirim',
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _row(String l, String v) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              l,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppTheme.textGrey,
              ),
            ),
          ),
          Text(': ', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppTheme.textGrey)),
          Expanded(
            child: Text(
              v,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
}