import 'package:flutter/material.dart';

/// EditorialShimmerBox provides a warm, luxury-grade shimmering skeleton placeholder.
/// Inspired by high-fashion editorial magazine layouts with subtle stone and alabaster tones.
class EditorialShimmerBox extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final BoxShape shape;

  const EditorialShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
  });

  @override
  State<EditorialShimmerBox> createState() => _EditorialShimmerBoxState();
}

class _EditorialShimmerBoxState extends State<EditorialShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor = isDark ? const Color(0xFF1C1832) : const Color(0xFFECE8F8);
    final highlightColor = isDark ? const Color(0xFF2C2747) : const Color(0xFFF7F5FF);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            shape: widget.shape,
            borderRadius: widget.shape == BoxShape.circle
                ? null
                : (widget.borderRadius ?? BorderRadius.circular(12)),
            gradient: LinearGradient(
              begin: Alignment(-2.0 + (_controller.value * 4.0), -1.0),
              end: Alignment(-1.0 + (_controller.value * 4.0), 1.0),
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: const [0.1, 0.5, 0.9],
            ),
          ),
        );
      },
    );
  }
}
