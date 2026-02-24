import 'package:project1/models/home_carsoul_item_model.dart';
import 'package:project1/view_models/safe_cubit.dart';

import 'package:project1/models/product_item_model.dart';
import 'package:project1/services/auth_serviecies.dart';
import 'package:project1/services/favourite_servicies.dart';
import 'package:project1/services/home_servecies.dart';

part 'home_state.dart';

class HomeCubit extends SafeCubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final homeServices = HomeServicesImpl();
  final authServices = AuthServicesImpl();
  final favoriteServices = FavoriteServicesImpl();

  Future<void> getHomeData() async {
    emit(HomeLoading());
    try {
      final currentUser = authServices.currentUser();
      final products = await homeServices.fetchProducts();
      final carouselItems = await homeServices.fetchCarouselItems();
      final favoriteProducts = currentUser == null
          ? <ProductItemModel>[]
          : await favoriteServices.getFavorites(currentUser.uid);

      final List<ProductItemModel> finalProducts = products.map((product) {
        final isFavorite = favoriteProducts.any(
          (item) => item.id == product.id,
        );
        return product.copyWith(isFavorite: isFavorite);
      }).toList();

      emit(HomeLoaded(carouselItems: carouselItems, products: finalProducts));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> setFavorite(ProductItemModel product) async {
    emit(SetFavoriteLoading(product.id));
    try {
      final currentUser = authServices.currentUser();
      if (currentUser == null) {
        emit(SetFavoriteError('Not logged in', product.id));
        return;
      }
      final userId = currentUser.uid;
      final favoriteProducts = await favoriteServices.getFavorites(userId);
      final isFavorite = favoriteProducts.any((item) => item.id == product.id);
      if (isFavorite) {
        await favoriteServices.removeFavorite(userId, product.id);
      } else {
        await favoriteServices.addFavorite(userId, product);
      }
      emit(SetFavoriteSuccess(isFavorite: !isFavorite, productId: product.id));
    } catch (e) {
      emit(SetFavoriteError(e.toString(), product.id));
    }
  }
}
