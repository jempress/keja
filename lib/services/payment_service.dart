import 'api_client.dart';

class PaymentService {
  final _dio = ApiClient.instance.dio;

  /// Kicks off an STK push; the phone gets a PIN prompt. Poll or use a
  /// websocket/notification in a real app to learn when the backend's
  /// M-Pesa callback marks the payment complete.
  Future<String> payWithMpesa({required String tier, required String phone}) async {
    final response = await _dio.post('/payments/mpesa/stk-push', data: {
      'tier': tier,
      'phone': phone,
    });
    return response.data['checkout_request_id'] as String;
  }

  Future<void> submitBankTransferProof({
    required String tier,
    required String bankReference,
    required String proofUrl,
  }) async {
    await _dio.post('/payments/bank-transfer/proof', data: {
      'tier': tier,
      'bank_reference': bankReference,
      'proof_url': proofUrl,
    });
  }
}
