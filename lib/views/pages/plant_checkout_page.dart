import 'package:flutter/material.dart';
import 'package:project1/models/product_item_model.dart';
import 'package:project1/models/location_model.dart';
import 'package:project1/models/payment_card_model.dart';
import 'package:project1/models/order_model.dart';
import 'package:project1/utilies/constants.dart';
import 'package:project1/views/pages/addresses_page.dart';
import 'package:project1/views/pages/payment_methods_page.dart';
import 'package:project1/views/pages/root_page.dart';
import 'package:project1/services/location_service.dart';
import 'package:project1/services/order_service.dart';
import 'package:project1/services/payment_card_service.dart';

class PlantCheckoutPage extends StatefulWidget {
  final List<Plant> cartItems;

  const PlantCheckoutPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  State<PlantCheckoutPage> createState() => _PlantCheckoutPageState();
}

class _PlantCheckoutPageState extends State<PlantCheckoutPage> {
  LocationModel? _selectedAddress;
  PaymentCardModel? _selectedPaymentMethod;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDefaultAddress();
    _loadDefaultPayment();
  }

  Future<void> _loadDefaultAddress() async {
    try {
      final addresses = await LocationService.loadAddresses();
      if (addresses.isNotEmpty) {
        setState(() {
          _selectedAddress = addresses.firstWhere(
            (addr) => addr.isDefault,
            orElse: () => addresses.first,
          );
        });
      }
    } catch (e) {
      print('Error loading address: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadDefaultPayment() async {
    try {
      final cards = await PaymentCardService.loadCards();
      if (cards.isNotEmpty && mounted) {
        setState(() {
          // Load the chosen card, or the first card if none is chosen
          _selectedPaymentMethod = cards.firstWhere(
            (card) => card.isChosen,
            orElse: () => cards.first,
          );
        });
      }
    } catch (e) {
      print('Error loading payment method: $e');
    }
  }

  int get _subtotal => widget.cartItems.fold(0, (sum, item) => sum + item.price);
  double get _tax => _subtotal * 0.08; // 8% tax
  int get _shipping => 5;
  double get _total => _subtotal + _tax + _shipping;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Constants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Delivery Address Section
                  _buildSection(
                    title: '1. Delivery Address',
                    child: _selectedAddress != null
                        ? _buildAddressCard()
                        : _buildEmptyCard(
                            'No address selected',
                            'Add Address',
                            () => _navigateToAddresses(),
                          ),
                    onEdit: () => _navigateToAddresses(),
                  ),

                  const SizedBox(height: 8),

                  // Payment Method Section
                  _buildSection(
                    title: '2. Payment Method',
                    child: _selectedPaymentMethod != null
                        ? _buildPaymentCard()
                        : _buildEmptyCard(
                            'No payment method',
                            'Add Payment',
                            () => _navigateToPayment(),
                          ),
                    onEdit: () => _navigateToPayment(),
                  ),

                  const SizedBox(height: 8),

                  // Order Items Section
                  _buildSection(
                    title: '3. Review Items',
                    child: Column(
                      children: widget.cartItems.map((item) {
                        return _buildCartItem(item);
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Order Summary
                  _buildOrderSummary(),

                  const SizedBox(height: 100),
                ],
              ),
            ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
    VoidCallback? onEdit,
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (onEdit != null)
                TextButton(
                  onPressed: onEdit,
                  child: Text(
                    'Change',
                    style: TextStyle(color: Constants.primaryColor),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildAddressCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on, color: Constants.primaryColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedAddress!.address,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_selectedAddress!.city}, ${_selectedAddress!.country} ${_selectedAddress!.postalCode}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.credit_card, color: Constants.primaryColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'VISA',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _selectedPaymentMethod!.cardNumber,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _selectedPaymentMethod!.cardHolderName,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(Plant item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              item.imageURL,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.plantName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Size: ${item.size}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${item.price}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Constants.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow('Subtotal', '\$$_subtotal'),
          const SizedBox(height: 8),
          _buildSummaryRow('Shipping', '\$$_shipping'),
          const SizedBox(height: 8),
          _buildSummaryRow('Tax', '\$${_tax.toStringAsFixed(2)}'),
          const Divider(height: 24, thickness: 1),
          _buildSummaryRow(
            'Total',
            '\$${_total.toStringAsFixed(2)}',
            isBold: true,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isBold = false, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? Constants.primaryColor : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCard(String message, String buttonText, VoidCallback onTap) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            message,
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Constants.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _canPlaceOrder() ? _placeOrder : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Constants.primaryColor,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: Text(
              'Place Order - \$${_total.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _canPlaceOrder() {
    return _selectedAddress != null && 
           _selectedPaymentMethod != null && 
           widget.cartItems.isNotEmpty;
  }

  Future<void> _placeOrder() async {
    // Create order
    final order = OrderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      orderDate: DateTime.now(),
      totalAmount: _total,
      deliveryAddress: _selectedAddress?.address ?? 'Unknown',
      paymentMethod: _selectedPaymentMethod!= null 
          ? 'Card ending in ${_selectedPaymentMethod!.cardNumber.substring(_selectedPaymentMethod!.cardNumber.length - 4)}'
          : 'Unknown',
      items: widget.cartItems.map((plant) => OrderItem(
        plantId: plant.plantId.toString(),
        plantName: plant.plantName,
        plantImage: plant.imageURL,
        price: plant.price.toDouble(),
        quantity: 1, // You can add quantity logic if needed
      )).toList(),
      status: 'pending',
    );

    // Save order
    await OrderService.addOrder(order);

    // Clear cart
    for (var item in widget.cartItems) {
      item.isSelected = false;
    }

    // Show success dialog
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Constants.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: Constants.primaryColor,
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Order Placed Successfully!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Total: \$${_total.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                color: Constants.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your plants will be delivered to:\n${_selectedAddress?.address}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to home page and clear all previous routes
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const RootPage()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Constants.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Continue Shopping',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToAddresses() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddressesPage()),
    );
    await _loadDefaultAddress();
  }

  Future<void> _navigateToPayment() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PaymentMethodsPage()),
    );
    _loadDefaultPayment();
  }
}
