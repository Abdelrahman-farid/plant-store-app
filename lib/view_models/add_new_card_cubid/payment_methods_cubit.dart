import 'package:project1/models/payment_card_model.dart';
import 'package:project1/services/auth_serviecies.dart';
import 'package:project1/services/chekout_serviecies.dart';
import 'package:project1/view_models/safe_cubit.dart';

part 'payment_methods_state.dart';

class PaymentMethodsCubit extends SafeCubit<PaymentMethodsState> {
  PaymentMethodsCubit() : super(PaymntMethodsInitial());

  String? selectedPaymentId;
  final checkoutServices = CheckoutServicesImpl();
  final authServices = AuthServicesImpl();

  Future<void> addNewCard(
    String cardNumber,
    String cardHolderName,
    String expiryDate,
    String cvv,
  ) async {
    emit(AddNewCardLoading());
    try {
      final newCard = PaymentCardModel(
        id: DateTime.now().toIso8601String(),
        cardNumber: cardNumber,
        cardHolderName: cardHolderName,
        expiryDate: expiryDate,
        cvv: cvv,
      );
      final currentUser = authServices.currentUser();
      if (currentUser == null) {
        emit(AddNewCardFailure('Not logged in'));
        return;
      }
      await checkoutServices.setCard(currentUser.uid, newCard);
      emit(AddNewCardSuccess());
    } catch (e) {
      emit(AddNewCardFailure(e.toString()));
    }
  }

  Future<void> fetchPaymentMethods() async {
    emit(FetchingPaymentMethods());
    try {
      final currentUser = authServices.currentUser();
      if (currentUser == null) {
        emit(FetchedPaymentMethods([]));
        return;
      }
      final paymentCards = await checkoutServices.fetchPaymentMethods(
        currentUser.uid,
      );
      emit(FetchedPaymentMethods(paymentCards));
      if (paymentCards.isNotEmpty) {
        final chosenPaymentMethod = paymentCards.firstWhere(
          (element) => element.isChosen,
          orElse: () => paymentCards.first,
        );
        selectedPaymentId = chosenPaymentMethod.id;
        emit(PaymentMethodChosen(chosenPaymentMethod));
      }
    } catch (e) {
      emit(FetchPaymentMethodsError(e.toString()));
    }
  }

  Future<void> changePaymentMethod(String id) async {
    selectedPaymentId = id;
    try {
      final currentUser = authServices.currentUser();
      if (currentUser == null) {
        emit(FetchPaymentMethodsError('Not logged in'));
        return;
      }
      final tempChosenPaymentMethod = await checkoutServices
          .fetchSinglePaymentMethod(currentUser.uid, selectedPaymentId!);
      emit(PaymentMethodChosen(tempChosenPaymentMethod));
    } catch (e) {
      emit(FetchPaymentMethodsError(e.toString()));
    }
  }

  Future<void> confirmPaymentMethod() async {
    emit(ConfirmPaymentLoading());
    try {
      final currentUser = authServices.currentUser();
      if (currentUser == null) {
        emit(ConfirmPaymentFailure('Not logged in'));
        return;
      }
      final userId = currentUser.uid;

      if (selectedPaymentId == null) {
        emit(ConfirmPaymentFailure('Please select a payment method'));
        return;
      }

      final previousChosenPayment = await checkoutServices.fetchPaymentMethods(
        userId,
        true,
      );
      var chosenPaymentMethod = await checkoutServices.fetchSinglePaymentMethod(
        userId,
        selectedPaymentId!,
      );
      chosenPaymentMethod = chosenPaymentMethod.copyWith(isChosen: true);

      if (previousChosenPayment.isNotEmpty) {
        final previousChosenPaymentMethod = previousChosenPayment.first
            .copyWith(isChosen: false);
        await checkoutServices.setCard(userId, previousChosenPaymentMethod);
      }
      await checkoutServices.setCard(userId, chosenPaymentMethod);
      emit(ConfirmPaymentSuccess());
    } catch (e) {
      emit(ConfirmPaymentFailure(e.toString()));
    }
  }
}
