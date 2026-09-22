import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'screens/login_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SahabatPPAApp());
}

// =========================================================================
// PALET WARNA & TEMA FIGMA
// =========================================================================
class AppTheme {
  // Endpoint API ke database db_workshop di Laragon
  static const String apiUrl = 'http://localhost/api_pelaporan/laporan.php';

  static const Color primaryPink = Color(0xFFE0245E);
  static const Color headerPink = Color(0xFFFF4B72);
  static const Color bgLight = Color(0xFFFBFBFD);
  static const Color cardBg = Colors.white;
  static const Color textDark = Color(0xFF2D2D2D);
  static const Color textGrey = Color(0xFF8A8A8E);
  static const Color borderPink = Color(0xFFFFD2DC);
  static const Color successGreen = Color(0xFF10B981);

  static const Color badgeYellowBg = Color(0xFFFFF8E6);
  static const Color badgeYellowText = Color(0xFFF5A623);
  static const Color badgeBlueBg = Color(0xFFEFF6FF);
  static const Color badgeBlueText = Color(0xFF2563EB);
  static const Color badgeGreenBg = Color(0xFFECFDF5);
  static const Color badgeGreenText = Color(0xFF059669);
}

class SahabatPPAApp extends StatelessWidget {
  const SahabatPPAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Sahabat PPA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppTheme.bgLight,
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: LoginScreen(
        onLoginSuccess: () {
          navigatorKey.currentState!.pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MainNavigationScreen(),
            ),
          );
        },
      ),
    );
  }
}

// =========================================================================
// WAVY HEADER CLIPPER
// =========================================================================
class WavyHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 35);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 20);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width * 0.75, size.height - 45);
    var secondEndPoint = Offset(size.width, size.height - 15);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// =========================================================================
// BASE CONTAINER DENGAN HEADER FIGMA
// =========================================================================
class FigmaScaffold extends StatelessWidget {
  final Widget child;
  final bool showBackButton;
  final VoidCallback? onBack;
  final String? headerTitle;
  final Widget? headerAction;

  const FigmaScaffold({
    super.key,
    required this.child,
    this.showBackButton = false,
    this.onBack,
    this.headerTitle,
    this.headerAction,
  });

  void _showNotificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.notifications_active, color: AppTheme.primaryPink),
            const SizedBox(width: 8),
            Text('Notifikasi',
                style:
                    GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Layanan Sahabat PPA aktif 24 jam untuk mendampingi dan melindungi.',
          style: GoogleFonts.plusJakartaSans(
              fontSize: 13, color: AppTheme.textDark),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Tutup',
                style: GoogleFonts.plusJakartaSans(
                    color: AppTheme.primaryPink, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Profil Pengguna',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama: Revitaaa',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text('Status: Terverifikasi',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 12, color: AppTheme.textGrey)),
            const SizedBox(height: 4),
            Text('Database: MySQL Laragon (db_workshop)',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 11, color: AppTheme.primaryPink)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Selesai',
                style: GoogleFonts.plusJakartaSans(
                    color: AppTheme.primaryPink, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: Stack(
        children: [
          ClipPath(
            clipper: WavyHeaderClipper(),
            child: Container(
              height: 165,
              width: double.infinity,
              color: AppTheme.headerPink,
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          showBackButton
                              ? GestureDetector(
                                  onTap: onBack ?? () => Navigator.pop(context),
                                  child: Container(
                                    width: 34,
                                    height: 34,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.25),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.chevron_left,
                                        color: Colors.white, size: 24),
                                  ),
                                )
                              : const SizedBox(width: 34),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.notifications_none,
                                    color: Colors.white, size: 24),
                                onPressed: () =>
                                    _showNotificationDialog(context),
                              ),
                              GestureDetector(
                                onTap: () => _showProfileDialog(context),
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.person,
                                      color: AppTheme.headerPink, size: 18),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (headerTitle != null) ...[
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              headerTitle!,
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (headerAction != null) headerAction!,
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 105),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// MAIN NAVIGATION (BOTTOM NAVBAR)
// =========================================================================
class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;
  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _navIndex;

  @override
  void initState() {
    super.initState();
    _navIndex = widget.initialIndex;
  }

  void _pindahKeTab(int index) {
    setState(() => _navIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;
    if (_navIndex == 0) {
      bodyContent = HomeScreenContent(onTabChange: _pindahKeTab);
    } else if (_navIndex == 1) {
      bodyContent = const RiwayatScreenContent();
    } else {
      bodyContent = const ProfilScreenContent();
    }

    return Scaffold(
      body: bodyContent,
      bottomNavigationBar: Container(
        height: 68,
        decoration: const BoxDecoration(
          color: AppTheme.headerPink,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(26),
            topRight: Radius.circular(26),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home,
                  color: _navIndex == 0 ? Colors.white : Colors.white60,
                  size: 28),
              onPressed: () => _pindahKeTab(0),
            ),
            IconButton(
              icon: Icon(Icons.description_outlined,
                  color: _navIndex == 1 ? Colors.white : Colors.white60,
                  size: 26),
              onPressed: () => _pindahKeTab(1),
            ),
            IconButton(
              icon: Icon(Icons.person_outline,
                  color: _navIndex == 2 ? Colors.white : Colors.white60,
                  size: 26),
              onPressed: () => _pindahKeTab(2),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// 1. BERANDA (SCREEN 1)
// =========================================================================
class HomeScreenContent extends StatefulWidget {
  final Function(int) onTabChange;
  const HomeScreenContent({super.key, required this.onTabChange});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  Map<String, dynamic>? _laporanTerakhir;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _ambilLaporanTerakhir();
  }

  Future<void> _ambilLaporanTerakhir() async {
    setState(() => _isLoading = true);
    try {
      final res = await http.get(Uri.parse(AppTheme.apiUrl));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['status'] == true && (data['data'] as List).isNotEmpty) {
          setState(() {
            _laporanTerakhir = data['data'][0];
            _isLoading = false;
          });
          return;
        }
      }
    } catch (_) {}
    setState(() {
      _laporanTerakhir = null;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FigmaScaffold(
      showBackButton: false,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.borderPink, width: 1.2),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F3F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person,
                      color: AppTheme.primaryPink, size: 28),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Selamat datang,',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 12, color: AppTheme.textGrey)),
                    const SizedBox(height: 2),
                    Text('Revitaaa',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark)),
                    const SizedBox(height: 2),
                    Text('Pengguna',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 11, color: AppTheme.textGrey)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              final hasil = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FormStep1Screen()),
              );
              if (hasil == true) {
                _ambilLaporanTerakhir();
              }
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.borderPink, width: 1.2),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEEF2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.assignment_outlined,
                        color: AppTheme.primaryPink, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Buat Laporan',
                            style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppTheme.textDark)),
                        const SizedBox(height: 2),
                        Text('Laporkan kejadian dengan aman',
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 11, color: AppTheme.textGrey)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppTheme.textGrey),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status Laporan Terakhir',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.refresh,
                    size: 20, color: AppTheme.primaryPink),
                onPressed: _ambilLaporanTerakhir,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _isLoading
              ? const Center(
                  child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(
                          color: AppTheme.primaryPink)))
              : _laporanTerakhir == null
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF0F0F2)),
                      ),
                      child: Center(
                        child: Text('Belum ada laporan aktif',
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 12, color: AppTheme.textGrey)),
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProgressLaporanScreen(
                                  laporan: _laporanTerakhir!)),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFF0F0F2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('LAP-${_laporanTerakhir!['id_laporan']}',
                                    style: GoogleFonts.plusJakartaSans(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: AppTheme.primaryPink)),
                                Text(
                                  _laporanTerakhir!['tanggal_lapor'] != null
                                      ? _laporanTerakhir!['tanggal_lapor']
                                          .toString()
                                          .substring(0, 10)
                                      : '12 Mei 2025',
                                  style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11, color: AppTheme.textGrey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppTheme.badgeYellowBg,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _laporanTerakhir!['status_penanganan'] ??
                                    'Menunggu Verifikasi',
                                style: GoogleFonts.plusJakartaSans(
                                    color: AppTheme.badgeYellowText,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => widget.onTabChange(1),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF0F0F2)),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.history,
                            color: AppTheme.primaryPink, size: 24),
                        const SizedBox(height: 8),
                        Text('Riwayat Laporan',
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textDark)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EdukasiScreen()),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF0F0F2)),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.menu_book_outlined,
                            color: AppTheme.primaryPink, size: 24),
                        const SizedBox(height: 8),
                        Text('Informasi & Edukasi',
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textDark)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// 2. DAFTAR RIWAYAT LAPORAN (CRUD: READ, UPDATE DIALOG, DELETE)
// =========================================================================
class RiwayatScreenContent extends StatefulWidget {
  const RiwayatScreenContent({super.key});

  @override
  State<RiwayatScreenContent> createState() => _RiwayatScreenContentState();
}

class _RiwayatScreenContentState extends State<RiwayatScreenContent> {
  List<dynamic> _listLaporan = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _muatData();
  }

  Future<void> _muatData() async {
    setState(() => _isLoading = true);
    try {
      final res = await http.get(Uri.parse(AppTheme.apiUrl));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['status'] == true && data['data'] != null) {
          setState(() {
            _listLaporan = data['data'];
            _isLoading = false;
          });
          return;
        }
      }
    } catch (_) {}
    setState(() {
      _listLaporan = [];
      _isLoading = false;
    });
  }

  Future<void> _updateLaporan(int id, String kategoriBaru, String lokasiBaru,
      String kronologiBaru) async {
    final payload = {
      'id_laporan': id,
      'kategori': kategoriBaru,
      'lokasi_kejadian': lokasiBaru,
      'kronologi': kronologiBaru,
    };

    await http.put(
      Uri.parse(AppTheme.apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    _muatData();
  }

  Future<void> _hapusLaporan(int id) async {
    await http.delete(Uri.parse('${AppTheme.apiUrl}?id=$id'));
    _muatData();
  }

  void _dialogEdit(Map<String, dynamic> item) {
    String kategori = item['kategori'] ?? 'Kekerasan terhadap Perempuan';
    final lokasiCtrl =
        TextEditingController(text: item['lokasi_kejadian'] ?? '');
    final kronologiCtrl = TextEditingController(text: item['kronologi'] ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Edit Data Laporan',
            style: GoogleFonts.plusJakartaSans(
                fontSize: 16, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: [
                  'Kekerasan terhadap Perempuan',
                  'Kekerasan terhadap Anak',
                  'Pelecehan Seksual',
                  'Kekerasan Dalam Rumah Tangga (KDRT)'
                ].contains(kategori)
                    ? kategori
                    : 'Kekerasan terhadap Perempuan',
                items: [
                  'Kekerasan terhadap Perempuan',
                  'Kekerasan terhadap Anak',
                  'Pelecehan Seksual',
                  'Kekerasan Dalam Rumah Tangga (KDRT)'
                ]
                    .map((k) => DropdownMenuItem(
                        value: k,
                        child: Text(k,
                            style: GoogleFonts.plusJakartaSans(fontSize: 12))))
                    .toList(),
                onChanged: (v) => kategori = v!,
                decoration: const InputDecoration(
                    labelText: 'Kategori',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10)),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: lokasiCtrl,
                style: GoogleFonts.plusJakartaSans(fontSize: 13),
                decoration: const InputDecoration(
                    labelText: 'Lokasi Kejadian',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10)),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: kronologiCtrl,
                maxLines: 3,
                style: GoogleFonts.plusJakartaSans(fontSize: 13),
                decoration: const InputDecoration(
                    labelText: 'Kronologi Kejadian',
                    contentPadding: EdgeInsets.all(10)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Batal', style: GoogleFonts.plusJakartaSans())),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryPink),
            onPressed: () {
              Navigator.pop(ctx);
              _updateLaporan(int.parse(item['id_laporan'].toString()), kategori,
                  lokasiCtrl.text, kronologiCtrl.text);
            },
            child: Text('Simpan Perubahan',
                style: GoogleFonts.plusJakartaSans(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FigmaScaffold(
      showBackButton: false,
      headerTitle: 'Daftar Riwayat Laporan',
      headerAction: IconButton(
        icon: const Icon(Icons.refresh, color: Colors.white),
        onPressed: _muatData,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryPink))
            : _listLaporan.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.description_outlined,
                            size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          'Belum ada riwayat laporan.',
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: AppTheme.textGrey,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Laporan yang Anda kirim akan otomatis muncul di sini.',
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 11, color: AppTheme.textGrey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _listLaporan.length,
                    itemBuilder: (ctx, i) {
                      final item = _listLaporan[i];
                      final status = item['status_penanganan'] ?? 'Menunggu';

                      Color badgeBg = AppTheme.badgeYellowBg;
                      Color badgeText = AppTheme.badgeYellowText;
                      if (status == 'Diproses') {
                        badgeBg = AppTheme.badgeBlueBg;
                        badgeText = AppTheme.badgeBlueText;
                      } else if (status == 'Selesai') {
                        badgeBg = AppTheme.badgeGreenBg;
                        badgeText = AppTheme.badgeGreenText;
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFF0F0F2)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          DetailLaporanScreen(laporan: item),
                                    ),
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('LAP-${item['id_laporan']}',
                                        style: GoogleFonts.plusJakartaSans(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: AppTheme.primaryPink)),
                                    const SizedBox(height: 3),
                                    Text(item['kategori'] ?? '',
                                        style: GoogleFonts.plusJakartaSans(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12)),
                                    const SizedBox(height: 2),
                                    Text(
                                      item['tanggal_lapor'] != null
                                          ? item['tanggal_lapor']
                                              .toString()
                                              .substring(0, 10)
                                          : '12 Mei 2025',
                                      style: GoogleFonts.plusJakartaSans(
                                          fontSize: 10,
                                          color: AppTheme.textGrey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: badgeBg,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(status,
                                  style: GoogleFonts.plusJakartaSans(
                                      color: badgeText,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold)),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined,
                                  color: Colors.amber, size: 20),
                              onPressed: () => _dialogEdit(item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red, size: 20),
                              onPressed: () => _hapusLaporan(
                                  int.parse(item['id_laporan'].toString())),
                            ),
                            const Icon(Icons.chevron_right,
                                color: AppTheme.textGrey, size: 20),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

// =========================================================================
// 3. FORM STEP 1
// =========================================================================
class FormStep1Screen extends StatefulWidget {
  const FormStep1Screen({super.key});

  @override
  State<FormStep1Screen> createState() => _FormStep1ScreenState();
}

class _FormStep1ScreenState extends State<FormStep1Screen> {
  String _kategori = 'Kekerasan terhadap Perempuan';
  String _sebagai = 'Korban';
  final TextEditingController _lokasiController =
      TextEditingController(text: 'Jember');
  final TextEditingController _tanggalController =
      TextEditingController(text: '12 Mei 2025');
  final TextEditingController _penjelasanController = TextEditingController();

  final List<String> _listKategori = [
    'Kekerasan terhadap Perempuan',
    'Kekerasan terhadap Anak',
    'Pelecehan Seksual',
    'Kekerasan Dalam Rumah Tangga (KDRT)',
  ];

  final List<String> _listSebagai = ['Korban', 'Saksi', 'Keluarga Korban'];

  @override
  Widget build(BuildContext context) {
    return FigmaScaffold(
      showBackButton: true,
      headerTitle: 'Form Pelaporan',
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        children: [
          _buildFieldLabel('Kategori Laporan'),
          _buildDropdownContainer(
            DropdownButton<String>(
              isExpanded: true,
              value: _kategori,
              underline: const SizedBox(),
              icon: const Icon(Icons.keyboard_arrow_down,
                  color: AppTheme.textGrey),
              items: _listKategori
                  .map((k) => DropdownMenuItem(
                      value: k,
                      child: Text(k,
                          style: GoogleFonts.plusJakartaSans(fontSize: 13))))
                  .toList(),
              onChanged: (v) => setState(() => _kategori = v!),
            ),
          ),
          const SizedBox(height: 14),
          _buildFieldLabel('Sebagai'),
          _buildDropdownContainer(
            DropdownButton<String>(
              isExpanded: true,
              value: _sebagai,
              underline: const SizedBox(),
              icon: const Icon(Icons.keyboard_arrow_down,
                  color: AppTheme.textGrey),
              items: _listSebagai
                  .map((s) => DropdownMenuItem(
                      value: s,
                      child: Text(s,
                          style: GoogleFonts.plusJakartaSans(fontSize: 13))))
                  .toList(),
              onChanged: (v) => setState(() => _sebagai = v!),
            ),
          ),
          const SizedBox(height: 14),
          _buildFieldLabel('Lokasi Kejadian'),
          _buildInputBox(
              _lokasiController, 'Pilih lokasi', Icons.location_on_outlined),
          const SizedBox(height: 14),
          _buildFieldLabel('Tanggal Kejadian'),
          _buildInputBox(_tanggalController, 'Pilih tanggal',
              Icons.calendar_today_outlined),
          const SizedBox(height: 14),
          _buildFieldLabel('Penjelasan Kejadian'),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderPink),
            ),
            child: TextField(
              controller: _penjelasanController,
              maxLines: 4,
              style: GoogleFonts.plusJakartaSans(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Jelaskan kronologi kejadian...',
                hintStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 12, color: AppTheme.textGrey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryPink,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              onPressed: () async {
                final hasil = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FormStep2UploadScreen(
                      kategori: _kategori,
                      sebagai: _sebagai,
                      lokasi: _lokasiController.text,
                      tanggal: _tanggalController.text,
                      penjelasan: _penjelasanController.text.isNotEmpty
                          ? _penjelasanController.text
                          : 'Saya mengalami tindakan kekerasan oleh seseorang di tempat umum...',
                    ),
                  ),
                );
                if (hasil == true && mounted) {
                  Navigator.pop(context, true);
                }
              },
              child: Text('Lanjut',
                  style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(label,
          style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark)),
    );
  }

  Widget _buildDropdownContainer(Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderPink),
      ),
      child: child,
    );
  }

  Widget _buildInputBox(
      TextEditingController ctrl, String hint, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderPink),
      ),
      child: TextField(
        controller: ctrl,
        style: GoogleFonts.plusJakartaSans(fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: AppTheme.primaryPink, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

// =========================================================================
// 4. FORM STEP 2: UPLOAD
// =========================================================================
class FormStep2UploadScreen extends StatefulWidget {
  final String kategori;
  final String sebagai;
  final String lokasi;
  final String tanggal;
  final String penjelasan;

  const FormStep2UploadScreen({
    super.key,
    required this.kategori,
    required this.sebagai,
    required this.lokasi,
    required this.tanggal,
    required this.penjelasan,
  });

  @override
  State<FormStep2UploadScreen> createState() => _FormStep2UploadScreenState();
}

class _FormStep2UploadScreenState extends State<FormStep2UploadScreen> {
  String? uploadedFileName = 'bukti.jpg';
  String fileSize = '2.4 MB';

  @override
  Widget build(BuildContext context) {
    return FigmaScaffold(
      showBackButton: true,
      headerTitle: 'Upload Bukti',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppTheme.primaryPink.withOpacity(0.6), width: 1.5),
              ),
              child: Column(
                children: [
                  const Icon(Icons.cloud_upload_outlined,
                      color: AppTheme.primaryPink, size: 40),
                  const SizedBox(height: 10),
                  Text('Pilih gambar atau dokumen',
                      style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: AppTheme.textDark)),
                  const SizedBox(height: 3),
                  Text('(JPG, PNG, PDF)',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 11, color: AppTheme.textGrey)),
                  const SizedBox(height: 2),
                  Text('Maks. 10 MB',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 10, color: AppTheme.textGrey)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryPink,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      elevation: 0,
                    ),
                    onPressed: () {
                      setState(() {
                        uploadedFileName = 'bukti.jpg';
                        fileSize = '2.4 MB';
                      });
                    },
                    child: Text('Pilih File',
                        style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Text('File yang diunggah',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark)),
            const SizedBox(height: 10),
            if (uploadedFileName != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.insert_drive_file_outlined,
                        color: AppTheme.textDark, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(uploadedFileName!,
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textDark)),
                          Text(fileSize,
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10, color: AppTheme.textGrey)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => uploadedFileName = null),
                      child: const Icon(Icons.close,
                          size: 18, color: AppTheme.textGrey),
                    ),
                  ],
                ),
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryPink,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () async {
                  final hasil = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ConfirmationScreen(
                        kategori: widget.kategori,
                        sebagai: widget.sebagai,
                        lokasi: widget.lokasi,
                        tanggal: widget.tanggal,
                        penjelasan: widget.penjelasan,
                      ),
                    ),
                  );
                  if (hasil == true && mounted) {
                    Navigator.pop(context, true);
                  }
                },
                child: Text('Lanjut',
                    style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// 5. KONFIRMASI PENGIRIMAN
// =========================================================================
class ConfirmationScreen extends StatefulWidget {
  final String kategori;
  final String sebagai;
  final String lokasi;
  final String tanggal;
  final String penjelasan;

  const ConfirmationScreen({
    super.key,
    required this.kategori,
    required this.sebagai,
    required this.lokasi,
    required this.tanggal,
    required this.penjelasan,
  });

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  bool _isLoading = false;

  Future<void> _kirimLaporan() async {
    setState(() => _isLoading = true);

    String idLaporanGenerated = 'LAP-001';
    final payload = {
      'id_pengguna': 1,
      'nama_pelapor': 'Revitaaa',
      'kategori': widget.kategori,
      'judul_kasus': widget.kategori,
      'kronologi': widget.penjelasan,
      'lokasi_kejadian': widget.lokasi,
    };

    try {
      final res = await http.post(
        Uri.parse(AppTheme.apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );
      final data = jsonDecode(res.body);
      if (data['status'] == true && data['id_laporan'] != null) {
        idLaporanGenerated = 'LAP-${data['id_laporan']}';
      }
    } catch (_) {}

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SuccessSubmitScreen(
          nomorLaporan: idLaporanGenerated,
          kategori: widget.kategori,
          lokasi: widget.lokasi,
          tanggal: widget.tanggal,
          kronologi: widget.penjelasan,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FigmaScaffold(
      showBackButton: true,
      headerTitle: 'Konfirmasi Laporan',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F9FD),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryPink,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.assignment_turned_in_outlined,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Apakah Anda yakin ingin\nmengirim laporan ini?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pastikan semua data sudah benar sebelum dikirim.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 11, color: AppTheme.textGrey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Data Laporan',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark)),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFEBEBF0)),
              ),
              child: Column(
                children: [
                  _buildSummaryRow('Kategori', widget.kategori),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Lokasi', widget.lokasi),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Tanggal', widget.tanggal),
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text('Batal',
                          style: GoogleFonts.plusJakartaSans(
                              color: AppTheme.primaryPink,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryPink,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      onPressed: _isLoading ? null : _kirimLaporan,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : Text('Kirim',
                              style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text(label,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 12, color: AppTheme.textGrey)),
        ),
        Text(': ',
            style: GoogleFonts.plusJakartaSans(
                fontSize: 12, color: AppTheme.textGrey)),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark),
          ),
        ),
      ],
    );
  }
}

// =========================================================================
// [LAYAR 1 FIGMA]: LAPORAN BERHASIL DIKIRIM
// =========================================================================
class SuccessSubmitScreen extends StatelessWidget {
  final String nomorLaporan;
  final String kategori;
  final String lokasi;
  final String tanggal;
  final String kronologi;

  const SuccessSubmitScreen({
    super.key,
    required this.nomorLaporan,
    required this.kategori,
    required this.lokasi,
    required this.tanggal,
    required this.kronologi,
  });

  @override
  Widget build(BuildContext context) {
    return FigmaScaffold(
      showBackButton: true,
      onBack: () => Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const MainNavigationScreen())),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: AppTheme.successGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 18),
            Text(
              'Laporan Berhasil Dikirim',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.successGreen),
            ),
            const SizedBox(height: 6),
            Text(
              'Laporan Anda telah diterima dan akan diverifikasi oleh petugas.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 12, color: AppTheme.textGrey),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Text('NOMOR LAPORAN',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textGrey)),
                  const SizedBox(height: 4),
                  Text(nomorLaporan,
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryPink)),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryPink,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProgressLaporanScreen(
                        laporan: {
                          'id_laporan': nomorLaporan.replaceAll('LAP-', ''),
                          'kategori': kategori,
                          'lokasi_kejadian': lokasi,
                          'kronologi': kronologi,
                        },
                      ),
                    ),
                  );
                },
                child: Text('Lihat Status Laporan',
                    style: GoogleFonts.plusJakartaSans(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.primaryPink),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const MainNavigationScreen())),
                child: Text('Kembali ke Beranda',
                    style: GoogleFonts.plusJakartaSans(
                        color: AppTheme.primaryPink,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// [LAYAR 2 FIGMA]: PROGRES LAPORAN ANDA (TIMELINE)
// =========================================================================
class ProgressLaporanScreen extends StatelessWidget {
  final Map<String, dynamic> laporan;
  const ProgressLaporanScreen({super.key, required this.laporan});

  @override
  Widget build(BuildContext context) {
    return FigmaScaffold(
      showBackButton: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Progres Laporan Anda',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryPink)),
            const SizedBox(height: 24),
            _buildTimelineStep(
              icon: Icons.check_circle_outline,
              iconColor: const Color(0xFF0EA5E9),
              title: 'Laporan Dikirim',
              subtitle: '12 Mei 2025, 10:00',
              isActive: true,
            ),
            _buildTimelineStep(
              icon: Icons.access_time,
              iconColor: AppTheme.badgeYellowText,
              title: 'Menunggu Verifikasi',
              subtitle: '12 Mei 2025, 11:00',
              isActive: true,
            ),
            _buildTimelineStep(
              icon: Icons.refresh,
              iconColor: Colors.grey.shade400,
              title: 'Diproses',
              subtitle: '-',
              isActive: false,
            ),
            _buildTimelineStep(
              icon: Icons.assignment_turned_in_outlined,
              iconColor: Colors.grey.shade400,
              title: 'Selesai',
              subtitle: '-',
              isActive: false,
              isLast: true,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.primaryPink),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DetailLaporanScreen(laporan: laporan)),
                  );
                },
                child: Text('Lihat Detail',
                    style: GoogleFonts.plusJakartaSans(
                        color: AppTheme.primaryPink,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineStep({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool isActive,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isActive ? AppTheme.textDark : AppTheme.textGrey)),
            const SizedBox(height: 2),
            Text(subtitle,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 11, color: AppTheme.textGrey)),
          ],
        ),
      ],
    );
  }
}

// =========================================================================
// [LAYAR 3 FIGMA]: DETAIL LAPORAN
// =========================================================================
class DetailLaporanScreen extends StatelessWidget {
  final Map<String, dynamic> laporan;
  const DetailLaporanScreen({super.key, required this.laporan});

  void _kembaliKeRiwayat(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const MainNavigationScreen(initialIndex: 1),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FigmaScaffold(
      showBackButton: true,
      headerTitle: 'Detail Laporan',
      onBack: () => _kembaliKeRiwayat(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF0F0F2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'LAP-${laporan['id_laporan']}',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppTheme.primaryPink,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.badgeYellowBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          laporan['status_penanganan'] ?? 'Menunggu Verifikasi',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppTheme.badgeYellowText,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  _buildDetailItem('Kategori',
                      laporan['kategori'] ?? 'Kekerasan terhadap Perempuan'),
                  const SizedBox(height: 10),
                  _buildDetailItem(
                    'Tanggal Kejadian',
                    laporan['tanggal_lapor'] != null
                        ? laporan['tanggal_lapor'].toString().substring(0, 10)
                        : '12 Mei 2025',
                  ),
                  const SizedBox(height: 10),
                  _buildDetailItem('Lokasi Kejadian',
                      laporan['lokasi_kejadian'] ?? 'Jember'),
                  const SizedBox(height: 10),
                  _buildDetailItem(
                    'Kronologi',
                    laporan['kronologi'] ??
                        'Saya mengalami tindakan kekerasan oleh seseorang di tempat umum...',
                  ),
                  const SizedBox(height: 12),
                  Text('Bukti',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 11, color: AppTheme.textGrey)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 48,
                          height: 48,
                          color: const Color(0xFFF1F3F6),
                          child: const Icon(Icons.image,
                              color: Colors.grey, size: 28),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text('bukti.jpg',
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textDark)),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.primaryPink),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => _kembaliKeRiwayat(context),
                child: Text('Kembali',
                    style: GoogleFonts.plusJakartaSans(
                        color: AppTheme.primaryPink,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 11, color: AppTheme.textGrey)),
        const SizedBox(height: 2),
        Text(content,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark)),
      ],
    );
  }
}

// =========================================================================
// INFORMASI & EDUKASI
// =========================================================================
class EdukasiScreen extends StatelessWidget {
  const EdukasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FigmaScaffold(
      showBackButton: true,
      headerTitle: 'Informasi & Edukasi',
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFF0F3), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.borderPink),
            ),
            child: Row(
              children: [
                const Icon(Icons.shield_outlined,
                    color: AppTheme.primaryPink, size: 36),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sahabat Perlindungan Perempuan & Anak',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ketahui hak Anda dan kenali langkah aman dalam menghadapi tindak kekerasan.',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 11, color: AppTheme.textGrey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text('Hotline Layanan Cepat Tanggap',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildEmergencyContact(
                  icon: Icons.phone_in_talk,
                  label: 'SAPA 129',
                  desc: 'KemenPPPA (Bebas Pulsa)',
                  color: AppTheme.primaryPink,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildEmergencyContact(
                  icon: Icons.local_police_outlined,
                  label: 'Polisi 110',
                  desc: 'Layanan Darurat Polri',
                  color: const Color(0xFF0284C7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text('Panduan & Pengetahuan Hukum',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark)),
          const SizedBox(height: 10),
          _buildEduAccordion(
            title: '1. UU Tindak Pidana Kekerasan Seksual (UU TPKS)',
            desc:
                'UU No. 12 Tahun 2022 menjamin pencegahan, penanganan, perlindungan, dan pemulihan hak korban serta penegakan hukum bagi pelaku.',
            icon: Icons.gavel_outlined,
          ),
          _buildEduAccordion(
            title: '2. Hak Korban dan Kerahasiaan Identitas',
            desc:
                'Setiap pelapor/korban berhak mendapatkan pendampingan psikologis, bantuan hukum gratis, serta jaminan kerahasiaan identitas.',
            icon: Icons.lock_outline,
          ),
          _buildEduAccordion(
            title: '3. Langkah Penting Saat Mengalami Kasus',
            desc:
                '• Amankan diri terlebih dahulu ke tempat yang aman.\n• Simpan bukti-bukti (pesan teks, visum, atau foto).\n• Laporkan segera melalui aplikasi Sahabat PPA atau hotline resmi.',
            icon: Icons.health_and_safety_outlined,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildEmergencyContact(
      {required IconData icon,
      required String label,
      required String desc,
      required Color color}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF0F0F2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(label,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark)),
          const SizedBox(height: 2),
          Text(desc,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 10.5, color: AppTheme.textGrey)),
        ],
      ),
    );
  }

  Widget _buildEduAccordion(
      {required String title, required String desc, required IconData icon}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF0F0F2)),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        leading: Icon(icon, color: AppTheme.primaryPink, size: 22),
        title: Text(title,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark)),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(desc,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 12, color: const Color(0xFF475569), height: 1.5)),
        ],
      ),
    );
  }
}

// =========================================================================
// 6. PROFIL SCREEN (TAB KE-3)
// =========================================================================
class ProfilScreenContent extends StatelessWidget {
  const ProfilScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return FigmaScaffold(
      showBackButton: false,
      headerTitle: 'Profil Pengguna',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Center(
              child: Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFEEF2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person,
                    size: 40, color: AppTheme.primaryPink),
              ),
            ),
            const SizedBox(height: 12),
            Text('Revitaaa',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark)),
            Text('revita@student.ac.id',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 12, color: AppTheme.textGrey)),
            const SizedBox(height: 28),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF0F0F2)),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading:
                        const Icon(Icons.security, color: AppTheme.primaryPink),
                    title: Text('Perlindungan & Privasi Data',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.chevron_right,
                        color: AppTheme.textGrey),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.storage_outlined,
                        color: AppTheme.primaryPink),
                    title: Text('Status Database (Laragon)',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: Text('Terkoneksi ke db_workshop',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 11, color: Colors.green)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
