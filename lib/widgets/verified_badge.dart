import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class VerifiedBadge extends StatelessWidget {
  final double size;
  const VerifiedBadge({super.key, this.size = 52});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.17, // ~-10deg, matches the mockup's stamp tilt
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: AppColors.success, width: 2),
        ),
        alignment: Alignment.center,
        child: Text(
          'verified\nagent',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: size * 0.16, fontWeight: FontWeight.w600, color: AppColors.success, height: 1.15),
        ),
      ),
    );
  }
}

class FeaturedTag extends StatelessWidget {
  const FeaturedTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Text('Featured', style: TextStyle(fontSize: 11, color: AppColors.accent, fontWeight: FontWeight.w600)),
    );
  }
}
