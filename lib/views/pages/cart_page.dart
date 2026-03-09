import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/models/add_to_card_model.dart';
import 'package:project1/utilies/app_colors.dart';
import 'package:project1/utilies/constants.dart';
import 'package:project1/models/product_item_model.dart';
import 'package:project1/view_models/cart_cubit/cart_cubit.dart';
import 'package:project1/views/pages/checkout_page.dart';
import 'package:project1/views/widgets/counter_widget.dart';

class CartPage extends StatefulWidget {
  final List<Plant>? addedToCartPlants;
  const CartPage({Key? key, this.addedToCartPlants}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late final CartCubit _cartCubit;

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
            child: Image.asset('assets/images/add-cart.png'),
          ),
          const SizedBox(height: 10),
          Text(
            'Your Cart is Empty',
            style: TextStyle(
              color: Constants.primaryColor,
              fontWeight: FontWeight.w300,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(AddToCartModel cartItem) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Constants.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              cartItem.product.imgUrl,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 72,
                height: 72,
                color: AppColors.grey2,
                child: const Icon(Icons.local_florist),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Size: ${cartItem.size.name.toUpperCase()}',
                  style: TextStyle(color: Constants.blackColor.withOpacity(.6)),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CounterWidget(
                      value: cartItem.quantity,
                      cartItem: cartItem,
                      cubit: _cartCubit,
                    ),
                    Text(
                      '\$${cartItem.totalPrice.toStringAsFixed(1)}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Constants.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Delete item',
            onPressed: () async {
              await _cartCubit.removeCartItem(cartItem);
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _cartCubit = CartCubit()..getCartItems();
  }

  @override
  void dispose() {
    _cartCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider.value(
      value: _cartCubit,
      child: BlocConsumer<CartCubit, CartState>(
        bloc: _cartCubit,
        listener: (context, state) {
          if (state is CartError || state is QuantityCounterError) {
            final message = state is CartError
                ? state.message
                : (state as QuantityCounterError).message;
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          }
        },
        builder: (context, state) {
          if (state is CartLoading || state is CartInitial) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator.adaptive()),
            );
          }

          if (state is CartLoaded) {
            if (state.cartItems.isEmpty) {
              return Scaffold(body: _buildEmptyCart());
            }

            return Scaffold(
              body: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 20,
                ),
                height: size.height,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.cartItems.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = state.cartItems[index];
                          return _buildCartItem(item);
                        },
                      ),
                    ),
                    const Divider(thickness: 1.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Totals',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          '\$${state.subtotal.toStringAsFixed(1)}',
                          style: TextStyle(
                            fontSize: 24.0,
                            color: Constants.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const CheckoutPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Proceed to Checkout',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Scaffold(body: _buildEmptyCart());
        },
      ),
    );
  }
}
