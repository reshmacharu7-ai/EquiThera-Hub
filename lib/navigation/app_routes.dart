// lib/navigation/app_routes.dart
import 'package:flutter/material.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/welcome/welcome_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/signup/signup_screen.dart';
import '../screens/role_selection/role_selection_screen.dart';
import '../screens/dashboard/common_dashboard.dart';
import '../screens/dashboard/transgender_dashboard.dart';
import '../screens/features/scan_prescription_screen.dart';
import '../screens/features/explain_medication_screen.dart';
import '../screens/features/drug_interaction_screen.dart';
import '../screens/features/ai_medical_helpline_screen.dart';
import '../screens/features/mental_health_bot_screen.dart';
import '../screens/features/emergency_sos_screen.dart';
import '../screens/features/health_records_screen.dart';
import '../screens/features/personalized_risk_alerts_screen.dart';
import '../screens/features/transgender/hormone_therapy_tracker_screen.dart';
import '../screens/features/transgender/hormone_lab_monitoring_screen.dart';
import '../screens/features/transgender/gender_affirmation_screen.dart';
import '../screens/features/transgender/transition_timeline_screen.dart';
import '../core/animations/page_transitions.dart';
import '../models/user_profile.dart';

class AppRoutes {
  static const splash = '/';
  static const welcome = '/welcome';
  static const login = '/login';
  static const signup = '/signup';
  static const roleSelection = '/role_selection';
  static const dashboard = '/dashboard';
  static const transgenderDashboard = '/transgender_dashboard';

  // Common features
  static const scanPrescription = '/scan_prescription';
  static const explainMedication = '/explain_medication';
  static const drugInteraction = '/drug_interaction';
  static const aiMedicalHelpline = '/ai_medical_helpline';
  static const mentalHealthBot = '/mental_health_bot';
  static const emergencySos = '/emergency_sos';
  static const healthRecords = '/health_records';
  static const riskAlerts = '/risk_alerts';

  // Transgender-specific features
  static const hormoneTherapyTracker = '/hormone_therapy_tracker';
  static const hormoneLabMonitoring = '/hormone_lab_monitoring';
  static const genderAffirmation = '/gender_affirmation';
  static const transitionTimeline = '/transition_timeline';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return FadePageRoute(const SplashScreen());

      case welcome:
        return SlidePageRoute(const WelcomeScreen());

      case login:
        return SlidePageRoute(const LoginScreen());

      case signup:
        return SlidePageRoute(const SignupScreen());

      case roleSelection:
        final user = settings.arguments as UserProfile?;
        return SlidePageRoute(RoleSelectionScreen(user: user));

      case dashboard:
        final user = settings.arguments as UserProfile?;
        return SlidePageRoute(CommonDashboard(user: user));

      case transgenderDashboard:
        final user = settings.arguments as UserProfile?;
        return SlidePageRoute(TransgenderDashboard(user: user));

    // Common features
      case scanPrescription:
        final user = settings.arguments as UserProfile?;
        return SlidePageRoute(ScanPrescriptionScreen(user: user));

      case explainMedication:
        final user = settings.arguments as UserProfile?;
        return SlidePageRoute(ExplainMedicationScreen(user: user));

      case drugInteraction:
        final user = settings.arguments as UserProfile?;
        return SlidePageRoute(DrugInteractionScreen(user: user));

      case aiMedicalHelpline:
        final user = settings.arguments as UserProfile?;
        return SlidePageRoute(AiMedicalHelplineScreen(user: user));

      case mentalHealthBot:
        final user = settings.arguments as UserProfile?;
        return SlidePageRoute(MentalHealthBotScreen(user: user));

      case emergencySos:
        final user = settings.arguments as UserProfile?;
        return SlidePageRoute(EmergencySosScreen(user: user));

      case healthRecords:
        final user = settings.arguments as UserProfile?;
        return SlidePageRoute(HealthRecordsScreen(user: user));

      case riskAlerts:
        final user = settings.arguments as UserProfile?;
        return SlidePageRoute(PersonalizedRiskAlertsScreen(user: user));

    // Transgender-specific features
      case hormoneTherapyTracker:
        final user = settings.arguments as UserProfile?;
        return SlidePageRoute(HormoneTherapyTrackerScreen(user: user));

      case hormoneLabMonitoring:
        final user = settings.arguments as UserProfile?;
        return SlidePageRoute(HormoneLabMonitoringScreen(user: user));

      case genderAffirmation:
        final user = settings.arguments as UserProfile?;
        return SlidePageRoute(GenderAffirmationScreen(user: user));

      case transitionTimeline:
        final user = settings.arguments as UserProfile?;
        return SlidePageRoute(TransitionTimelineScreen(user: user));

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route Not Found')),
          ),
        );
    }
  }
}
