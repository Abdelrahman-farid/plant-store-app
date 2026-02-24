import 'package:project1/models/add_to_card_model.dart';
import 'package:project1/models/location_item_model.dart';
import 'package:project1/models/payment_card_model.dart';
import 'package:project1/services/auth_serviecies.dart';
import 'package:project1/view_models/safe_cubit.dart';

import 'package:project1/services/cart_servicies.dart';
import 'package:project1/services/chekout_serviecies.dart';
import 'package:project1/services/location_servicies.dart';

part 'checkout_state.dart';

class CheckoutCubit extends SafeCubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitial());

  final checkoutServices = CheckoutServicesImpl();
  final authServices = AuthServicesImpl();
  final locationServices = LocationServicesImpl();
  final cartServices = CartServicesImpl();

  Future<void> getCheckoutContent() async {
    emit(CheckoutLoading());
    try {
      final currentUser = authServices.currentUser();
      if (currentUser == null) {
        throw StateError('Not logged in');
      }
      final userId = currentUser.uid;
      final cartItems = await cartServices.fetchCartItems(userId);
      double shippingValue = 10;
      final subtotal = cartItems.fold(
        0.0,
        (previousValue, element) =>
            previousValue + (element.product.price * element.quantity),
      );
      final numOfProducts = cartItems.fold(
        0,
        (previousValue, element) => previousValue + element.quantity,
      );

      final chosenPaymentCards = await checkoutServices.fetchPaymentMethods(
        userId,
        true,
      );
      final chosenPaymentCard = chosenPaymentCards.isNotEmpty
          ? chosenPaymentCards.first
          : null;

      final chosenAddresses = await locationServices.fetchLocations(
        userId,
        true,
      );
      final chosenAddress = chosenAddresses.isNotEmpty
          ? chosenAddresses.first
          : null;

      emit(
        CheckoutLoaded(
          cartItems: cartItems,
          totalAmount: subtotal + shippingValue,
          subtotal: subtotal,
          shippingValue: shippingValue,
          numOfProducts: numOfProducts,
          chosenPaymentCard: chosenPaymentCard,
          chosenAddress: chosenAddress,
        ),
      );
    } catch (e) {
      emit(CheckoutError(e.toString()));
    }
  }

  Future<String?> placeOrder() async {
    try {
      final currentUser = authServices.currentUser();
      if (currentUser == null) {
        return 'Not logged in';
      }
      final userId = currentUser.uid;

      final cartItems = await cartServices.fetchCartItems(userId);
      if (cartItems.isEmpty) {
        return 'Your cart is empty';
      }

      final chosenPaymentCards = await checkoutServices.fetchPaymentMethods(
        userId,
        true,
      );
      if (chosenPaymentCards.isEmpty) {
        return 'Please add a payment method';
      }

      final chosenAddresses = await locationServices.fetchLocations(
        userId,
        true,
      );
      if (chosenAddresses.isEmpty) {
        return 'Please add a shipping address';
      }

      for (final item in cartItems) {
        await cartServices.deleteCartItem(userId, item.id);
      }

      await getCheckoutContent();
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
