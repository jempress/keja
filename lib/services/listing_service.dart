import '../models/listing.dart';
import 'api_client.dart';

class ListingService {
  final _dio = ApiClient.instance.dio;

  Future<List<Listing>> search({
    String? area,
    int? minPrice,
    int? maxPrice,
    int? bedrooms,
    String? listingType,
  }) async {
    final response = await _dio.get('/listings', queryParameters: {
      if (area != null && area.isNotEmpty) 'area': area,
      if (minPrice != null) 'min_price': minPrice,
      if (maxPrice != null) 'max_price': maxPrice,
      if (bedrooms != null) 'bedrooms': bedrooms,
      if (listingType != null) 'listing_type': listingType,
    });
    return (response.data as List).map((j) => Listing.fromJson(j)).toList();
  }

  Future<Listing> getById(String id) async {
    final response = await _dio.get('/listings/$id');
    return Listing.fromJson(response.data);
  }

  Future<Listing> create({
    required String listingType,
    required int price,
    String? county,
    required String area,
    String? landmark,
    double? latitude,
    double? longitude,
    int? bedrooms,
    int? bathrooms,
    String? description,
  }) async {
    final response = await _dio.post('/listings', data: {
      'listing_type': listingType,
      'price': price,
      'county': county,
      'area': area,
      'landmark': landmark,
      'latitude': latitude,
      'longitude': longitude,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'description': description,
    });
    return Listing.fromJson(response.data);
  }
}
