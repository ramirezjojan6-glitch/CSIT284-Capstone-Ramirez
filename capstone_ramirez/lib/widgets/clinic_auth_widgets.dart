import 'package:flutter/material.dart';

const clinicMaroon = Color(0xFF7A3330);
const clinicOrange = Color(0xFFF4A340);

class ClinicAuthBackground extends StatelessWidget {
  const ClinicAuthBackground({required this.headline, super.key});

  final String headline;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/clinic.webp',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
            Positioned(
              top: constraints.maxHeight * 0.14,
              right: 14,
              left: constraints.maxWidth * 0.16,
              child: Text(
                headline,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: constraints.maxWidth < 360 ? 24 : 30,
                  height: 1.08,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ClinicAuthInput extends StatelessWidget {
  const ClinicAuthInput({
    required this.hintText,
    this.keyboardType,
    this.obscureText = false,
    super.key,
  });

  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: TextField(
        keyboardType: keyboardType,
        obscureText: obscureText,
        textAlign: TextAlign.center,
        cursorColor: clinicMaroon,
        style: const TextStyle(color: clinicMaroon, fontSize: 13),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: clinicMaroon, fontSize: 13),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: clinicOrange, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: clinicOrange, width: 2),
          ),
        ),
      ),
    );
  }
}

