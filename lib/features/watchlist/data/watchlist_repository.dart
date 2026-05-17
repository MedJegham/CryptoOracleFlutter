import 'package:cloud_firestore/cloud_firestore.dart';

class WatchlistRepository {
  final FirebaseFirestore _firestore;

  WatchlistRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _firestore.collection('users').doc(uid);

  Future<List<String>> getWatchlist(String uid) async {
    final snapshot = await _userDoc(uid).get();
    final raw = snapshot.data()?['watchlist'];
    if (raw is List) {
      return raw.whereType<String>().toList();
    }
    return [];
  }

  Future<void> addToWatchlist(String uid, String coinId) async {
    await _userDoc(uid).set(
      {
        'watchlist': FieldValue.arrayUnion([coinId]),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> removeFromWatchlist(String uid, String coinId) async {
    await _userDoc(uid).set(
      {
        'watchlist': FieldValue.arrayRemove([coinId]),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> clearWatchlist(String uid) async {
    await _userDoc(uid).set(
      {'watchlist': <String>[]},
      SetOptions(merge: true),
    );
  }
}
