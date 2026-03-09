import 'package:project1/models/add_to_card_model.dart';
import 'package:project1/services/auth_serviecies.dart';
import 'package:project1/services/cart_servicies.dart';
import 'package:project1/view_models/safe_cubit.dart';

part 'cart_state.dart';

class CartCubit extends SafeCubit<CartState> {
  CartCubit() : super(CartInitial());

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
    final nextQuantity = (initialValue ?? cartItem.quantity) + 1;
    try {
      emit(QuantityCounterLoading());
      final updatedCartItem = cartItem.copyWith(quantity: nextQuantity);
      final currentUser = authServices.currentUser();

      if (currentUser == null) {
        throw StateError('Not logged in');
      }

      await cartServices.setCartItem(currentUser.uid, updatedCartItem);
      emit(
        QuantityCounterLoaded(
          value: nextQuantity,
          productId: updatedCartItem.product.id,
        ),
      );
      final cartItems = await cartServices.fetchCartItems(currentUser.uid);
      emit(CartLoaded(cartItems, _subtotal(cartItems)));
    } catch (e) {
      emit(QuantityCounterError(e.toString()));
    }
  }

  Future<void> decrementCounter(
    AddToCartModel cartItem, [
    int? initialValue,
  ]) async {
    final currentQuantity = initialValue ?? cartItem.quantity;
    if (currentQuantity <= 1) {
      await removeCartItem(cartItem);
      return;
    }
    final nextQuantity = currentQuantity - 1;

    try {
      emit(QuantityCounterLoading());
      final updatedCartItem = cartItem.copyWith(quantity: nextQuantity);
      final currentUser = authServices.currentUser();

      if (currentUser == null) {
        throw StateError('Not logged in');
      }

      await cartServices.setCartItem(currentUser.uid, updatedCartItem);
      emit(
        QuantityCounterLoaded(
          value: nextQuantity,
          productId: updatedCartItem.product.id,
        ),
      );
      final cartItems = await cartServices.fetchCartItems(currentUser.uid);
      emit(CartLoaded(cartItems, _subtotal(cartItems)));
    } catch (e) {
      emit(QuantityCounterError(e.toString()));
    }
  }

  Future<void> removeCartItem(AddToCartModel cartItem) async {
    try {
      final currentUser = authServices.currentUser();
      if (currentUser == null) {
        throw StateError('Not logged in');
      }

      await cartServices.deleteCartItem(currentUser.uid, cartItem.id);
      final cartItems = await cartServices.fetchCartItems(currentUser.uid);
      emit(CartLoaded(cartItems, _subtotal(cartItems)));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  double _subtotal(List<AddToCartModel> cartItems) => cartItems.fold<double>(
    0,
    (previousValue, item) =>
        previousValue + (item.product.price * item.quantity),
  );
}
