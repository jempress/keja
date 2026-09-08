import 'package:dio/dio.dart';
import 'api_client.dart';

class UploadService {
  final _dio = ApiClient.instance.dio;

  Future<String> uploadSingle(String endpoint, String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    final response = await _dio.post(endpoint, data: formData);
    return response.data['url'] as String;
  }

  Future<String> uploadSelfie(String filePath) => uploadSingle('/uploads/selfie', filePath);
  Future<String> uploadIdDocument(String filePath) => uploadSingle('/uploads/id-document', filePath);
  Future<String> uploadPaymentProof(String filePath) => uploadSingle('/uploads/payment-proof', filePath);

  Future<List<String>> uploadListingPhotos(List<String> filePaths) async {
    final formData = FormData.fromMap({
      'files': await Future.wait(filePaths.map((p) => MultipartFile.fromFile(p))),
    });
    final response = await _dio.post('/uploads/listing-photos', data: formData);
    return (response.data['files'] as List).map((f) => f['url'] as String).toList();
  }
}
