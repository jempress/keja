import '../models/agent.dart';
import 'api_client.dart';

class AgentService {
  final _dio = ApiClient.instance.dio;

  Future<Agent> me() async {
    final response = await _dio.get('/agents/me');
    return Agent.fromJson(response.data);
  }

  Future<Agent> submitVerification({
    required String idNumber,
    required String idDocumentUrl,
    required String selfieUrl,
    String? businessName,
    String? kraPin,
  }) async {
    final response = await _dio.post('/agents/verification', data: {
      'id_number': idNumber,
      'id_document_url': idDocumentUrl,
      'selfie_url': selfieUrl,
      'business_name': businessName,
      'kra_pin': kraPin,
    });
    return Agent.fromJson(response.data);
  }
}
