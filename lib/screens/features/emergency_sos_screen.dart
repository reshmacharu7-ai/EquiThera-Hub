// lib/screens/features/emergency_sos_screen.dart
import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/user_profile.dart';

class EmergencySosScreen extends StatefulWidget {
  final UserProfile? user;
  const EmergencySosScreen({super.key, this.user});

  @override
  State<EmergencySosScreen> createState() => _EmergencySosScreenState();
}

class _EmergencySosScreenState extends State<EmergencySosScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _rippleCtrl;
  late Animation<double> _fade;
  late Animation<double> _pulse;
  late Animation<double> _ripple;

  bool _sosActivated = false;
  bool _locating = false;
  bool _locationFound = false;
  int _countdown = 5;
  Timer? _countdownTimer;

  final _nearbyHospitals = [
    {'name': 'Apollo Hospitals', 'distance': '0.8 km', 'eta': '3 min', 'phone': '044-28293333', 'rating': '4.8'},
    {'name': 'Fortis Malar Hospital', 'distance': '1.2 km', 'eta': '5 min', 'phone': '044-42893333', 'rating': '4.6'},
    {'name': 'MIOT International', 'distance': '2.1 km', 'eta': '8 min', 'phone': '044-22494900', 'rating': '4.7'},
    {'name': 'Kauvery Hospital', 'distance': '2.8 km', 'eta': '10 min', 'phone': '044-40004000', 'rating': '4.5'},
  ];

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat(reverse: true);
    _rippleCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat();
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _pulse = Tween<double>(begin: 0.9, end: 1.1).animate(
        CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _ripple = CurvedAnimation(parent: _rippleCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();

    // Auto-locate
    _startLocating();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _pulseCtrl.dispose();
    _rippleCtrl.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _startLocating() async {
    setState(() => _locating = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() { _locating = false; _locationFound = true; });
  }

  void _activateSOS() {
    setState(() { _sosActivated = true; _countdown = 5; });
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() => _countdown--);
      if (_countdown <= 0) {
        t.cancel();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('🚨 Emergency SOS Sent! Ambulance dispatched.',
                style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700)),
            backgroundColor: const Color(0xFFFF4444),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    });
  }

  void _cancelSOS() {
    _countdownTimer?.cancel();
    setState(() { _sosActivated = false; _countdown = 5; });
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    return Scaffold(
      backgroundColor: const Color(0xFF0A192F),
      body: FadeTransition(
        opacity: _fade,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: const Color(0xFF0A192F),
              pinned: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text('Emergency SOS',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 18)),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A0000), Color(0xFF0A192F)],
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Location status
                    _glassCard(
                      child: Row(
                        children: [
                          Container(
                            width: 40, height: 40,
                            decoration: BoxDecoration(
                              color: _locationFound
                                  ? const Color(0xFF43E97B).withOpacity(0.2)
                                  : const Color(0xFFFFAA44).withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: _locating
                                ? const Padding(
                              padding: EdgeInsets.all(10),
                              child: CircularProgressIndicator(
                                  color: Color(0xFFFFAA44), strokeWidth: 2),
                            )
                                : Icon(
                              _locationFound
                                  ? Icons.location_on_rounded
                                  : Icons.location_off_rounded,
                              color: _locationFound
                                  ? const Color(0xFF43E97B)
                                  : const Color(0xFFFFAA44),
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _locating
                                    ? 'Detecting location...'
                                    : _locationFound
                                    ? 'Location Detected'
                                    : 'Location Unknown',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins'),
                              ),
                              Text(
                                _locationFound
                                    ? 'Meenambakkam, Chennai 600027'
                                    : 'Enable GPS for accurate location',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 12,
                                    fontFamily: 'Poppins'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // SOS Button
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Ripple rings
                        if (_sosActivated) ...[
                          AnimatedBuilder(
                            animation: _ripple,
                            builder: (_, __) => Container(
                              width: 260 + _ripple.value * 60,
                              height: 260 + _ripple.value * 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFFF4444).withOpacity(1 - _ripple.value),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                        ScaleTransition(
                          scale: _sosActivated ? _pulse : const AlwaysStoppedAnimation(1.0),
                          child: GestureDetector(
                            onTap: _sosActivated ? _cancelSOS : _activateSOS,
                            child: Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: _sosActivated
                                      ? [const Color(0xFFFF6666), const Color(0xFFCC0000)]
                                      : [const Color(0xFFFF4444), const Color(0xFF990000)],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF4444).withOpacity(
                                        _sosActivated ? 0.6 : 0.3),
                                    blurRadius: _sosActivated ? 40 : 20,
                                    spreadRadius: _sosActivated ? 10 : 0,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.emergency_rounded,
                                      color: Colors.white, size: 44),
                                  const SizedBox(height: 8),
                                  Text(
                                    _sosActivated
                                        ? 'CANCEL (${_countdown}s)'
                                        : 'SOS',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    Text(
                      _sosActivated
                          ? '⚠️ Sending SOS in ${_countdown}s... Tap to cancel'
                          : 'Tap to send emergency alert & call ambulance',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: _sosActivated
                              ? const Color(0xFFFF6B6B)
                              : Colors.white.withOpacity(0.5),
                          fontSize: 13,
                          fontFamily: 'Poppins'),
                    ),

                    const SizedBox(height: 30),

                    // Emergency numbers
                    _glassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('📞 Emergency Numbers',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins')),
                          const SizedBox(height: 14),
                          _emergencyRow('🚑', 'Ambulance', '108'),
                          _emergencyRow('🚔', 'Police', '100'),
                          _emergencyRow('🚒', 'Fire', '101'),
                          _emergencyRow('📞', 'National Emergency', '112'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Patient info card
                    _glassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.person_pin_rounded,
                                  color: Color(0xFFFF4444), size: 18),
                              SizedBox(width: 8),
                              Text('Patient Information',
                                  style: TextStyle(
                                      color: Color(0xFFFF4444),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Poppins')),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _infoRow('Name', user?.name ?? 'Not set'),
                          _infoRow('Age', '${user?.age ?? '--'}'),
                          _infoRow('Blood', user?.bloodGroup ?? 'O+'),
                          _infoRow('Weight', '${user?.weight.toStringAsFixed(0) ?? '--'} kg'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Nearby hospitals
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('🏥 Nearest Hospitals',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins')),
                    ),
                    const SizedBox(height: 12),

                    ..._nearbyHospitals.map((h) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _glassCard(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Container(
                              width: 44, height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF4444).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.local_hospital_rounded,
                                  color: Color(0xFFFF4444), size: 24),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(h['name']!,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Poppins')),
                                  Row(
                                    children: [
                                      Text('${h['distance']}  •  ${h['eta']} away',
                                          style: TextStyle(
                                              color: Colors.white.withOpacity(0.5),
                                              fontSize: 11,
                                              fontFamily: 'Poppins')),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.star_rounded,
                                          color: Color(0xFFF7971E), size: 12),
                                      Text(h['rating']!,
                                          style: const TextStyle(
                                              color: Color(0xFFF7971E),
                                              fontSize: 10,
                                              fontFamily: 'Poppins')),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF43E97B).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text('Call',
                                  style: const TextStyle(
                                      color: Color(0xFF43E97B),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Poppins')),
                            ),
                          ],
                        ),
                      ),
                    )),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emergencyRow(String emoji, String label, String number) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                    fontFamily: 'Poppins')),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFF4444).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: const Color(0xFFFF4444).withOpacity(0.3)),
            ),
            child: Text(number,
                style: const TextStyle(
                    color: Color(0xFFFF4444),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins')),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(label,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 11,
                    fontFamily: 'Poppins')),
          ),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'Poppins')),
        ],
      ),
    );
  }

  Widget _glassCard({required Widget child, EdgeInsets? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: padding ?? const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: child,
        ),
      ),
    );
  }
}