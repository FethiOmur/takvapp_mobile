import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:takvapp_mobile/core/theme/app_colors.dart';

/// Dokunma pozisyonunda animasyonlu fluid glass effect gösteren widget
class FluidGlassEffect extends StatefulWidget {
  final Widget child;
  final double scale;
  final double blurRadius;
  final Duration animationDuration;
  final Duration visibleDuration;
  const FluidGlassEffect({
    super.key,
    required this.child,
    this.scale = 0.25,
    this.blurRadius = 30.0,
    this.animationDuration = const Duration(milliseconds: 300),
    this.visibleDuration = const Duration(milliseconds: 500),
  });

  @override
  State<FluidGlassEffect> createState() => FluidGlassEffectState();
}

class FluidGlassEffectState extends State<FluidGlassEffect>
    with SingleTickerProviderStateMixin {
  Offset? _touchPosition;
  bool _isVisible = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void showEffectAtPosition(Offset localPosition) {
    setState(() {
      _touchPosition = localPosition;
      _isVisible = true;
    });

    _controller.forward().then((_) {
      Future.delayed(widget.visibleDuration, () {
        if (mounted) {
          _controller.reverse().then((_) {
            if (mounted) {
              setState(() {
                _isVisible = false;
                _touchPosition = null;
              });
            }
          });
        }
      });
    });
  }

  void _onTapDown(TapDownDetails details) {
    // Dokunma pozisyonunu kaydet ve efekti göster
    showEffectAtPosition(details.localPosition);
  }

  void _onPanDown(DragDownDetails details) {
    // Pan gesture için de dokunma pozisyonunu yakala
    _onTapDown(TapDownDetails(
      globalPosition: details.globalPosition,
      localPosition: details.localPosition,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTapDown: _onTapDown,
          onPanDown: _onPanDown,
          behavior: HitTestBehavior.translucent,
          child: widget.child,
        ),
        if (_isVisible && _touchPosition != null)
          IgnorePointer(
            ignoring: true,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final lensSize = 200 * widget.scale * _scaleAnimation.value;
                if (lensSize <= 0) return const SizedBox.shrink();
                
                return Positioned(
                  left: _touchPosition!.dx - lensSize / 2,
                  top: _touchPosition!.dy - lensSize / 2,
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: _GlassLens(
                      size: lensSize,
                      blurRadius: widget.blurRadius,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

/// Glass lens efekti widget'ı
class _GlassLens extends StatelessWidget {
  final double size;
  final double blurRadius;

  const _GlassLens({
    required this.size,
    required this.blurRadius,
  });

  @override
  Widget build(BuildContext context) {
    if (size <= 0) return const SizedBox.shrink();
    
    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurRadius,
            sigmaY: blurRadius,
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.topLeft,
                radius: 0.8,
                colors: [
                  AppColors.white.withValues(alpha: 0.25),
                  AppColors.white.withValues(alpha: 0.1),
                  AppColors.white.withValues(alpha: 0.05),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: blurRadius * 1.5,
                  spreadRadius: blurRadius * 0.3,
                ),
              ],
            ),
            child: CustomPaint(
              painter: _ChromaticAberrationPainter(),
            ),
          ),
        ),
      ),
    );
  }
}

/// Chromatic aberration efekti için custom painter
class _ChromaticAberrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Kırmızı kanal (sağa kaydırılmış)
    final redPaint = Paint()
      ..color = const Color(0xFFFF0000).withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Mavi kanal (sola kaydırılmış)
    final bluePaint = Paint()
      ..color = const Color(0xFF0000FF).withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Chromatic aberration efekti
    canvas.drawCircle(
      Offset(center.dx + 1, center.dy),
      radius - 1,
      redPaint,
    );
    canvas.drawCircle(
      Offset(center.dx - 1, center.dy),
      radius - 1,
      bluePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

