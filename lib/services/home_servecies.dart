
import 'package:project1/models/category_model.dart';
import 'package:project1/models/home_carsoul_item_model.dart';
import 'package:project1/models/product_item_model.dart';
import 'package:project1/services/fire_store_serviecies.dart';
import 'package:project1/utilies/api_paths.dart';

abstract class HomeServices {
  Future<List<ProductItemModel>> fetchProducts();
  Future<List<HomeCarouselItemModel>> fetchCarouselItems();
  Future<List<CategoryModel>> fetchCategories();
}

class HomeServicesImpl implements HomeServices {
  final firestoreServices = FirestoreServices.instance;

  @override
  Future<List<ProductItemModel>> fetchProducts() async {
    try {
      final result = await firestoreServices.getCollection<ProductItemModel>(
        path: ApiPaths.products(),
        builder: (data, documentId) {
          final map = Map<String, dynamic>.from(data);
          map.putIfAbsent('id', () => documentId);
          return ProductItemModel.fromMap(map);
        },
      );
      if (result.isNotEmpty) {
        return result;
      }
    } catch (_) {
      // Fall back to local dummy data when Firebase isn't configured/available.
    }
    return Plant.plantList; // Use Plant Store data instead of dummyProducts
  }

  @override
  Future<List<HomeCarouselItemModel>> fetchCarouselItems() async {
    try {
      final result =
          await firestoreServices.getCollection<HomeCarouselItemModel>(
        path: ApiPaths.announcements(),
        builder: (data, documentId) {
          final map = Map<String, dynamic>.from(data);
          map.putIfAbsent('id', () => documentId);
          return HomeCarouselItemModel.fromMap(map);
        },
      );
      if (result.isNotEmpty) {
        return result;
      }
    } catch (_) {
      // Fall back to local dummy data when Firebase isn't configured/available.
    }
    return dummyHomeCarouselItems;
  }

  @override
  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final result = await firestoreServices.getCollection<CategoryModel>(
        path: ApiPaths.categories(),
        builder: (data, documentId) {
          final map = Map<String, dynamic>.from(data);
          map.putIfAbsent('id', () => documentId);
          return CategoryModel.fromMap(map);
        },
      );
      if (result.isNotEmpty) {
        return result;
      }
    } catch (_) {
      // Fall back to local dummy data when Firebase isn't configured/available.
    }
    return dummyCategories;
  }
}