import 'package:flutter/material.dart';

class EmailIllustration extends StatelessWidget {
  const EmailIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/email_illustration.png', height: 170, fit: BoxFit.contain);
  }
}

class CardIllustration extends StatelessWidget {
  const CardIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/card_illustration.png', height: 170, fit: BoxFit.contain);
  }
}

class RupeeCoin extends StatelessWidget {
  const RupeeCoin({super.key, this.size = 96});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(color: Color(0xFFFFDD00), shape: BoxShape.circle),
      padding: EdgeInsets.all(size * 0.1),
      child: Container(
        decoration: const BoxDecoration(color: Color(0xFFF0A500), shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Text(
          '₹',
          style: TextStyle(
            fontSize: size * 0.5,
            color: const Color(0xFFFFDD00),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
