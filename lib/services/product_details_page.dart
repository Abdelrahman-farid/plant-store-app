
import 'package:project1/models/add_to_card_model.dart';
import 'package:project1/models/product_item_model.dart';
import 'package:project1/services/fire_store_serviecies.dart';
import 'package:project1/utilies/api_paths.dart';

abstract class ProductDetailsServices {
  Future<ProductItemModel> fetchProductDetails(String productId);
  Future<void> addToCart(AddToCartModel cartItem, String userId);
}

class ProductDetailsServicesImpl implements ProductDetailsServices {
  final firestoreServices = FirestoreServices.instance;

  @override
  Future<ProductItemModel> fetchProductDetails(String productId) async {
    try {
      final selectedProduct = await firestoreServices.getDocument<ProductItemModel>(
        path: ApiPaths.product(productId),
        builder: (data, documentId) {
          final map = Map<String, dynamic>.from(data);
          map.putIfAbsent('id', () => documentId);
          return ProductItemModel.fromMap(map);
        },
      );
      return selectedProduct;
    } catch (_) {
      return Plant.plantList.firstWhere(
        (p) => p.id == productId,
        orElse: () => Plant.plantList.first,
      );
    }
  }

  @override
  Future<void> addToCart(AddToCartModel cartItem, String userId) async =>
      await firestoreServices.setData(
        path: ApiPaths.cartItem(userId, cartItem.id),
        data: cartItem.toMap(),
      );
}