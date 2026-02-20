// lib/screens/role_selection/role_selection_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../navigation/app_routes.dart';
import '../../models/user_profile.dart';

class RoleSelectionScreen extends StatefulWidget {
  final UserProfile? user;
  const RoleSelectionScreen({super.key, this.user});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  String? _selectedRole;

  final List<Map<String, dynamic>> _roles = [
    {
      'role': 'Male',
      'emoji': '👨',
      'label': 'Male',
      'gradient': [Color(0xFF00D4FF), Color(0xFF0055FF)],
    },
    {
      'role': 'Female',
      'emoji': '👩',
      'label': 'Female',
      'gradient': [Color(0xFFFF77AA), Color(0xFFDD2277)],
    },
    {
      'role': 'Transgender',
      'emoji': '🏳️‍⚧️',
      'label': 'Transgender',
      'gradient': [Color(0xFF55CDFC), Color(0xFFDD2277)],
    },
    {
      'role': 'Kids',
      'emoji': '👦',
      'label': 'Kids',
      'gradient': [Color(0xFF43E97B), Color(0xFF0077AA)],
    },
    {
      'role': 'Senior',
      'emoji': '👴',
      'label': 'Senior',
      'gradient': [Color(0xFFF7971E), Color(0xFFBB6600)],
    },
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _proceed() {
    if (_selectedRole == null) return;

    final updatedUser = widget.user != null
        ? UserProfile(
      name: widget.user!.name,
      email: widget.user!.email,
      role: _selectedRole!,
      age: widget.user!.age,
      height: widget.user!.height,
      weight: widget.user!.weight,
      userId: widget.user!.userId,
      bloodGroup: widget.user!.bloodGroup,
      healthRecords: widget.user!.healthRecords,
    )
        : UserProfile(
      name: 'User',
      email: '',
      role: _selectedRole!,
      userId: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    if (_selectedRole == 'Transgender') {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.transgenderDashboard,
            (route) => false,
        arguments: updatedUser,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.dashboard,
            (route) => false,
        arguments: updatedUser,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A192F),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // Back button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.arrow_back_ios_rounded,
                        color: Colors.white, size: 18),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Who are you?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select your profile type for a personalized health experience',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 36),
                // Role cards
                Expanded(
                  child: ListView.separated(
                    itemCount: _roles.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, i) {
                      final role = _roles[i];
                      final selected = _selectedRole == role['role'];
                      final colors = role['gradient'] as List<Color>;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedRole = role['role']),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: selected
                                ? LinearGradient(
                              colors: [
                                colors[0].withOpacity(0.25),
                                colors[1].withOpacity(0.1),
                              ],
                            )
                                : null,
                            color: selected
                                ? null
                                : Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: selected
                                  ? colors[0].withOpacity(0.6)
                                  : Colors.white.withOpacity(0.1),
                              width: selected ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(role['emoji'] as String,
                                  style: const TextStyle(fontSize: 32)),
                              const SizedBox(width: 16),
                              Text(
                                role['label'] as String,
                                style: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.7),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const Spacer(),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: selected
                                      ? LinearGradient(colors: colors)
                                      : null,
                                  color: selected
                                      ? null
                                      : Colors.white.withOpacity(0.07),
                                  border: Border.all(
                                    color: selected
                                        ? Colors.transparent
                                        : Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                child: selected
                                    ? const Icon(Icons.check_rounded,
                                    color: Colors.white, size: 14)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Proceed button
                GestureDetector(
                  onTap: _selectedRole != null ? _proceed : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: _selectedRole != null
                          ? const LinearGradient(
                        colors: [Color(0xFF00D4FF), Color(0xFF0055FF)],
                      )
                          : null,
                      color: _selectedRole != null
                          ? null
                          : Colors.white.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          color: _selectedRole != null
                              ? Colors.white
                              : Colors.white.withOpacity(0.3),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
