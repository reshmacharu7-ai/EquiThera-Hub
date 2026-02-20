import 'dart:ui';
import 'package:flutter/material.dart';
import '../../navigation/app_routes.dart';
import '../../core/widgets/glass_card.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _contentController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _bgController =
    AnimationController(vsync: this, duration: const Duration(seconds: 8))
      ..repeat(reverse: true);

    _contentController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    _fadeAnimation =
        CurvedAnimation(parent: _contentController, curve: Curves.easeIn);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOutBack),
    );

    _contentController.forward();
  }

  @override
  void dispose() {
    _bgController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _bgController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF0A192F),
                  Color.lerp(
                      const Color(0xFF112D4E),
                      const Color(0xFF1B3C73),
                      _bgController.value)!,
                  const Color(0xFF1E3A8A),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [

                /// 🌟 Soft Glow Circles
                Positioned(
                  top: -100,
                  left: -50,
                  child: _buildGlow(300),
                ),
                Positioned(
                  bottom: -120,
                  right: -60,
                  child: _buildGlow(350),
                ),

                const _FloatingIcons(),

                /// 🧊 Center Content
                Center(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: GlassCard(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            /// 🌈 Gradient Animated Title
                            AnimatedBuilder(
                              animation: _bgController,
                              builder: (context, child) {
                                return ShaderMask(
                                  shaderCallback: (bounds) {
                                    return LinearGradient(
                                      colors: [
                                        Colors.cyanAccent,
                                        Colors.blueAccent,
                                        Colors.white,
                                      ],
                                      stops: [
                                        0.2,
                                        0.5 + (_bgController.value * 0.2),
                                        0.9
                                      ],
                                    ).createShader(bounds);
                                  },
                                  child: const Text(
                                    "EquiThera Hub",
                                    style: TextStyle(
                                      fontSize: 38,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 20),

                            const Text(
                              "Bridging Healthcare Inequities\nThrough Inclusive AI-Powered Therapeutic Support",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                                height: 1.6,
                              ),
                            ),

                            const SizedBox(height: 40),

                            /// 🚀 Gradient Next Button
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                    context, AppRoutes.welcome);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 14),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Colors.cyanAccent,
                                      Colors.blueAccent,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                      Colors.cyanAccent.withOpacity(0.6),
                                      blurRadius: 20,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Next",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGlow(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.cyanAccent.withOpacity(0.3),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

/// 🌊 Floating AI Icons
class _FloatingIcons extends StatefulWidget {
  const _FloatingIcons();

  @override
  State<_FloatingIcons> createState() => _FloatingIconsState();
}

class _FloatingIconsState extends State<_FloatingIcons>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: const Duration(seconds: 6))
      ..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: 120 + (_controller.value * 30),
              left: 40,
              child: _icon(Icons.monitor_heart),
            ),
            Positioned(
              bottom: 150 + (_controller.value * 25),
              right: 50,
              child: _icon(Icons.psychology),
            ),
            Positioned(
              top: 250,
              right: 100 + (_controller.value * 20),
              child: _icon(Icons.healing),
            ),
          ],
        );
      },
    );
  }

  Widget _icon(IconData icon) {
    return Icon(
      icon,
      size: 45,
      color: Colors.white.withOpacity(0.15),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
