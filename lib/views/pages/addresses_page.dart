import 'package:flutter/material.dart';
import 'package:project1/models/location_model.dart';
import 'package:project1/views/pages/location_picker_page.dart';
import 'package:project1/services/location_service.dart';
import 'package:project1/utilies/constants.dart';

class AddressesPage extends StatefulWidget {
  const AddressesPage({super.key});

  @override
  State<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  List<LocationModel> _savedAddresses = [];
  LocationModel? _selectedAddress;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    setState(() => _isLoading = true);
    try {
      final addresses = await LocationService.loadAddresses();
      setState(() {
        _savedAddresses = addresses;
        if (_savedAddresses.isNotEmpty) {
          _selectedAddress = _savedAddresses.firstWhere(
            (addr) => addr.isDefault,
            orElse: () => _savedAddresses.first,
          );
        } else {
          _selectedAddress = null;
        }
      });
    } catch (e) {
      print('Error loading addresses: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addNewAddress() async {
    final result = await Navigator.push<LocationModel>(
      context,
      MaterialPageRoute(builder: (context) => const LocationPickerPage()),
    );

    if (result != null) {
      await LocationService.addAddress(result);
      await _loadAddresses();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Address added successfully')),
        );
      }
    }
  }

  Future<void> _editAddress(LocationModel address) async {
    final result = await Navigator.push<LocationModel>(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerPage(initialLocation: address),
      ),
    );

    if (result != null) {
      await LocationService.updateAddress(result.copyWith(id: address.id));
      await _loadAddresses();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Address updated')));
      }
    }
  }

  Future<void> _deleteAddress(LocationModel address) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address?'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await LocationService.deleteAddress(address.id);
              await _loadAddresses();
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Address deleted')),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _setAsDefault(LocationModel address) async {
    await LocationService.setDefaultAddress(address.id);
    await _loadAddresses();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${address.address} set as default'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Addresses')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _savedAddresses.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off, size: 64, color: Constants.primaryColor.withOpacity(.5)),
                  const SizedBox(height: 16),
                  Text(
                    'No Addresses',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your first address to get started',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _addNewAddress,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Address'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _savedAddresses.length,
              itemBuilder: (context, index) {
                final address = _savedAddresses[index];
                final isSelected = _selectedAddress?.id == address.id;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          address.isDefault
                              ? Icons.location_on
                              : Icons.location_on_outlined,
                          color: address.isDefault ? Constants.primaryColor : Colors.grey,
                        ),
                        title: Text(address.address),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              '${address.city}, ${address.country} • ${address.postalCode}',
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Coordinates: ${address.latitude.toStringAsFixed(4)}, ${address.longitude.toStringAsFixed(4)}',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                        selected: isSelected,
                        onTap: () {
                          setState(() => _selectedAddress = address);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            if (!address.isDefault)
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => _setAsDefault(address),
                                  icon: const Icon(Icons.check, size: 18),
                                  label: const Text('Set Default'),
                                ),
                              ),
                            if (!address.isDefault) const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _editAddress(address),
                                icon: const Icon(Icons.edit, size: 18),
                                label: const Text('Edit'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _deleteAddress(address),
                                icon: const Icon(Icons.delete, size: 18),
                                label: const Text('Delete'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewAddress,
        backgroundColor: Constants.primaryColor,
        icon: const Icon(Icons.add),
        label: const Text('Add Address'),
      ),
    );
  }
}
