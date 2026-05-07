import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // prevent instantiation

  // ── Core Brand ──────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF0284C7);        // sky-600 / #7dd3fc adjusted for light
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFE0F2FE); // light blue tint
  static const Color onPrimaryContainer = Color(0xFF0E4D6E);

  // ── Secondary ───────────────────────────────────────────────────────────────
  static const Color secondary = Color(0xFF0369A1);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFBAE6FD);
  static const Color onSecondaryContainer = Color(0xFF1A3A4E);

  // ── Tertiary ────────────────────────────────────────────────────────────────
  static const Color tertiary = Color(0xFF7C3AED);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFEDE9FE);

  // ── Error ───────────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFDC2626);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFEE2E2);

  // ── Surface & Background ────────────────────────────────────────────────────
  static const Color background = Color(0xFFF8FAFC);
  static const Color onBackground = Color(0xFF0F172A);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF0F172A);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color onSurfaceVariant = Color(0xFF475569);
  static const Color surfaceContainer = Color(0xFFF8FAFC);
  static const Color surfaceContainerLow = Color(0xFFF1F5F9);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerHigh = Color(0xFFE2E8F0);
  static const Color surfaceContainerHighest = Color(0xFFCBD5E1);
  static const Color surfaceBright = Color(0xFFFFFFFF);

  // ── Outline ─────────────────────────────────────────────────────────────────
  static const Color outline = Color(0xFF94A3B8);
  static const Color outlineVariant = Color(0xFFE2E8F0);

  // ── Inverse ─────────────────────────────────────────────────────────────────
  static const Color inverseSurface = Color(0xFF1E293B);
  static const Color inverseOnSurface = Color(0xFFF8FAFC);
  static const Color inversePrimary = Color(0xFF7DD3FC);

  // ── Semantic / UI Helpers ───────────────────────────────────────────────────
  static const Color navBarBackground = Color(0xFFFFFFFF);
  static const Color navBarBorder = Color(0xFFE2E8F0);
  static const Color navActiveBackground = Color(0xFFECFDF5);  // emerald-50
  static const Color navActiveText = Color(0xFF065F46);         // emerald-800
  static const Color navInactiveText = Color(0xFF94A3B8);       // slate-400
  static const Color cardShadow = Color(0x14065F46);            // emerald shadow
  static const Color starColor = Color(0xFFF59E0B);             // amber-400
  static const Color chipBackground = Color(0xFFEFF6FF);
  static const Color chipText = Color(0xFF0284C7);
}