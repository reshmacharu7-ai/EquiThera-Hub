// lib/screens/features/explain_medication_screen.dart
import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/user_profile.dart';

class ExplainMedicationScreen extends StatefulWidget {
  final UserProfile? user;
  const ExplainMedicationScreen({super.key, this.user});

  @override
  State<ExplainMedicationScreen> createState() => _ExplainMedicationScreenState();
}

class _ExplainMedicationScreenState extends State<ExplainMedicationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late Animation<double> _fade;

  final _searchCtrl = TextEditingController();
  bool _searching = false;
  Map<String, dynamic>? _result;

  final Map<String, Map<String, dynamic>> _drugDB = {
    'metformin': {
      'name': 'Metformin',
      'class': 'Biguanide (Antidiabetic)',
      'uses': 'Treatment of Type 2 Diabetes Mellitus. Reduces blood glucose levels.',
      'benefits': ['Lowers blood sugar effectively', 'Promotes slight weight loss', 'Reduces cardiovascular risk', 'Low risk of hypoglycemia'],
      'sideEffects': ['Nausea and vomiting', 'Diarrhea', 'Stomach upset', 'Rarely: Lactic acidosis'],
      'dosage': '500mg–2000mg daily, taken with meals',
      'warnings': ['Avoid in kidney disease', 'Stop before contrast CT scans', 'Avoid excess alcohol'],
      'color': const Color(0xFF00D4FF),
    },
    'paracetamol': {
      'name': 'Paracetamol (Acetaminophen)',
      'class': 'Analgesic / Antipyretic',
      'uses': 'Relief of mild to moderate pain, fever reduction.',
      'benefits': ['Fast pain relief', 'Reduces fever', 'Safe for most people', 'Available OTC'],
      'sideEffects': ['Liver damage in overdose', 'Skin rash (rare)', 'Nausea in high doses'],
      'dosage': '500mg–1000mg every 4–6 hours. Max 4g/day',
      'warnings': ['Do not exceed 4g/day', 'Avoid with alcohol', 'Caution in liver disease'],
      'color': const Color(0xFFFF6B6B),
    },
    'aspirin': {
      'name': 'Aspirin',
      'class': 'NSAID / Antiplatelet',
      'uses': 'Pain relief, fever, anti-inflammatory, prevention of blood clots.',
      'benefits': ['Reduces heart attack risk', 'Anti-inflammatory', 'Pain relief', 'Fever reduction'],
      'sideEffects': ['Stomach irritation', 'Bleeding', 'Tinnitus in high doses', 'Reye\'s syndrome in children'],
      'dosage': '75mg–325mg daily for heart; 500mg–1g for pain',
      'warnings': ['Avoid in children under 16', 'Risk of GI bleeding', 'Stop before surgery'],
      'color': const Color(0xFFF7971E),
    },
    'amoxicillin': {
      'name': 'Amoxicillin',
      'class': 'Penicillin Antibiotic',
      'uses': 'Bacterial infections: ear, throat, chest, UTI, skin.',
      'benefits': ['Broad-spectrum antibiotic', 'Well tolerated', 'Effective against many bacteria'],
      'sideEffects': ['Diarrhea', 'Nausea', 'Skin rash', 'Allergic reaction (rare)'],
      'dosage': '250mg–500mg three times daily for 5–10 days',
      'warnings': ['Allergy check before use', 'Complete full course', 'Avoid in penicillin allergy'],
      'color': const Color(0xFF43E97B),
    },
    'ibuprofen': {
      'name': 'Ibuprofen',
      'class': 'NSAID',
      'uses': 'Pain, inflammation, fever. Arthritis, period pain, headache.',
      'benefits': ['Anti-inflammatory', 'Pain relief', 'Reduces fever', 'OTC availability'],
      'sideEffects': ['Stomach pain', 'Nausea', 'Increased bleeding risk', 'Kidney strain'],
      'dosage': '200mg–400mg every 4–6 hours. Max 1200mg/day OTC',
      'warnings': ['Take with food', 'Avoid in kidney disease', 'Risk in heart disease', 'Avoid in pregnancy (3rd trimester)'],
      'color': const Color(0xFF7B2FFF),
    },
  };

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) return;
    setState(() { _searching = true; _result = null; });
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    final key = query.trim().toLowerCase();
    final found = _drugDB.entries
        .firstWhere(
          (e) => e.key.contains(key) || key.contains(e.key),
      orElse: () => MapEntry('', {}),
    )
        .value;
    setState(() {
      _searching = false;
      _result = found.isNotEmpty ? found : {'name': query, 'notFound': true};
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
              title: const Text('Explain My Medication',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 18)),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0A192F), Color(0xFF112240)],
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                          ),
                          child: TextField(
                            controller: _searchCtrl,
                            style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: 14),
                            onSubmitted: _search,
                            decoration: InputDecoration(
                              hintText: 'Search medication (e.g. Metformin)',
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.3),
                                  fontFamily: 'Poppins'),
                              prefixIcon: Icon(Icons.search_rounded,
                                  color: Colors.white.withOpacity(0.4)),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.send_rounded,
                                    color: Color(0xFF7B2FFF)),
                                onPressed: () => _search(_searchCtrl.text),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    // Quick chips
                    Wrap(
                      spacing: 8,
                      children: ['Metformin', 'Paracetamol', 'Ibuprofen', 'Aspirin', 'Amoxicillin']
                          .map((drug) => GestureDetector(
                        onTap: () {
                          _searchCtrl.text = drug;
                          _search(drug);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7B2FFF).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: const Color(0xFF7B2FFF).withOpacity(0.3)),
                          ),
                          child: Text(drug,
                              style: const TextStyle(
                                  color: Color(0xFF7B2FFF),
                                  fontSize: 12,
                                  fontFamily: 'Poppins')),
                        ),
                      ))
                          .toList(),
                    ),

                    const SizedBox(height: 24),

                    if (_searching)
                      Center(
                        child: Column(
                          children: [
                            const CircularProgressIndicator(
                                color: Color(0xFF7B2FFF)),
                            const SizedBox(height: 12),
                            Text('Searching medical database...',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontFamily: 'Poppins',
                                    fontSize: 12)),
                          ],
                        ),
                      )
                    else if (_result != null) ...[
                      if (_result!['notFound'] == true) ...[
                        _glassCard(
                          child: Center(
                            child: Column(
                              children: [
                                const Icon(Icons.search_off_rounded,
                                    color: Color(0xFFFF6B6B), size: 40),
                                const SizedBox(height: 12),
                                Text(
                                  '"${_result!['name']}" not found in database.\nTry searching: Metformin, Paracetamol, Ibuprofen',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontFamily: 'Poppins',
                                      fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ] else ...[
                        _drugResultCard(_result!),
                      ]
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

  Widget _drugResultCard(Map<String, dynamic> drug) {
    final color = drug['color'] as Color;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _glassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.medication_rounded, color: color, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(drug['name'] as String,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins')),
                        Text(drug['class'] as String,
                            style: TextStyle(
                                color: color,
                                fontSize: 12,
                                fontFamily: 'Poppins')),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _section('📋 Uses', drug['uses'] as String, color),
              const SizedBox(height: 12),
              _section('💊 Dosage', drug['dosage'] as String, color),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _glassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _listSection('✅ Benefits', drug['benefits'] as List, const Color(0xFF43E97B)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _glassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _listSection('⚠️ Side Effects', drug['sideEffects'] as List, const Color(0xFFFFAA44)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _glassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _listSection('🚫 Warnings', drug['warnings'] as List, const Color(0xFFFF6B6B)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _section(String title, String content, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins')),
        const SizedBox(height: 4),
        Text(content,
            style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 13,
                fontFamily: 'Poppins',
                height: 1.5)),
      ],
    );
  }

  Widget _listSection(String title, List items, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins')),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 5),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(item as String,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                        fontFamily: 'Poppins')),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
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