class LocationModel {
  final String id;
  final String address;
  final String city;
  final String country;
  final double latitude;
  final double longitude;
  final String postalCode;
  final bool isDefault;

  LocationModel({
    required this.id,
    required this.address,
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.postalCode,
    this.isDefault = false,
  });

  LocationModel copyWith({
    String? id,
    String? address,
    String? city,
    String? country,
    double? latitude,
    double? longitude,
    String? postalCode,
    bool? isDefault,
  }) {
    return LocationModel(
      id: id ?? this.id,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      postalCode: postalCode ?? this.postalCode,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'address': address,
      'city': city,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'postalCode': postalCode,
      'isDefault': isDefault,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id'] ?? '',
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      country: map['country'] ?? '',
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitude'] ?? 0.0,
      postalCode: map['postalCode'] ?? '',
      isDefault: map['isDefault'] ?? false,
    );
  }

  @override
  String toString() {
    return 'LocationModel(id: $id, address: $address, city: $city, '
        'latitude: $latitude, longitude: $longitude)';
  }
}

// Demo locations
List<LocationModel> dummyLocations = [
  LocationModel(
    id: '1',
    address: '123 Main Street, Apartment 4B',
    city: 'Cairo',
    country: 'Egypt',
    latitude: 30.0444,
    longitude: 31.2357,
    postalCode: '11111',
    isDefault: true,
  ),
  LocationModel(
    id: '2',
    address: '456 Nile Avenue',
    city: 'Giza',
    country: 'Egypt',
    latitude: 30.0131,
    longitude: 31.2089,
    postalCode: '12345',
  ),
];
