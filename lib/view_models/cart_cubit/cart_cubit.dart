import 'package:project1/models/add_to_card_model.dart';
import 'package:project1/services/auth_serviecies.dart';
import 'package:project1/services/cart_servicies.dart';
import 'package:project1/view_models/safe_cubit.dart';

part 'cart_state.dart';

class CartCubit extends SafeCubit<CartState> {
  CartCubit() : super(CartInitial());
  int quantity = 1;

  final cartServices = CartServicesImpl();
  final authServices = AuthServicesImpl();

  Future<void> getCartItems() async {
    emit(CartLoading());
    try {
      final currentUser = authServices.currentUser();
      if (currentUser == null) {
        emit(const CartLoaded([], 0));
        return;
      }
      final cartItems = await cartServices.fetchCartItems(currentUser.uid);

      emit(CartLoaded(cartItems, _subtotal(cartItems)));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> incrementCounter(
    AddToCartModel cartItem, [
    int? initialValue,
  ]) async {
    if (initialValue != null) {
      quantity = initialValue;
    }
    quantity++;
    try {
      emit(QuantityCounterLoading());
      final updatedCartItem = cartItem.copyWith(quantity: quantity);
      final currentUser = authServices.currentUser();

      if (currentUser == null) {
        throw StateError('Not logged in');
      }

      await cartServices.setCartItem(currentUser.uid, updatedCartItem);
      emit(
        QuantityCounterLoaded(
          value: quantity,
          productId: updatedCartItem.product.id,
        ),
      );
      final cartItems = await cartServices.fetchCartItems(currentUser.uid);
      emit(SubtotalUpdated(_subtotal(cartItems)));
    } catch (e) {
      emit(QuantityCounterError(e.toString()));
    }
  }

  Future<void> decrementCounter(
    AddToCartModel cartItem, [
    int? initialValue,
  ]) async {
    if (initialValue != null) {
      quantity = initialValue;
    }
    quantity--;
    try {
      emit(QuantityCounterLoading());
      final updatedCartItem = cartItem.copyWith(quantity: quantity);
      final currentUser = authServices.currentUser();

      if (currentUser == null) {
        throw StateError('Not logged in');
      }

      await cartServices.setCartItem(currentUser.uid, updatedCartItem);
      emit(
        QuantityCounterLoaded(
          value: quantity,
          productId: updatedCartItem.product.id,
        ),
      );
      final cartItems = await cartServices.fetchCartItems(currentUser.uid);
      emit(SubtotalUpdated(_subtotal(cartItems)));
    } catch (e) {
      emit(QuantityCounterError(e.toString()));
    }
  }

  double _subtotal(List<AddToCartModel> cartItems) => cartItems.fold<double>(
    0,
    (previousValue, item) =>
        previousValue + (item.product.price * item.quantity),
  );
}
