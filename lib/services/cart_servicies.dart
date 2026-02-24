

import 'package:project1/models/add_to_card_model.dart';
import 'package:project1/services/fire_store_serviecies.dart';
import 'package:project1/utilies/api_paths.dart';

abstract class CartServices {
  Future<List<AddToCartModel>> fetchCartItems(String userId);
  Future<void> setCartItem(String userId, AddToCartModel cartItem);
  Future<void> deleteCartItem(String userId, String cartItemId);
}

class CartServicesImpl implements CartServices {
  final firestoreServices = FirestoreServices.instance;

  @override
  Future<List<AddToCartModel>> fetchCartItems(String userId) async =>
      await firestoreServices.getCollection(
        path: ApiPaths.cartItems(userId),
        builder: (data, documentId) => AddToCartModel.fromMap(data),
      );

  @override
  Future<void> setCartItem(String userId, AddToCartModel cartItem) async =>
      await firestoreServices.setData(
        path: ApiPaths.cartItem(userId, cartItem.id),
        data: cartItem.toMap(),
      );

  @override
  Future<void> deleteCartItem(String userId, String cartItemId) async =>
      await firestoreServices.deleteData(
        path: ApiPaths.cartItem(userId, cartItemId),
      );
}