import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraPreviewWidget extends StatelessWidget {
  final CameraController controller;
  final Function(Offset)? onTap;

  const CameraPreviewWidget({
    super.key,
    required this.controller,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return GestureDetector(
      onTapUp: (details) {
        if (onTap != null) {
          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          final localPosition = renderBox.globalToLocal(details.globalPosition);
          final size = renderBox.size;
          
          // Convert to normalized coordinates (0.0 to 1.0)
          final normalizedX = localPosition.dx / size.width;
          final normalizedY = localPosition.dy / size.height;
          
          onTap!(Offset(normalizedX, normalizedY));
        }
      },
      child: Stack(
        children: [
          // Camera Preview
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: controller.value.previewSize?.height ?? 1,
                height: controller.value.previewSize?.width ?? 1,
                child: CameraPreview(controller),
              ),
            ),
          ),
          
          // Focus indicator (if needed)
          if (controller.value.focusPointSupported)
            const FocusIndicator(),
          
          // Grid lines overlay (if enabled)
          const GridLinesOverlay(),
        ],
      ),
    );
  }
}

class FocusIndicator extends StatefulWidget {
  const FocusIndicator({super.key});

  @override
  State<FocusIndicator> createState() => _FocusIndicatorState();
}

class _FocusIndicatorState extends State<FocusIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  Offset? _focusPoint;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void showFocusIndicator(Offset point) {
    setState(() {
      _focusPoint = point;
    });
    _animationController.forward().then((_) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _focusPoint = null;
          });
          _animationController.reset();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_focusPoint == null) return const SizedBox.shrink();

    return Positioned(
      left: _focusPoint!.dx - 30,
      top: _focusPoint!.dy - 30,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        },
      ),
    );
  }
}

class GridLinesOverlay extends StatelessWidget {
  const GridLinesOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    // This would be controlled by camera settings
    // For now, we'll show it as a simple overlay
    return CustomPaint(
      painter: GridLinesPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class GridLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1.0;

    // Draw rule of thirds grid
    final thirdWidth = size.width / 3;
    final thirdHeight = size.height / 3;

    // Vertical lines
    canvas.drawLine(
      Offset(thirdWidth, 0),
      Offset(thirdWidth, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(thirdWidth * 2, 0),
      Offset(thirdWidth * 2, size.height),
      paint,
    );

    // Horizontal lines
    canvas.drawLine(
      Offset(0, thirdHeight),
      Offset(size.width, thirdHeight),
      paint,
    );
    canvas.drawLine(
      Offset(0, thirdHeight * 2),
      Offset(size.width, thirdHeight * 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}