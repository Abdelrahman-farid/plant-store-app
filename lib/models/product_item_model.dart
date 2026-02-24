// Plant model for the Plant Store app

// Product size enum for backward compatibility
enum ProductSize { s, m, l, xl }

extension ProductSizeExtension on ProductSize {
  String get name {
    switch (this) {
      case ProductSize.s:
        return 'S';
      case ProductSize.m:
        return 'M';
      case ProductSize.l:
        return 'L';
      case ProductSize.xl:
        return 'XL';
    }
  }

  static ProductSize fromString(String size) {
    switch (size.toLowerCase()) {
      case 's':
      case 'small':
        return ProductSize.s;
      case 'm':
      case 'medium':
        return ProductSize.m;
      case 'l':
      case 'large':
        return ProductSize.l;
      case 'xl':
      case 'extra large':
        return ProductSize.xl;
      default:
        return ProductSize.m;
    }
  }
}

class Plant {
  final int plantId;
  final int price;
  final String size;
  final double rating;
  final int humidity;
  final String temperature;
  final String category;
  final String plantName;
  final String imageURL;
  bool isFavorated;
  final String decription;
  bool isSelected;

  // Backward compatibility getters for old e-commerce code
  String get id => plantId.toString();
  String get name => plantName;
  String get imgUrl => imageURL;
  String get description => decription;
  double get averageRate => rating;
  bool get isFavorite => isFavorated;

  Plant({
    required this.plantId,
    required this.price,
    required this.category,
    required this.plantName,
    required this.size,
    required this.rating,
    required this.humidity,
    required this.temperature,
    required this.imageURL,
    required this.isFavorated,
    required this.decription,
    required this.isSelected,
  });

  //List of Plants data
  static List<Plant> plantList = [
    Plant(
      plantId: 0,
      price: 22,
      category: 'Indoor',
      plantName: 'Sanseviera',
      size: 'Small',
      rating: 4.5,
      humidity: 34,
      temperature: '23 - 34',
      imageURL: 'assets/images/plant-one.png',
      isFavorated: true,
      decription:
          'This plant is one of the best plant. It grows in most of the regions in the world and can survive even the harshest weather condition.',
      isSelected: false,
    ),
    Plant(
      plantId: 1,
      price: 11,
      category: 'Outdoor',
      plantName: 'Philodendron',
      size: 'Medium',
      rating: 4.8,
      humidity: 56,
      temperature: '19 - 22',
      imageURL: 'assets/images/plant-two.png',
      isFavorated: false,
      decription:
          'This plant is one of the best plant. It grows in most of the regions in the world and can survive even the harshest weather condition.',
      isSelected: false,
    ),
    Plant(
      plantId: 2,
      price: 18,
      category: 'Indoor',
      plantName: 'Beach Daisy',
      size: 'Large',
      rating: 4.7,
      humidity: 34,
      temperature: '22 - 25',
      imageURL: 'assets/images/plant-three.png',
      isFavorated: false,
      decription:
          'This plant is one of the best plant. It grows in most of the regions in the world and can survive even the harshest weather condition.',
      isSelected: false,
    ),
    Plant(
      plantId: 3,
      price: 30,
      category: 'Outdoor',
      plantName: 'Big Bluestem',
      size: 'Small',
      rating: 4.5,
      humidity: 35,
      temperature: '23 - 28',
      imageURL: 'assets/images/plant-one.png',
      isFavorated: false,
      decription:
          'This plant is one of the best plant. It grows in most of the regions in the world and can survive even the harshest weather condition.',
      isSelected: false,
    ),
    Plant(
      plantId: 4,
      price: 24,
      category: 'Recommended',
      plantName: 'Big Bluestem',
      size: 'Large',
      rating: 4.1,
      humidity: 66,
      temperature: '12 - 16',
      imageURL: 'assets/images/plant-four.png',
      isFavorated: true,
      decription:
          'This plant is one of the best plant. It grows in most of the regions in the world and can survive even the harshest weather condition.',
      isSelected: false,
    ),
    Plant(
      plantId: 5,
      price: 24,
      category: 'Outdoor',
      plantName: 'Meadow Sage',
      size: 'Medium',
      rating: 4.4,
      humidity: 36,
      temperature: '15 - 18',
      imageURL: 'assets/images/plant-five.png',
      isFavorated: false,
      decription:
          'This plant is one of the best plant. It grows in most of the regions in the world and can survive even the harshest weather condition.',
      isSelected: false,
    ),
    Plant(
      plantId: 6,
      price: 19,
      category: 'Garden',
      plantName: 'Plumbago',
      size: 'Small',
      rating: 4.2,
      humidity: 46,
      temperature: '23 - 26',
      imageURL: 'assets/images/plant-six.png',
      isFavorated: false,
      decription:
          'This plant is one of the best plant. It grows in most of the regions in the world and can survive even the harshest weather condition.',
      isSelected: false,
    ),
    Plant(
      plantId: 7,
      price: 23,
      category: 'Garden',
      plantName: 'Tritonia',
      size: 'Medium',
      rating: 4.5,
      humidity: 34,
      temperature: '21 - 24',
      imageURL: 'assets/images/plant-seven.png',
      isFavorated: false,
      decription:
          'This plant is one of the best plant. It grows in most of the regions in the world and can survive even the harshest weather condition.',
      isSelected: false,
    ),
    Plant(
      plantId: 8,
      price: 46,
      category: 'Recommended',
      plantName: 'Tritonia',
      size: 'Medium',
      rating: 4.7,
      humidity: 46,
      temperature: '21 - 25',
      imageURL: 'assets/images/plant-eight.png',
      isFavorated: false,
      decription:
          'This plant is one of the best plant. It grows in most of the regions in the world and can survive even the harshest weather condition.',
      isSelected: false,
    ),
  ];

  //Get the favorated items
  static List<Plant> getFavoritedPlants() {
   List<Plant> _travelList = Plant.plantList;
    return _travelList.where((element) => element.isFavorated == true).toList();
  }

  //Get the cart items
  static List<Plant> addedToCartPlants() {
    List<Plant> _selectedPlants = Plant.plantList;
    return _selectedPlants.where((element) => element.isSelected == true).toList();
  }

  // Backward compatibility methods for old e-commerce code
  Map<String, dynamic> toMap() {
    return {
      'plantId': plantId,
      'price': price,
      'size': size,
      'rating': rating,
      'humidity': humidity,
      'temperature': temperature,
      'category': category,
      'plantName': plantName,
      'imageURL': imageURL,
      'isFavorated': isFavorated,
      'decription': decription,
      'isSelected': isSelected,
    };
  }

  static Plant fromMap(Map<String, dynamic> map) {
    return Plant(
      plantId: map['plantId'] ?? 0,
      price: map['price'] ?? 0,
      size: map['size'] ?? 'Medium',
      rating: map['rating']?.toDouble() ?? 0.0,
      humidity: map['humidity'] ?? 0,
      temperature: map['temperature'] ?? '0',
      category: map['category'] ?? '',
      plantName: map['plantName'] ?? '',
      imageURL: map['imageURL'] ?? '',
      isFavorated: map['isFavorated'] ?? false,
      decription: map['decription'] ?? '',
      isSelected: map['isSelected'] ?? false,
    );
  }

  Plant copyWith({
    int? plantId,
    int? price,
    String? size,
    double? rating,
    int? humidity,
    String? temperature,
    String? category,
    String? plantName,
    String? imageURL,
    bool? isFavorated,
    String? decription,
    bool? isSelected,
    bool? isFavorite,
  }) {
    return Plant(
      plantId: plantId ?? this.plantId,
      price: price ?? this.price,
      size: size ?? this.size,
      rating: rating ?? this.rating,
      humidity: humidity ?? this.humidity,
      temperature: temperature ?? this.temperature,
      category: category ?? this.category,
      plantName: plantName ?? this.plantName,
      imageURL: imageURL ?? this.imageURL,
      isFavorated: isFavorite ?? isFavorated ?? this.isFavorated,
      decription: decription ?? this.decription,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

// Keep old model as alias for compatibility (to be removed after full refactor)
typedef ProductItemModel = Plant;