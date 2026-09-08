import '../models/listing.dart';
import 'api_client.dart';

class FavoriteService {
  final _dio = ApiClient.instance.dio;

  Future<List<Listing>> list() async {
    final response = await _dio.get('/favorites');
    return (response.data as List).map((j) => Listing.fromJson(j)).toList();
  }

  Future<void> save(String listingId) => _dio.post('/favorites/$listingId');
  Future<void> remove(String listingId) => _dio.delete('/favorites/$listingId');
}
