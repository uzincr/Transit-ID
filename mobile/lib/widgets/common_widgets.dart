// ═══════════════════════════════════════════════════════════
// TransitID — Reusable UI Widgets
// ═══════════════════════════════════════════════════════════

import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme.dart';

/// Premium glass-morphism card with a refractive gradient border
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? baseColor;
  final double borderOpacity;

  const GlassCard({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.borderRadius = 20,
    this.baseColor,
    this.borderOpacity = 0.12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(80),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  (baseColor ?? AppTheme.cardDark).withAlpha(160),
                  (baseColor ?? AppTheme.cardDarkAlt).withAlpha(100),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: Colors.white.withAlpha((borderOpacity * 255).toInt()),
                width: 1.0,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Gradient text widget with customizable gradient and shadow
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Gradient? gradient;

  const GradientText({
    super.key,
    required this.text,
    this.style,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => (gradient ?? AppTheme.primaryGradient).createShader(bounds),
      child: Text(
        text,
        style: (style ?? const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)).copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Animated gradient button with a glowing background shadow
class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final Gradient? customGradient;

  const GradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.customGradient,
  });

  @override
  Widget build(BuildContext context) {
    final hasCallback = onPressed != null && !isLoading;
    return Container(
      width: width ?? double.infinity,
      height: 54,
      decoration: BoxDecoration(
        gradient: hasCallback ? (customGradient ?? AppTheme.primaryGradient) : null,
        color: hasCallback ? null : Colors.white.withAlpha(20),
        borderRadius: BorderRadius.circular(16),
        boxShadow: hasCallback
            ? [
                BoxShadow(
                  color: (customGradient?.colors.first ?? AppTheme.primaryCyan).withAlpha(60),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation(AppTheme.darkBg),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18, color: hasCallback ? AppTheme.darkBg : Colors.white24),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      color: hasCallback ? AppTheme.darkBg : Colors.white30,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Dynamic Neon status badge chip
class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Gradient? gradient;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.gradient,
  });

  factory StatusBadge.active() => const StatusBadge(
        label: 'FAO' 'L',
        color: AppTheme.success,
        gradient: AppTheme.successGradient,
      );

  factory StatusBadge.expiring() => const StatusBadge(
        label: 'TUGAYAPTI',
        color: AppTheme.warning,
      );

  factory StatusBadge.expired() => const StatusBadge(
        label: 'MUDDATI O' 'TGAN',
        color: AppTheme.danger,
        gradient: AppTheme.dangerGradient,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: gradient != null
            ? LinearGradient(
                colors: [
                  gradient!.colors[0].withAlpha(35),
                  gradient!.colors[1].withAlpha(35),
                ],
              )
            : null,
        color: gradient == null ? color.withAlpha(35) : null,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withAlpha(120),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(20),
            blurRadius: 8,
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

/// Ambient neon glowing orbs in background to bring UI depth
class BackgroundGlows extends StatelessWidget {
  const BackgroundGlows({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Upper left Cyan ambient light
        Positioned(
          top: -120,
          left: -80,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryCyan.withAlpha(30),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
              child: const SizedBox(),
            ),
          ),
        ),
        // Center-right Purple ambient light
        Positioned(
          top: 220,
          right: -100,
          child: Container(
            width: 380,
            height: 380,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.secondaryPurple.withAlpha(20),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 110, sigmaY: 110),
              child: const SizedBox(),
            ),
          ),
        ),
        // Bottom-left soft Cyan ambient light
        Positioned(
          bottom: -150,
          left: -100,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryCyan.withAlpha(15),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: const SizedBox(),
            ),
          ),
        ),
      ],
    );
  }
}
