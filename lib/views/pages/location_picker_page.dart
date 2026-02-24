import 'package:flutter/material.dart';
import 'package:project1/models/location_model.dart';

class LocationPickerPage extends StatefulWidget {
  final LocationModel? initialLocation;

  const LocationPickerPage({this.initialLocation, super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  late TextEditingController _searchController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _postalController;

  Offset _mapOffset = const Offset(3023.57, 3004.44);
  double _zoom = 1.0;
  List<LocationModel> _searchResults = [];
  LocationModel? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _addressController = TextEditingController(
      text: widget.initialLocation?.address ?? '',
    );
    _cityController = TextEditingController(
      text: widget.initialLocation?.city ?? '',
    );
    _postalController = TextEditingController(
      text: widget.initialLocation?.postalCode ?? '',
    );

    _selectedLocation = widget.initialLocation ?? dummyLocations.first;
    _mapOffset = Offset(
      _selectedLocation!.longitude * 100,
      _selectedLocation!.latitude * 100,
    );
    _zoom = 1.0;

    _updateFields(_selectedLocation!);
  }

  void _updateFields(LocationModel location) {
    setState(() {
      _selectedLocation = location;
      _addressController.text = location.address;
      _cityController.text = location.city;
      _postalController.text = location.postalCode;
    });
  }

  void _searchLocations(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        final results = dummyLocations
            .where(
              (location) =>
                  location.address.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  location.city.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

        setState(() {
          _searchResults = results;
        });
      }
    });
  }

  void _selectLocationFromSearch(LocationModel location) {
    _updateFields(location);
    _mapOffset = Offset(location.longitude * 100, location.latitude * 100);
    _searchController.clear();
    _searchResults.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Location selected: ${location.address}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _saveLocation() {
    if (_addressController.text.isEmpty || _cityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in address and city')),
      );
      return;
    }

    final location = LocationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      address: _addressController.text,
      city: _cityController.text,
      country: 'Egypt',
      latitude: _selectedLocation!.latitude,
      longitude: _selectedLocation!.longitude,
      postalCode: _postalController.text.isEmpty
          ? 'N/A'
          : _postalController.text,
    );

    Navigator.pop(context, location);
  }

  void _useRandomLocation() {
    final random =
        dummyLocations[DateTime.now().millisecond % dummyLocations.length];
    _selectLocationFromSearch(random);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Location'), elevation: 0),
      body: Stack(
        children: [
          // Simulated Map Canvas
          MapCanvasWidget(
            locations: dummyLocations,
            selectedLocation: _selectedLocation,
            mapOffset: _mapOffset,
            zoom: _zoom,
            onLocationTap: (location) {
              _selectLocationFromSearch(location);
            },
          ),

          // Search Bar at Top
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: _searchLocations,
                        decoration: const InputDecoration(
                          hintText: 'Search address...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchResults = []);
                        },
                        icon: const Icon(Icons.close),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Search Results
          if (_searchResults.isNotEmpty)
            Positioned(
              top: 70,
              left: 12,
              right: 12,
              child: Card(
                elevation: 4,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _searchResults.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: Colors.grey[300]),
                  itemBuilder: (context, index) {
                    final location = _searchResults[index];
                    return ListTile(
                      leading: const Icon(Icons.location_on_outlined),
                      title: Text(location.address),
                      subtitle: Text('${location.city}, ${location.country}'),
                      onTap: () => _selectLocationFromSearch(location),
                    );
                  },
                ),
              ),
            ),

          // Bottom Sheet with Address Details
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Drag handle
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        'Confirm your location',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),

                      // Address field
                      TextField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: 'Street Address',
                          hintText: 'Enter street address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.location_on),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 12),

                      // City and Postal Code Row
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _cityController,
                              decoration: InputDecoration(
                                labelText: 'City',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                prefixIcon: const Icon(Icons.place),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _postalController,
                              decoration: InputDecoration(
                                labelText: 'Postal Code',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                prefixIcon: const Icon(Icons.mail),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Location Info
                      if (_selectedLocation != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selected Location',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Lat: ${_selectedLocation!.latitude.toStringAsFixed(4)}, '
                                'Long: ${_selectedLocation!.longitude.toStringAsFixed(4)}',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 16),

                      // Save button
                      ElevatedButton.icon(
                        onPressed: _saveLocation,
                        icon: const Icon(Icons.check),
                        label: const Text('Save Location'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Random location button
                      OutlinedButton.icon(
                        onPressed: _useRandomLocation,
                        icon: const Icon(Icons.shuffle),
                        label: const Text('Try Another Location'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Map Canvas Widget
class MapCanvasWidget extends StatefulWidget {
  final List<LocationModel> locations;
  final LocationModel? selectedLocation;
  final Offset mapOffset;
  final double zoom;
  final Function(LocationModel) onLocationTap;

  const MapCanvasWidget({
    required this.locations,
    required this.selectedLocation,
    required this.mapOffset,
    required this.zoom,
    required this.onLocationTap,
    super.key,
  });

  @override
  State<MapCanvasWidget> createState() => _MapCanvasWidgetState();
}

class _MapCanvasWidgetState extends State<MapCanvasWidget> {
  late Offset _dragOffset;

  @override
  void initState() {
    super.initState();
    _dragOffset = widget.mapOffset;
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _handlePanUpdate,
      child: Stack(
        children: [
          // Map Background
          CustomPaint(
            painter: MapPainter(
              locations: widget.locations,
              selectedLocation: widget.selectedLocation,
              offset: _dragOffset,
              zoom: widget.zoom,
            ),
            size: Size.infinite,
          ),

          // Center Marker
          Center(
            child: Transform.translate(
              offset: Offset(0, -20),
              child: Icon(
                Icons.location_on,
                size: 48,
                color: Colors.red[400],
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),

          // Location Markers (Tappable)
          ...widget.locations.map((location) {
            final x =
                (location.longitude * 100 - _dragOffset.dx) / widget.zoom +
                MediaQuery.of(context).size.width / 2;
            final y =
                (location.latitude * 100 - _dragOffset.dy) / widget.zoom +
                MediaQuery.of(context).size.height / 2;

            final isVisible =
                x > -50 &&
                x < MediaQuery.of(context).size.width + 50 &&
                y > -50 &&
                y < MediaQuery.of(context).size.height + 150;

            if (!isVisible) return const SizedBox.shrink();

            return Positioned(
              left: x - 20,
              top: y - 40,
              child: GestureDetector(
                onTap: () => widget.onLocationTap(location),
                child: Column(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 40,
                      color: widget.selectedLocation?.id == location.id
                          ? Colors.blue[600]
                          : Colors.blue[300],
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        location.city,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

// Map Painter for Canvas Drawing
class MapPainter extends CustomPainter {
  final List<LocationModel> locations;
  final LocationModel? selectedLocation;
  final Offset offset;
  final double zoom;

  MapPainter({
    required this.locations,
    required this.selectedLocation,
    required this.offset,
    required this.zoom,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Background - light blue like maps
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.blue[50]!,
    );

    // Grid lines for map effect
    final gridPaint = Paint()
      ..color = Colors.blue.withOpacity(0.1)
      ..strokeWidth = 0.5;

    for (int i = 0; i < size.width; i += 50) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height),
        gridPaint,
      );
    }

    for (int i = 0; i < size.height; i += 50) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        gridPaint,
      );
    }

    // Nile River (blue line)
    final rivePaint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..strokeWidth = 8;

    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.5, 0)
        ..quadraticBezierTo(
          size.width * 0.48,
          size.height * 0.5,
          size.width * 0.45,
          size.height,
        ),
      rivePaint,
    );

    // Decorative elements
    final borderPaint = Paint()
      ..color = Colors.blueGrey.withOpacity(0.15)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), borderPaint);
  }

  @override
  bool shouldRepaint(MapPainter oldDelegate) => true;
}
