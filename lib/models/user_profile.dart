// lib/models/user_profile.dart

class UserProfile {
  String name;
  String email;
  String role; // Male, Female, Kids, Senior, Transgender
  int age;
  double height; // in cm
  double weight; // in kg
  String userId;
  String bloodGroup;
  String? profileImagePath;
  String? hrtStatus;
  String? latestHormoneLevel;
  List<HealthRecord> healthRecords;
  List<String> medicalHistory;
  List<String> mentalHealthRecords;
  List<String> hospitalVisits;

  UserProfile({
    required this.name,
    required this.email,
    this.role = '',
    this.age = 19,
    this.height = 156,
    this.weight = 45,
    required this.userId,
    this.bloodGroup = 'O+',
    this.profileImagePath,
    this.hrtStatus,
    this.latestHormoneLevel,
    this.healthRecords = const [],
    this.medicalHistory = const [],
    this.mentalHealthRecords = const [],
    this.hospitalVisits = const [],
  });
}

class HealthRecord {
  String condition;
  List<String> medications;
  List<String> allergies;
  String recordId;
  DateTime lastUpdated;

  HealthRecord({
    required this.condition,
    this.medications = const [],
    this.allergies = const [],
    required this.recordId,
    required this.lastUpdated,
  });
}
