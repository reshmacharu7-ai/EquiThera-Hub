// lib/screens/features/drug_interaction_screen.dart
import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/user_profile.dart';

class DrugInteractionScreen extends StatefulWidget {
  final UserProfile? user;
  const DrugInteractionScreen({super.key, this.user});

  @override
  State<DrugInteractionScreen> createState() => _DrugInteractionScreenState();
}

class _DrugInteractionScreenState extends State<DrugInteractionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late Animation<double> _fade;

  final _drugCtrl = TextEditingController();
  final List<String> _drugs = [];
  bool _checking = false;
  List<Map<String, dynamic>>? _results;

  // Interaction database pairs
  final _interactions = {
    'sertraline-tramadol': {
      'severity': 'severe',
      'title': 'Serotonin Syndrome Risk',
      'desc': 'Combining Sertraline and Tramadol can cause dangerously high serotonin levels. Symptoms: agitation, fever, rapid heart rate.',
      'action': 'AVOID — Consult your doctor immediately.',
    },
    'aspirin-warfarin': {
      'severity': 'severe',
      'title': 'Increased Bleeding Risk',
      'desc': 'Both drugs thin the blood. Combined use significantly increases risk of internal bleeding.',
      'action': 'AVOID — Use only under close medical supervision.',
    },
    'metformin-alcohol': {
      'severity': 'moderate',
      'title': 'Lactic Acidosis Risk',
      'desc': 'Alcohol with Metformin can increase the risk of lactic acidosis, especially in high doses.',
      'action': 'CAUTION — Limit alcohol intake.',
    },
    'ibuprofen-aspirin': {
      'severity': 'moderate',
      'title': 'Reduced Aspirin Effect',
      'desc': 'Ibuprofen can block the antiplatelet effect of aspirin, reducing heart protection.',
      'action': 'CAUTION — Take aspirin 2 hours before ibuprofen.',
    },
    'atorvastatin-clarithromycin': {
      'severity': 'severe',
      'title': 'Myopathy Risk',
      'desc': 'Clarithromycin increases Atorvastatin levels, raising risk of muscle damage (rhabdomyolysis).',
      'action': 'AVOID — Use alternative antibiotic.',
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
    _drugCtrl.dispose();
    super.dispose();
  }

  void _addDrug() {
    final drug = _drugCtrl.text.trim();
    if (drug.isEmpty || _drugs.contains(drug)) return;
    setState(() { _drugs.add(drug); _results = null; });
    _drugCtrl.clear();
  }

  Future<void> _checkInteractions() async {
    if (_drugs.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Add at least 2 medications to check',
              style: TextStyle(fontFamily: 'Poppins')),
          backgroundColor: const Color(0xFFFF6B6B),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    setState(() { _checking = true; _results = null; });
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final foundInteractions = <Map<String, dynamic>>[];
    final lowerDrugs = _drugs.map((d) => d.toLowerCase()).toList();

    for (var entry in _interactions.entries) {
      final parts = entry.key.split('-');
      if (parts.every((p) => lowerDrugs.any((d) => d.contains(p) || p.contains(d)))) {
        foundInteractions.add({...entry.value, 'pair': parts.join(' + ')});
      }
    }

    if (foundInteractions.isEmpty) {
      foundInteractions.add({
        'severity': 'none',
        'title': 'No Major Interactions Found',
        'desc': 'No significant interactions detected between your medications. Always consult your doctor for personalized advice.',
        'action': 'Continue as prescribed. Monitor for any unusual symptoms.',
        'pair': _drugs.join(' + '),
      });
    }

    setState(() { _checking = false; _results = foundInteractions; });
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
              title: const Text('Drug Interaction Check',
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
                  children: [
                    // Add drug input
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: TextField(
                                controller: _drugCtrl,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontSize: 14),
                                onSubmitted: (_) => _addDrug(),
                                decoration: InputDecoration(
                                  hintText: 'Enter medication name',
                                  hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.3),
                                      fontFamily: 'Poppins'),
                                  prefixIcon: Icon(Icons.medication_rounded,
                                      color: Colors.white.withOpacity(0.4)),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.07),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                        color: Colors.white.withOpacity(0.1)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                        color: Colors.white.withOpacity(0.1)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFFF6B6B)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: _addDrug,
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF6B6B), Color(0xFFCC3333)],
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.add_rounded,
                                color: Colors.white, size: 24),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Drug chips
                    if (_drugs.isNotEmpty) ...[
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _drugs.map((drug) {
                          return Chip(
                            label: Text(drug,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontSize: 12)),
                            backgroundColor: const Color(0xFFFF6B6B).withOpacity(0.2),
                            side: BorderSide(
                                color: const Color(0xFFFF6B6B).withOpacity(0.4)),
                            deleteIcon: const Icon(Icons.close_rounded,
                                size: 16, color: Colors.white70),
                            onDeleted: () => setState(() {
                              _drugs.remove(drug);
                              _results = null;
                            }),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Quick add suggestions
                    Wrap(
                      spacing: 8,
                      children: ['Sertraline', 'Tramadol', 'Aspirin', 'Ibuprofen', 'Warfarin']
                          .map((d) => GestureDetector(
                        onTap: () {
                          if (!_drugs.contains(d)) {
                            setState(() { _drugs.add(d); _results = null; });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.1)),
                          ),
                          child: Text('+ $d',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 11,
                                  fontFamily: 'Poppins')),
                        ),
                      ))
                          .toList(),
                    ),

                    const SizedBox(height: 20),

                    // Check button
                    GestureDetector(
                      onTap: _checking ? null : _checkInteractions,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF6B6B), Color(0xFFCC3333)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: _checking
                              ? const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 16, height: 16,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              ),
                              SizedBox(width: 10),
                              Text('Checking interactions...',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600)),
                            ],
                          )
                              : const Text('🔍 Check Interactions',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins')),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Results
                    if (_results != null)
                      ...(_results!.map((interaction) {
                        final severity = interaction['severity'] as String;
                        Color sevColor;
                        IconData sevIcon;
                        switch (severity) {
                          case 'severe':
                            sevColor = const Color(0xFFFF4444);
                            sevIcon = Icons.dangerous_rounded;
                            break;
                          case 'moderate':
                            sevColor = const Color(0xFFFFAA44);
                            sevIcon = Icons.warning_rounded;
                            break;
                          default:
                            sevColor = const Color(0xFF43E97B);
                            sevIcon = Icons.check_circle_rounded;
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: sevColor.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                      color: sevColor.withOpacity(0.3)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(sevIcon, color: sevColor, size: 22),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            interaction['title'] as String,
                                            style: TextStyle(
                                                color: sevColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Poppins'),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: sevColor.withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            severity.toUpperCase(),
                                            style: TextStyle(
                                                color: sevColor,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Poppins'),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(interaction['desc'] as String,
                                        style: TextStyle(
                                            color: Colors.white.withOpacity(0.7),
                                            fontSize: 12,
                                            fontFamily: 'Poppins',
                                            height: 1.5)),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: sevColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        '💡 ${interaction['action']}',
                                        style: TextStyle(
                                            color: sevColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Poppins'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      })),

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
}