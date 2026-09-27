import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../main/home.dart';
import '../main/riwayat.dart';
import '../main/profil.dart';

class NavbarPage extends StatefulWidget {
  final int initialIndex;
  const NavbarPage({super.key, this.initialIndex = 0});

  @override
  State<NavbarPage> createState() => _NavbarPageState();
}

class _NavbarPageState extends State<NavbarPage> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
  }) {
    final bool isSelected = _index == index;

    return GestureDetector(
      onTap: () => setState(() => _index = index),
      behavior: HitTestBehavior.opaque,
      child: isSelected
          // Tombol aktif: Digeser ke atas (-18px) agar menonjol keluar dari navbar
          ? Transform.translate(
              offset: const Offset(0, -18),
              child: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: AppTheme.headerPink,
                  size: 28,
                ),
              ),
            )
          // Tombol tidak aktif: Posisi normal di tengah bar
          : SizedBox(
              width: 58,
              height: 58,
              child: Icon(
                icon,
                color: Colors.white.withOpacity(0.75),
                size: 26,
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (_index == 0) {
      content = HomePage(onTabChange: (i) => setState(() => _index = i));
    } else if (_index == 1) {
      content = const RiwayatPage();
    } else {
      content = const ProfilPage();
    }

    return Scaffold(
      body: content,
      bottomNavigationBar: Container(
        height: 65,
        decoration: const BoxDecoration(
          color: AppTheme.headerPink,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(26),
            topRight: Radius.circular(26),
          ),
        ),
        // Stack dengan clipBehavior.none mengizinkan tombol keluar dari batas atas Container
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home_outlined,
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.description_outlined,
                  index: 1,
                ),
                _buildNavItem(
                  icon: Icons.person_outline,
                  index: 2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}