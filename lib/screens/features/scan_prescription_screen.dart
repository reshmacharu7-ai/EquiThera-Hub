// lib/screens/features/scan_prescription_screen.dart
import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/user_profile.dart';

class ScanPrescriptionScreen extends StatefulWidget {
  final UserProfile? user;
  const ScanPrescriptionScreen({super.key, this.user});

  @override
  State<ScanPrescriptionScreen> createState() => _ScanPrescriptionScreenState();
}

class _ScanPrescriptionScreenState extends State<ScanPrescriptionScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late AnimationController _scanLineCtrl;
  late Animation<double> _fade;
  late Animation<double> _scanLine;

  bool _scanning = false;
  bool _scanned = false;
  double _progress = 0;
  Timer? _timer;

  final _scanResult = {
    'doctor': 'Dr. Ramesh Kumar, MD',
    'hospital': 'Apollo Specialty Hospital, Chennai',
    'date': 'February 18, 2026',
    'medicines': [
      {
        'name': 'Metformin 500mg',
        'dosage': '1 tablet twice daily',
        'duration': '30 days',
        'timing': 'After meals',
        'risk': 'low',
      },
      {
        'name': 'Atorvastatin 10mg',
        'dosage': '1 tablet at bedtime',
        'duration': '30 days',
        'timing': 'At night',
        'risk': 'low',
      },
      {
        'name': 'Amlodipine 5mg',
        'dosage': '1 tablet once daily',
        'duration': '30 days',
        'timing': 'Morning',
        'risk': 'medium',
      },
    ],
    'warnings': [
      'Avoid grapefruit while on Atorvastatin',
      'Monitor blood pressure weekly',
    ],
  };

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _scanLineCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _scanLine = CurvedAnimation(parent: _scanLineCtrl, curve: Curves.easeInOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _scanLineCtrl.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startScan() {
    setState(() {
      _scanning = true;
      _scanned = false;
      _progress = 0;
    });
    _timer = Timer.periodic(const Duration(milliseconds: 60), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() => _progress += 0.015);
      if (_progress >= 1.0) {
        t.cancel();
        setState(() {
          _scanning = false;
          _scanned = true;
          _progress = 1.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
              title: const Text('Scan Prescription',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 18)),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0A192F), Color(0xFF112240)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Scanner box
                    _glassCard(
                      child: Column(
                        children: [
                          Container(
                            height: 220,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: const Color(0xFF00D4FF).withOpacity(0.4)),
                            ),
                            child: Stack(
                              children: [
                                // Fake document lines
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(height: 10, width: 160,
                                          color: Colors.white.withOpacity(0.15),
                                          margin: const EdgeInsets.only(bottom: 8)),
                                      Container(height: 8, width: 200,
                                          color: Colors.white.withOpacity(0.08),
                                          margin: const EdgeInsets.only(bottom: 6)),
                                      Container(height: 8, width: 180,
                                          color: Colors.white.withOpacity(0.08),
                                          margin: const EdgeInsets.only(bottom: 6)),
                                      const SizedBox(height: 10),
                                      Container(height: 8, width: 220,
                                          color: Colors.white.withOpacity(0.08),
                                          margin: const EdgeInsets.only(bottom: 6)),
                                      Container(height: 8, width: 190,
                                          color: Colors.white.withOpacity(0.08),
                                          margin: const EdgeInsets.only(bottom: 6)),
                                      Container(height: 8, width: 200,
                                          color: Colors.white.withOpacity(0.08),
                                          margin: const EdgeInsets.only(bottom: 6)),
                                    ],
                                  ),
                                ),
                                // Scanning line
                                if (_scanning)
                                  AnimatedBuilder(
                                    animation: _scanLine,
                                    builder: (_, __) => Positioned(
                                      top: _scanLine.value * 200,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: 2,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.transparent,
                                              const Color(0xFF00D4FF),
                                              Colors.transparent,
                                            ],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF00D4FF).withOpacity(0.6),
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                // Corner brackets
                                ..._corners(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_scanning) ...[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: _progress,
                                minHeight: 6,
                                backgroundColor: Colors.white.withOpacity(0.1),
                                valueColor: const AlwaysStoppedAnimation(
                                    Color(0xFF00D4FF)),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Analyzing prescription... ${(_progress * 100).toInt()}%',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 12,
                                  fontFamily: 'Poppins'),
                            ),
                          ] else if (!_scanned) ...[
                            GestureDetector(
                              onTap: _startScan,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 14),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF00D4FF), Color(0xFF0055FF)],
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.document_scanner_rounded,
                                        color: Colors.white, size: 20),
                                    SizedBox(width: 10),
                                    Text('Scan Prescription',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Poppins')),
                                  ],
                                ),
                              ),
                            ),
                          ] else ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF43E97B).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: const Color(0xFF43E97B).withOpacity(0.3)),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_circle_rounded,
                                      color: Color(0xFF43E97B), size: 18),
                                  SizedBox(width: 8),
                                  Text('Prescription scanned successfully!',
                                      style: TextStyle(
                                          color: Color(0xFF43E97B),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Poppins')),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    if (_scanned) ...[
                      const SizedBox(height: 20),
                      _glassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _resultRow(Icons.person_rounded, 'Doctor',
                                _scanResult['doctor'] as String, const Color(0xFF00D4FF)),
                            const Divider(color: Colors.white12, height: 20),
                            _resultRow(Icons.local_hospital_rounded, 'Hospital',
                                _scanResult['hospital'] as String, const Color(0xFF7B2FFF)),
                            const Divider(color: Colors.white12, height: 20),
                            _resultRow(Icons.calendar_today_rounded, 'Date',
                                _scanResult['date'] as String, const Color(0xFFF7971E)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('💊 Prescribed Medicines',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins')),
                      ),
                      const SizedBox(height: 10),
                      ...(_scanResult['medicines'] as List).map((med) {
                        final risk = med['risk'] as String;
                        final riskColor = risk == 'low'
                            ? const Color(0xFF43E97B)
                            : const Color(0xFFFFAA44);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _glassCard(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(med['name'] as String,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Poppins')),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: riskColor.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        '${risk[0].toUpperCase()}${risk.substring(1)} Risk',
                                        style: TextStyle(
                                            color: riskColor,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Poppins'),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                _pillRow('Dosage', med['dosage'] as String),
                                _pillRow('Duration', med['duration'] as String),
                                _pillRow('Timing', med['timing'] as String),
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 4),
                      _glassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.warning_rounded,
                                    color: Color(0xFFFFAA44), size: 18),
                                SizedBox(width: 8),
                                Text('Warnings',
                                    style: TextStyle(
                                        color: Color(0xFFFFAA44),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Poppins')),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ...(_scanResult['warnings'] as List).map(
                                  (w) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('• ',
                                        style: TextStyle(color: Color(0xFFFFAA44))),
                                    Expanded(
                                      child: Text(w as String,
                                          style: TextStyle(
                                              color: Colors.white.withOpacity(0.7),
                                              fontSize: 12,
                                              fontFamily: 'Poppins')),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

  List<Widget> _corners() {
    const size = 20.0;
    const thickness = 2.5;
    const color = Color(0xFF00D4FF);
    return [
      Positioned(top: 8, left: 8,
          child: _corner(true, true, size, thickness, color)),
      Positioned(top: 8, right: 8,
          child: _corner(true, false, size, thickness, color)),
      Positioned(bottom: 8, left: 8,
          child: _corner(false, true, size, thickness, color)),
      Positioned(bottom: 8, right: 8,
          child: _corner(false, false, size, thickness, color)),
    ];
  }

  Widget _corner(bool top, bool left, double size, double thickness, Color color) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CornerPainter(top: top, left: left, color: color, thickness: thickness),
      ),
    );
  }

  Widget _resultRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 10,
                    fontFamily: 'Poppins')),
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins')),
          ],
        ),
      ],
    );
  }

  Widget _pillRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text('$label: ',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 11,
                  fontFamily: 'Poppins')),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
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

class _CornerPainter extends CustomPainter {
  final bool top, left;
  final Color color;
  final double thickness;
  _CornerPainter({required this.top, required this.left,
    required this.color, required this.thickness});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path();
    if (top && left) {
      path.moveTo(0, size.height); path.lineTo(0, 0); path.lineTo(size.width, 0);
    } else if (top && !left) {
      path.moveTo(0, 0); path.lineTo(size.width, 0); path.lineTo(size.width, size.height);
    } else if (!top && left) {
      path.moveTo(0, 0); path.lineTo(0, size.height); path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, size.height); path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CornerPainter old) => false;
}