import 'package:flutter/material.dart';

const clinicMaroon = Color(0xFF7A3330);
const clinicOrange = Color(0xFFF4A340);

class ClinicBackground extends StatelessWidget {
  const ClinicBackground({this.imageOpacity = 0.2, super.key});

  final double imageOpacity;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Opacity(
          opacity: imageOpacity,
          child: const Image(
            image: AssetImage('assets/clinic.webp'),
            fit: BoxFit.cover,
          ),
        ),
        ColoredBox(color: clinicMaroon.withValues(alpha: 0.10)),
      ],
    );
  }
}

class ClinicAuthBackground extends StatelessWidget {
  const ClinicAuthBackground({required this.headline, super.key});

  final String headline;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final logoSize = constraints.maxWidth < 360 ? 56.0 : 76.0;

        return Stack(
          fit: StackFit.expand,
          children: [
            const ClinicBackground(imageOpacity: 0.3),
            Positioned(
              top: constraints.maxHeight * 0.14,
              left: 14,
              child: Image.asset(
                'assets/cit logo.png',
                width: logoSize,
                height: logoSize,
                fit: BoxFit.contain,
                semanticLabel: 'CIT logo',
              ),
            ),
            Positioned(
              top: constraints.maxHeight * 0.14,
              right: 14,
              left: logoSize + 30,
              child: Text(
                headline,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: constraints.maxWidth < 360 ? 30 : 36,
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
    this.controller,
    this.suffixIcon,
    this.enabled = true,
    this.fieldKey,
    super.key,
  });

  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final bool enabled;
  final Key? fieldKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: TextField(
        key: fieldKey,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        enabled: enabled,
        textAlign: TextAlign.center,
        cursorColor: clinicMaroon,
        style: const TextStyle(color: clinicMaroon, fontSize: 13),
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: suffixIcon,
          suffixIconConstraints: const BoxConstraints(
            minWidth: 40,
            maxWidth: 44,
            minHeight: 36,
            maxHeight: 40,
          ),
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

class ClinicAuthButton extends StatelessWidget {
  const ClinicAuthButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 42,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: clinicMaroon,
          side: const BorderSide(color: clinicOrange, width: 1.5),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        ),
        child: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  color: clinicMaroon,
                  strokeWidth: 2,
                ),
              )
            : Text(label),
      ),
    );
  }
}
