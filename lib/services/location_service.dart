import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project1/models/location_model.dart';

class LocationService {
  static const String _addressesKey = 'saved_addresses';

  // Get user-specific key for addresses
  static String _getUserAddressesKey() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return '${user.uid}_$_addressesKey';
    }
    return 'guest_$_addressesKey';
  }

  static Future<void> saveAddresses(List<LocationModel> addresses) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(
        addresses.map((addr) => addr.toMap()).toList(),
      );
      await prefs.setString(_getUserAddressesKey(), jsonString);
    } catch (e) {
      print('Error saving addresses: $e');
    }
  }

  static Future<List<LocationModel>> loadAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_getUserAddressesKey());

      if (jsonString == null) {
        // Return empty list - no demo data
        return [];
      }

      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((item) =>
              LocationModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading addresses: $e');
      return [];
    }
  }

  static Future<void> addAddress(LocationModel address) async {
    final addresses = await loadAddresses();
    addresses.add(address);
    await saveAddresses(addresses);
  }

  static Future<void> updateAddress(LocationModel address) async {
    final addresses = await loadAddresses();
    final index = addresses.indexWhere((a) => a.id == address.id);
    if (index != -1) {
      addresses[index] = address;
      await saveAddresses(addresses);
    }
  }

  static Future<void> deleteAddress(String addressId) async {
    final addresses = await loadAddresses();
    addresses.removeWhere((a) => a.id == addressId);
    await saveAddresses(addresses);
  }

  static Future<void> setDefaultAddress(String addressId) async {
    final addresses = await loadAddresses();
    for (var addr in addresses) {
      addr = addr.copyWith(isDefault: addr.id == addressId);
    }
    await saveAddresses(addresses);
  }
}
