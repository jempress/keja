class ChatMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String? body;
  final double? sharedLatitude;
  final double? sharedLongitude;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.body,
    this.sharedLatitude,
    this.sharedLongitude,
    required this.createdAt,
  });

  bool get isLocationShare => sharedLatitude != null;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'],
        conversationId: json['conversation_id'],
        senderId: json['sender_id'],
        body: json['body'],
        sharedLatitude: (json['shared_latitude'] as num?)?.toDouble(),
        sharedLongitude: (json['shared_longitude'] as num?)?.toDouble(),
        createdAt: DateTime.parse(json['created_at']),
      );
}

class Conversation {
  final String id;
  final String listingId;
  final String area;
  final int price;
  final String listingType;
  final DateTime? lastMessageAt;

  Conversation({
    required this.id,
    required this.listingId,
    required this.area,
    required this.price,
    required this.listingType,
    this.lastMessageAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        id: json['id'],
        listingId: json['listing_id'],
        area: json['area'],
        price: json['price'],
        listingType: json['listing_type'],
        lastMessageAt: json['last_message_at'] != null
            ? DateTime.tryParse(json['last_message_at'])
            : null,
      );
}
