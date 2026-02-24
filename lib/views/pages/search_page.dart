import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project1/models/product_item_model.dart';
import 'package:project1/utilies/constants.dart';
import 'package:project1/views/pages/product_details_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Plant> _filteredPlants = Plant.plantList;
  String _selectedCategory = 'All';
  RangeValues _priceRange = const RangeValues(0, 100);
  String _sortBy = 'Name';

  final List<String> _categories = [
    'All',
    'Indoor',
    'Outdoor',
    'Garden',
    'Recommended'
  ];

  final List<String> _sortOptions = [
    'Name',
    'Price: Low to High',
    'Price: High to Low',
    'Rating'
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterPlants);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPlants() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      
      _filteredPlants = Plant.plantList.where((plant) {
        // Filter by search query
        bool matchesSearch = plant.plantName.toLowerCase().contains(query) ||
            plant.category.toLowerCase().contains(query) ||
            plant.decription.toLowerCase().contains(query);

        // Filter by category
        bool matchesCategory = _selectedCategory == 'All' ||
            plant.category.toLowerCase() == _selectedCategory.toLowerCase();

        // Filter by price range
        bool matchesPrice = plant.price >= _priceRange.start &&
            plant.price <= _priceRange.end;

        return matchesSearch && matchesCategory && matchesPrice;
      }).toList();

      // Sort results
      _sortPlants();
    });
  }

  void _sortPlants() {
    switch (_sortBy) {
      case 'Name':
        _filteredPlants.sort((a, b) => a.plantName.compareTo(b.plantName));
        break;
      case 'Price: Low to High':
        _filteredPlants.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        _filteredPlants.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Rating':
        _filteredPlants.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedCategory = 'All';
      _priceRange = const RangeValues(0, 100);
      _sortBy = 'Name';
      _filteredPlants = Plant.plantList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Constants.blackColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Search Plants',
          style: TextStyle(
            color: Constants.blackColor,
            fontWeight: FontWeight.w500,
            fontSize: 24,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search plants...',
                prefixIcon: Icon(Icons.search, color: Constants.primaryColor),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Constants.primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      BorderSide(color: Constants.primaryColor, width: 2),
                ),
              ),
            ),
          ),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                // Category Filter
                PopupMenuButton<String>(
                  initialValue: _selectedCategory,
                  child: Chip(
                    label: Text(_selectedCategory),
                    avatar: const Icon(Icons.filter_list, size: 18),
                    backgroundColor: Constants.primaryColor.withOpacity(0.1),
                    labelStyle: TextStyle(color: Constants.primaryColor),
                  ),
                  onSelected: (value) {
                    setState(() {
                      _selectedCategory = value;
                      _filterPlants();
                    });
                  },
                  itemBuilder: (context) => _categories
                      .map((category) => PopupMenuItem<String>(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                ),
                const SizedBox(width: 8),

                // Sort Filter
                PopupMenuButton<String>(
                  initialValue: _sortBy,
                  child: Chip(
                    label: Text(_sortBy),
                    avatar: const Icon(Icons.sort, size: 18),
                    backgroundColor: Constants.primaryColor.withOpacity(0.1),
                    labelStyle: TextStyle(color: Constants.primaryColor),
                  ),
                  onSelected: (value) {
                    setState(() {
                      _sortBy = value;
                      _filterPlants();
                    });
                  },
                  itemBuilder: (context) => _sortOptions
                      .map((option) => PopupMenuItem<String>(
                            value: option,
                            child: Text(option),
                          ))
                      .toList(),
                ),
                const SizedBox(width: 8),

                // Price Range
                GestureDetector(
                  onTap: () => _showPriceRangeDialog(),
                  child: Chip(
                    label: Text(
                        '\$${_priceRange.start.toInt()}-\$${_priceRange.end.toInt()}'),
                    avatar: const Icon(Icons.attach_money, size: 18),
                    backgroundColor: Constants.primaryColor.withOpacity(0.1),
                    labelStyle: TextStyle(color: Constants.primaryColor),
                  ),
                ),
                const SizedBox(width: 8),

                // Reset Button
                ActionChip(
                  label: const Text('Reset'),
                  avatar: const Icon(Icons.refresh, size: 18),
                  onPressed: _resetFilters,
                  backgroundColor: Colors.grey.withOpacity(0.1),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Results Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${_filteredPlants.length} plants found',
                style: TextStyle(
                  color: Constants.blackColor.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Search Results
          Expanded(
            child: _filteredPlants.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Constants.blackColor.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No plants found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Constants.blackColor.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your filters',
                          style: TextStyle(
                            fontSize: 14,
                            color: Constants.blackColor.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredPlants.length,
                    itemBuilder: (context, index) {
                      final plant = _filteredPlants[index];
                      return _buildPlantCard(plant);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlantCard(Plant plant) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            child: ProductDetailsPage(plantId: plant.plantId),
            type: PageTransitionType.bottomToTop,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Constants.primaryColor.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Plant Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Constants.primaryColor.withOpacity(0.1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  plant.imageURL,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Plant Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.plantName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Constants.blackColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    plant.category,
                    style: TextStyle(
                      fontSize: 12,
                      color: Constants.blackColor.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        plant.rating.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Constants.blackColor.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '\$${plant.price}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Constants.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Favorite Icon
            IconButton(
              icon: Icon(
                plant.isFavorated ? Icons.favorite : Icons.favorite_border,
                color: plant.isFavorated ? Colors.red : Constants.blackColor,
              ),
              onPressed: () {
                setState(() {
                  plant.isFavorated = !plant.isFavorated;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPriceRangeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        RangeValues tempRange = _priceRange;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Price Range'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$${tempRange.start.toInt()} - \$${tempRange.end.toInt()}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Constants.primaryColor,
                    ),
                  ),
                  RangeSlider(
                    values: tempRange,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    activeColor: Constants.primaryColor,
                    labels: RangeLabels(
                      '\$${tempRange.start.toInt()}',
                      '\$${tempRange.end.toInt()}',
                    ),
                    onChanged: (values) {
                      setDialogState(() {
                        tempRange = values;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _priceRange = tempRange;
                      _filterPlants();
                    });
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Apply',
                    style: TextStyle(color: Constants.primaryColor),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
