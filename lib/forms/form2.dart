import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:html' as html;
import '../core/theme.dart';
import '../widgets/header.dart';
import 'konfirmasi.dart';

class Form2Page extends StatefulWidget {
  final String kategori;
  final String sebagai;
  final String lokasi;
  final String tanggal;
  final String kronologi;

  const Form2Page({
    super.key,
    required this.kategori,
    required this.sebagai,
    required this.lokasi,
    required this.tanggal,
    required this.kronologi,
  });

  @override
  State<Form2Page> createState() => _Form2PageState();
}

class _Form2PageState extends State<Form2Page> {
  final List<String> _listFoto = [];

  void _bukaPilihFoto() {
    if (_listFoto.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Maksimal 3 foto!',
            style: GoogleFonts.plusJakartaSans(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (kIsWeb) {
      final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.multiple = true;
      uploadInput.click();

      uploadInput.onChange.listen((e) {
        final files = uploadInput.files;
        if (files != null && files.isNotEmpty) {
          setState(() {
            for (var file in files) {
              if (_listFoto.length < 3) {
                _listFoto.add(file.name);
              }
            }
          });
        }
      });
    } else {
      setState(() {
        _listFoto.add("foto_bukti_${_listFoto.length + 1}.jpg");
      });
    }
  }

  void _hapusFoto(int index) {
    setState(() {
      _listFoto.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      showBackButton: true,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          // Area Kotak Pilih Foto
          InkWell(
            onTap: _bukaPilihFoto,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.borderPink, width: 1.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 46,
                    color: AppTheme.primaryPink,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Pilih Foto Bukti',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Maksimal 3 foto (JPG / PNG)\nKlik untuk memilih foto dari perangkat',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Daftar foto yang dipilih
          if (_listFoto.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              'Foto yang dipilih (${_listFoto.length}/3):',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            ...List.generate(_listFoto.length, (index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.image_outlined,
                        color: AppTheme.primaryPink, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _listFoto[index],
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel,
                          color: AppTheme.primaryPink, size: 18),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => _hapusFoto(index),
                    ),
                  ],
                ),
              );
            }),
          ],

          const SizedBox(height: 32),

          // Tombol Lanjut
          SizedBox(
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryPink,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => KonfirmasiPage(
                      kategori: widget.kategori,
                      sebagai: widget.sebagai,
                      lokasi: widget.lokasi,
                      tanggal: widget.tanggal,
                      kronologi: widget.kronologi,
                      files: _listFoto,
                    ),
                  ),
                );
              },
              child: Text(
                'Lanjut',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}