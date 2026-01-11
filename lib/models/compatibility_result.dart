import 'package:cloud_firestore/cloud_firestore.dart';

class CompatibilityResult {
  final String id;
  final String userName;
  final String partnerName;
  final double percentage;
  final DateTime testDate;
  final List<bool> userAnswers;
  final List<bool> partnerAnswers;
  final String? userId; // untuk multi-user support

  CompatibilityResult({
    required this.id,
    required this.userName,
    required this.partnerName,
    required this.percentage,
    required this.testDate,
    required this.userAnswers,
    required this.partnerAnswers,
    this.userId,
  });

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'partnerName': partnerName,
      'percentage': percentage,
      'testDate': Timestamp.fromDate(testDate),
      'userAnswers': userAnswers,
      'partnerAnswers': partnerAnswers,
      'userId': userId,
    };
  }

  // Create from Firestore Document
  factory CompatibilityResult.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return CompatibilityResult(
      id: doc.id,
      userName: data['userName'] ?? '',
      partnerName: data['partnerName'] ?? '',
      percentage: (data['percentage'] ?? 0).toDouble(),
      testDate: (data['testDate'] as Timestamp).toDate(),
      userAnswers: List<bool>.from(data['userAnswers'] ?? []),
      partnerAnswers: List<bool>.from(data['partnerAnswers'] ?? []),
      userId: data['userId'],
    );
  }

  // Create from JSON (backward compatibility)
  factory CompatibilityResult.fromJson(Map<String, dynamic> json) {
    return CompatibilityResult(
      id: json['id'],
      userName: json['userName'],
      partnerName: json['partnerName'],
      percentage: json['percentage'],
      testDate: json['testDate'] is Timestamp 
          ? (json['testDate'] as Timestamp).toDate()
          : DateTime.parse(json['testDate']),
      userAnswers: List<bool>.from(json['userAnswers']),
      partnerAnswers: List<bool>.from(json['partnerAnswers']),
      userId: json['userId'],
    );
  }

  // Create a copy with updated fields
  CompatibilityResult copyWith({
    String? id,
    String? userName,
    String? partnerName,
    double? percentage,
    DateTime? testDate,
    List<bool>? userAnswers,
    List<bool>? partnerAnswers,
    String? userId,
  }) {
    return CompatibilityResult(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      partnerName: partnerName ?? this.partnerName,
      percentage: percentage ?? this.percentage,
      testDate: testDate ?? this.testDate,
      userAnswers: userAnswers ?? this.userAnswers,
      partnerAnswers: partnerAnswers ?? this.partnerAnswers,
      userId: userId ?? this.userId,
    );
  }
}