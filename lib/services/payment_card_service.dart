import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project1/models/payment_card_model.dart';

class PaymentCardService {
  static const String _cardsKey = 'payment_cards';

  // Get user-specific key for payment cards
  static String _getUserCardsKey() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return '${user.uid}_$_cardsKey';
    }
    return 'guest_$_cardsKey';
  }

  static Future<void> saveCards(List<PaymentCardModel> cards) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(
        cards.map((card) => card.toMap()).toList(),
      );
      await prefs.setString(_getUserCardsKey(), jsonString);
    } catch (e) {
      print('Error saving payment cards: $e');
    }
  }

  static Future<List<PaymentCardModel>> loadCards() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_getUserCardsKey());

      if (jsonString == null) {
        return [];
      }

      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((item) => PaymentCardModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading payment cards: $e');
      return [];
    }
  }

  static Future<void> addCard(PaymentCardModel card) async {
    final cards = await loadCards();
    cards.add(card);
    await saveCards(cards);
  }

  static Future<void> updateCard(PaymentCardModel card) async {
    final cards = await loadCards();
    final index = cards.indexWhere((c) => c.id == card.id);
    if (index != -1) {
      cards[index] = card;
      await saveCards(cards);
    }
  }

  static Future<void> deleteCard(String cardId) async {
    final cards = await loadCards();
    cards.removeWhere((c) => c.id == cardId);
    await saveCards(cards);
  }
}
