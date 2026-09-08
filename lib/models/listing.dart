class Listing {
  final String id;
  final String agentId;
  final String listingType; // rent | sale
  final int price;
  final String? county;
  final String area;
  final String? landmark;
  final double? latitude;
  final double? longitude;
  final int? bedrooms;
  final int? bathrooms;
  final String? description;
  final String status;
  final bool featured;
  final List<String> photoUrls;
  final List<String> amenities;

  Listing({
    required this.id,
    required this.agentId,
    required this.listingType,
    required this.price,
    this.county,
    required this.area,
    this.landmark,
    this.latitude,
    this.longitude,
    this.bedrooms,
    this.bathrooms,
    this.description,
    required this.status,
    required this.featured,
    this.photoUrls = const [],
    this.amenities = const [],
  });

  factory Listing.fromJson(Map<String, dynamic> json) => Listing(
        id: json['id'],
        agentId: json['agent_id'],
        listingType: json['listing_type'],
        price: json['price'],
        county: json['county'],
        area: json['area'],
        landmark: json['landmark'],
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        bedrooms: json['bedrooms'],
        bathrooms: json['bathrooms'],
        description: json['description'],
        status: json['status'],
        featured: json['featured'] ?? false,
        photoUrls: (json['photos'] as List<dynamic>? ?? [])
            .map((p) => p['url'] as String)
            .toList(),
        amenities: (json['amenities'] as List<dynamic>? ?? []).cast<String>(),
      );

  String get formattedPrice {
    final suffix = listingType == 'rent' ? '/mo' : '';
    return 'Ksh ${price.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        )}$suffix';
  }
}
