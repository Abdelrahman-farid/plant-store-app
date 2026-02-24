import 'package:project1/models/add_to_card_model.dart';
import 'package:project1/models/product_item_model.dart';
import 'package:project1/services/auth_serviecies.dart';
import 'package:project1/services/product_details_page.dart';
import 'package:project1/view_models/safe_cubit.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends SafeCubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsInitial());

  ProductSize? selectedSize;
  int quantity = 1;

  final productDetailsServices = ProductDetailsServicesImpl();
  final authServices = AuthServicesImpl();

  void getProductDetails(String id) async {
    emit(ProductDetailsLoading());
    try {
      final selectedProduct = await productDetailsServices.fetchProductDetails(
        id,
      );
      emit(ProductDetailsLoaded(product: selectedProduct));
    } catch (e) {
      emit(ProductDetailsError(e.toString()));
    }
    // Future.delayed(
    //   const Duration(seconds: 1),
    //   () {
    //     final selectedProduct =
    //         dummyProducts.firstWhere((item) => item.id == id);
    //     emit(ProductDetailsLoaded(product: selectedProduct));
    //   },
    // );
  }

  void selectSize(ProductSize size) {
    selectedSize = size;
    emit(SizeSelected(size: size));
  }

  Future<void> addToCart(String productId) async {
    emit(ProductAddingToCart());
    try {
      final currentUser = authServices.currentUser();
      if (currentUser == null) {
        emit(ProductAddToCartError('Not logged in'));
        return;
      }
      if (selectedSize == null) {
        emit(ProductAddToCartError('Please select a size'));
        return;
      }
      final selectedProduct = await productDetailsServices.fetchProductDetails(
        productId,
      );
      final userId = currentUser.uid;

      final cartItem = AddToCartModel(
        id: DateTime.now().toIso8601String(),
        product: selectedProduct,
        size: selectedSize!,
        quantity: quantity,
      );
      await productDetailsServices.addToCart(cartItem, userId);
      emit(ProductAddedToCart(productId: productId));
    } catch (e) {
      emit(ProductAddToCartError(e.toString()));
    }
  }

  void incrementCounter(String productId) {
    quantity++;
    emit(QuantityCounterLoaded(value: quantity));
  }

  void decrementCounter(String productId) {
    quantity--;
    emit(QuantityCounterLoaded(value: quantity));
  }
}
