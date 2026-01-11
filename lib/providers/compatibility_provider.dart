import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/compatibility_result.dart';

class CompatibilityProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<CompatibilityResult> _results = [];
  bool _isLoading = false;

  List<CompatibilityResult> get results => _results;
  bool get isLoading => _isLoading;

  // Collection reference
  CollectionReference get _collection => _firestore.collection('compatibility_results');

  // Load results from Firestore
  Future<void> loadResults() async {
    _isLoading = true;
    notifyListeners();

    try {
      final querySnapshot = await _collection
          .orderBy('testDate', descending: true)
          .get();

      _results = querySnapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return CompatibilityResult.fromJson({
              ...data,
              'id': doc.id,
            });
          })
          .toList();
      
      debugPrint('✅ Loaded ${_results.length} results from Firestore');
    } catch (e) {
      debugPrint('❌ Error loading results: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // CREATE - Add new result
  Future<void> addResult(CompatibilityResult result) async {
    try {
      // Simpan ke Firestore (tanpa ID, biar Firestore yang generate)
      final data = result.toJson();
      data.remove('id'); // Hapus ID dulu
      
      final docRef = await _collection.add(data);
      
      // Update result dengan ID dari Firestore
      final newResult = result.copyWith(id: docRef.id);
      _results.insert(0, newResult);
      notifyListeners();
      
      debugPrint('✅ Added result with ID: ${docRef.id}');
    } catch (e) {
      debugPrint('❌ Error adding result: $e');
    }
  }

  // READ - Get result by ID
  CompatibilityResult? getResultById(String id) {
    try {
      return _results.firstWhere((result) => result.id == id);
    } catch (e) {
      return null;
    }
  }

  // READ - Get results by partner name
  List<CompatibilityResult> getResultsByPartner(String partnerName) {
    return _results
        .where((result) =>
            result.partnerName.toLowerCase() == partnerName.toLowerCase())
        .toList();
  }

  // UPDATE - Update existing result
  Future<void> updateResult(String id, CompatibilityResult updatedResult) async {
    try {
      final data = updatedResult.toJson();
      data.remove('id'); // Jangan simpan ID ke Firestore
      
      await _collection.doc(id).update(data);
      
      final index = _results.indexWhere((result) => result.id == id);
      if (index != -1) {
        _results[index] = updatedResult;
        _results.sort((a, b) => b.testDate.compareTo(a.testDate));
        notifyListeners();
      }
      
      debugPrint('✅ Updated result with ID: $id');
    } catch (e) {
      debugPrint('❌ Error updating result: $e');
    }
  }

  // DELETE - Remove result by ID
  Future<void> deleteResult(String id) async {
    try {
      await _collection.doc(id).delete();
      _results.removeWhere((result) => result.id == id);
      notifyListeners();
      
      debugPrint('✅ Deleted result with ID: $id');
    } catch (e) {
      debugPrint('❌ Error deleting result: $e');
    }
  }

  // DELETE ALL - Clear all results
  Future<void> clearAllResults() async {
    try {
      final batch = _firestore.batch();
      for (var result in _results) {
        batch.delete(_collection.doc(result.id));
      }
      await batch.commit();
      
      _results.clear();
      notifyListeners();
      
      debugPrint('✅ Cleared all results');
    } catch (e) {
      debugPrint('❌ Error clearing results: $e');
    }
  }

  // Get comparison data for a partner
  List<CompatibilityResult> getComparisonData(String partnerName) {
    final partnerResults = getResultsByPartner(partnerName);
    partnerResults.sort((a, b) => a.testDate.compareTo(b.testDate));
    return partnerResults;
  }

  // Get average percentage for a partner
  double getAveragePercentage(String partnerName) {
    final partnerResults = getResultsByPartner(partnerName);
    if (partnerResults.isEmpty) return 0;
    
    double total = partnerResults.fold(0, (sum, result) => sum + result.percentage);
    return total / partnerResults.length;
  }

  // Check if partner already has tests
  bool hasTestsWithPartner(String partnerName) {
    return _results.any(
      (result) => result.partnerName.toLowerCase() == partnerName.toLowerCase(),
    );
  }

  // Get latest test with partner
  CompatibilityResult? getLatestTestWithPartner(String partnerName) {
    final partnerResults = getResultsByPartner(partnerName);
    if (partnerResults.isEmpty) return null;
    return partnerResults.first;
  }
}