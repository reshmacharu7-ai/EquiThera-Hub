import 'dart:ui';
import 'package:flutter/material.dart';
import '../../navigation/app_routes.dart';
import '../../core/widgets/glass_card.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _contentController;

  late Animation<double> _titleFade;
  late Animation<double> _subtitleFade;
  late Animation<Offset> _loginSlide;
  late Animation<Offset> _signupSlide;
  late Animation<double> _guestFade;

  @override
  void initState() {
    super.initState();

    _bgController =
    AnimationController(vsync: this, duration: const Duration(seconds: 8))
      ..repeat(reverse: true);

    _contentController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    _titleFade = CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn));

    _subtitleFade = CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.2, 0.5, curve: Curves.easeIn));

    _loginSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOut)));

    _signupSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.5, 0.9, curve: Curves.easeOut)));

    _guestFade = CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeIn));

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

                /// Soft Glow Effects
                Positioned(top: -120, left: -80, child: _glow(320)),
                Positioned(bottom: -150, right: -100, child: _glow(380)),

                /// Main Content
                Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: GlassCard(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            /// Gradient Title
                            FadeTransition(
                              opacity: _titleFade,
                              child: AnimatedBuilder(
                                animation: _bgController,
                                builder: (context, child) {
                                  return ShaderMask(
                                    shaderCallback: (bounds) {
                                      return LinearGradient(
                                        colors: const [
                                          Colors.cyanAccent,
                                          Colors.blueAccent,
                                          Colors.white
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
                                        fontSize: 34,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 18),

                            /// Subheading
                            FadeTransition(
                              opacity: _subtitleFade,
                              child: const Text(
                                "Inclusive AI-powered therapeutic support built to bridge healthcare inequities and empower every community.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white70,
                                  height: 1.6,
                                ),
                              ),
                            ),

                            const SizedBox(height: 40),

                            /// Login Button
                            SlideTransition(
                              position: _loginSlide,
                              child: _glassButton(
                                text: "Login",
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, AppRoutes.login);
                                },
                              ),
                            ),

                            const SizedBox(height: 16),

                            /// Sign Up Button (Primary)
                            SlideTransition(
                              position: _signupSlide,
                              child: _gradientButton(
                                text: "Sign Up",
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, AppRoutes.signup);
                                },
                              ),
                            ),

                            const SizedBox(height: 22),

                            /// Continue as Guest
                            FadeTransition(
                              opacity: _guestFade,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, AppRoutes.dashboard);
                                },
                                child: const Text(
                                  "Continue as Guest",
                                  style: TextStyle(
                                    color: Colors.white60,
                                    decoration: TextDecoration.underline,
                                  ),
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

  Widget _glassButton({required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _gradientButton({required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.cyanAccent, Colors.blueAccent],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.cyanAccent.withOpacity(0.6),
              blurRadius: 20,
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _glow(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.cyanAccent.withOpacity(0.25),
            Colors.transparent
          ],
        ),
      ),
    );
  }
}
