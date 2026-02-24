import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:project1/models/category_model.dart';
import 'package:project1/models/home_carsoul_item_model.dart';
import 'package:project1/models/location_item_model.dart';
import 'package:project1/models/payment_card_model.dart';
import 'package:project1/models/product_item_model.dart';
import 'package:project1/models/user_data.dart';
import 'package:project1/utilies/api_paths.dart';
import 'package:project1/utilies/demo_mode.dart';

class FirestoreServices {
  static const Duration _firebaseTimeout = Duration(seconds: 2);
  static const bool _fallbackToDemoOnError = true;

  // Singleton
  FirestoreServices._() {
    if (kDemoMode) {
      _seedDemoData();
      _demoSeeded = true;
    }
  }
  static final instance = FirestoreServices._();

  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  final Map<String, Map<String, Map<String, dynamic>>> _demoDb = {};
  bool _demoSeeded = false;

  void _ensureDemoSeeded() {
    if (_demoSeeded) {
      return;
    }
    _seedDemoData();
    _demoSeeded = true;
  }

  void _seedDemoData() {
    _putCollection('products',
        {for (final p in Plant.plantList) p.id: p.toMap()});
    _putCollection('announcements',
        {for (final a in dummyHomeCarouselItems) a.id: a.toMap()});
    _putCollection('categories',
        {for (final c in dummyCategories) c.id: c.toMap()});

    final demoUser = UserData(
      id: kDemoUserId,
      username: kDemoDisplayName,
      email: kDemoEmail,
      createdAt: DateTime.now().toIso8601String(),
    );
    _putCollection('users', {kDemoUserId: demoUser.toMap()});

    final seededLocations = <LocationItemModel>[
      dummyLocations.first.copyWith(isChosen: true),
      ...dummyLocations.skip(1),
    ];
    _putCollection(
      ApiPaths.locations(kDemoUserId),
      {for (final loc in seededLocations) loc.id: loc.toMap()},
    );

    final seededCards = <PaymentCardModel>[
      dummyPaymentCards.first.copyWith(
        isChosen: true,
        cardHolderName: kDemoDisplayName,
      ),
      ...dummyPaymentCards.skip(1),
    ];
    _putCollection(
      ApiPaths.paymentCards(kDemoUserId),
      {for (final card in seededCards) card.id: card.toMap()},
    );
  }

  String _normalizeCollectionPath(String path) {
    var normalized = path.trim();
    while (normalized.endsWith('/')) {
      normalized = normalized.substring(0, normalized.length - 1);
    }
    return normalized;
  }

  (String collectionPath, String documentId) _splitDocPath(String path) {
    final segments = path.split('/').where((s) => s.isNotEmpty).toList();
    if (segments.length < 2) {
      throw ArgumentError.value(path, 'path', 'Invalid document path');
    }
    final documentId = segments.removeLast();
    return (segments.join('/'), documentId);
  }

  void _putCollection(
    String collectionPath,
    Map<String, Map<String, dynamic>> docs,
  ) {
    _demoDb[_normalizeCollectionPath(collectionPath)] = {
      for (final entry in docs.entries) entry.key: Map.of(entry.value),
    };
  }

  // add & update data
  Future<void> setData({
    required String path, // Collection/$documentId
    required Map<String, dynamic> data,
  }) async {
    if (kDemoMode) {
      final (collectionPath, documentId) = _splitDocPath(path);
      final normalizedCollection = _normalizeCollectionPath(collectionPath);
      final collection = _demoDb.putIfAbsent(normalizedCollection, () => {});
      collection[documentId] = Map.of(data);
      return;
    }

    try {
      final reference = firestore.doc(path);
      debugPrint('$path: $data');
      await reference.set(data).timeout(_firebaseTimeout);
    } catch (e) {
      if (!_fallbackToDemoOnError) {
        rethrow;
      }
      _ensureDemoSeeded();
      final (collectionPath, documentId) = _splitDocPath(path);
      final normalizedCollection = _normalizeCollectionPath(collectionPath);
      final collection = _demoDb.putIfAbsent(normalizedCollection, () => {});
      collection[documentId] = Map.of(data);
    }
  }

  Future<void> deleteData({required String path}) async { 
    if (kDemoMode) {
      final (collectionPath, documentId) = _splitDocPath(path);
      final normalizedCollection = _normalizeCollectionPath(collectionPath);
      _demoDb[normalizedCollection]?.remove(documentId);
      return;
    }

    try {
      final reference = firestore.doc(path);
      debugPrint('delete: $path');
      await reference.delete().timeout(_firebaseTimeout);
    } catch (e) {
      if (!_fallbackToDemoOnError) {
        rethrow;
      }
      _ensureDemoSeeded();
      final (collectionPath, documentId) = _splitDocPath(path);
      final normalizedCollection = _normalizeCollectionPath(collectionPath);
      _demoDb[normalizedCollection]?.remove(documentId);
    }
  }

  Stream<List<T>> collectionStream<T>({
    required String path, // products/
    required T Function(Map<String, dynamic> data, String documentId) builder,
    Query Function(Query query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) {
    if (kDemoMode) {
      final normalizedCollection = _normalizeCollectionPath(path);
      final docs = _demoDb[normalizedCollection] ?? {};
      final result = docs.entries
          .map((e) => builder(Map.of(e.value), e.key))
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return Stream.value(result);
    }

    Query query = firestore.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => builder(snapshot.data() as Map<String, dynamic>, snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Stream<T> documentStream<T>({
    required String path, // products/1
    required T Function(Map<String, dynamic> data, String documentID) builder,
  }) {
    if (kDemoMode) {
      final (collectionPath, documentId) = _splitDocPath(path);
      final normalizedCollection = _normalizeCollectionPath(collectionPath);
      final data = _demoDb[normalizedCollection]?[documentId] ?? {};
      return Stream.value(builder(Map.of(data), documentId));
    }

    final reference = firestore.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data() as Map<String, dynamic>, snapshot.id));
  }

  // One Time Request for the document
  Future<T> getDocument<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentID) builder,
  }) async {
    if (kDemoMode) {
      final (collectionPath, documentId) = _splitDocPath(path);
      final normalizedCollection = _normalizeCollectionPath(collectionPath);
      final data = _demoDb[normalizedCollection]?[documentId];
      if (data == null) {
        throw StateError('Document not found: $path');
      }
      return builder(Map.of(data), documentId);
    }

    try {
      final reference = firestore.doc(path);
      final snapshot = await reference.get().timeout(_firebaseTimeout);
      final data = snapshot.data();
      if (data == null) {
        throw StateError('Document not found: $path');
      }
      return builder(data, snapshot.id);
    } catch (e) {
      if (!_fallbackToDemoOnError) {
        rethrow;
      }
      _ensureDemoSeeded();
      final (collectionPath, documentId) = _splitDocPath(path);
      final normalizedCollection = _normalizeCollectionPath(collectionPath);
      final data = _demoDb[normalizedCollection]?[documentId];
      if (data == null) {
        throw StateError('Document not found: $path');
      }
      return builder(Map.of(data), documentId);
    }
  }

  // One Time Request for a list of documents
  Future<List<T>> getCollection<T>({
    required String path, // users/$userId/products
    required T Function(Map<String, dynamic> data, String documentId) builder,
    Query Function(Query query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) async {
    if (kDemoMode) {
      final normalizedCollection = _normalizeCollectionPath(path);
      final docs = _demoDb[normalizedCollection] ?? {};
      final result = docs.entries
          .map((e) => builder(Map.of(e.value), e.key))
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    }

    try {
      Query query = firestore.collection(path);
      if (queryBuilder != null) {
        query = queryBuilder(query);
      }
      final snapshots = await query.get().timeout(_firebaseTimeout);
      final result = snapshots.docs
          .map((snapshot) =>
              builder(snapshot.data() as Map<String, dynamic>, snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    } catch (e) {
      if (!_fallbackToDemoOnError) {
        rethrow;
      }
      _ensureDemoSeeded();
      final normalizedCollection = _normalizeCollectionPath(path);
      final docs = _demoDb[normalizedCollection] ?? {};
      final result = docs.entries
          .map((e) => builder(Map.of(e.value), e.key))
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    }
  }
}