import '../models/conversation.dart';
import 'api_client.dart';

class ChatService {
  final _dio = ApiClient.instance.dio;

  Future<List<Conversation>> listConversations() async {
    final response = await _dio.get('/conversations');
    return (response.data as List).map((j) => Conversation.fromJson(j)).toList();
  }

  Future<Conversation> startConversation(String listingId) async {
    final response = await _dio.post('/conversations', data: {'listing_id': listingId});
    return Conversation.fromJson(response.data);
  }

  Future<List<ChatMessage>> messages(String conversationId) async {
    final response = await _dio.get('/conversations/$conversationId/messages');
    return (response.data as List).map((j) => ChatMessage.fromJson(j)).toList();
  }

  Future<ChatMessage> sendMessage(String conversationId, {String? body, double? lat, double? lng}) async {
    final response = await _dio.post('/conversations/$conversationId/messages', data: {
      'body': body,
      'shared_latitude': lat,
      'shared_longitude': lng,
    });
    return ChatMessage.fromJson(response.data);
  }
}
