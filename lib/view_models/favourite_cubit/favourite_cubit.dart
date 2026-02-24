import 'package:project1/models/product_item_model.dart';
import 'package:project1/services/auth_serviecies.dart';
import 'package:project1/services/favourite_servicies.dart';
import 'package:project1/view_models/safe_cubit.dart';

part 'favourite_state.dart';

class FavoriteCubit extends SafeCubit<FavoriteState> {
  FavoriteCubit() : super(FavoriteInitial());

  final favoriteServices = FavoriteServicesImpl();
  final authServices = AuthServicesImpl();

  Future<void> getFavoriteProducts() async {
    emit(FavoriteLoading());
    try {
      final currentUser = authServices.currentUser();
      if (currentUser == null) {
        emit(FavoriteLoaded(const []));
        return;
      }
      final favoriteProducts = await favoriteServices.getFavorites(currentUser.uid);
      emit(FavoriteLoaded(favoriteProducts));
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  Future<void> removeFavorite(String productId) async {
    emit(FavoriteRemoving(productId));
    try {
      final currentUser = authServices.currentUser();
      if (currentUser == null) {
        emit(FavoriteRemoveError('Not logged in'));
        return;
      }
      await favoriteServices.removeFavorite(
        currentUser.uid,
        productId,
      );
      emit(FavoriteRemoved(productId));
      final favoriteProducts = await favoriteServices.getFavorites(
        currentUser.uid,
      );
      emit(FavoriteLoaded(favoriteProducts));
    } catch (e) {
      emit(FavoriteRemoveError(e.toString()));
    }
  
  }
}