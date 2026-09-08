import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../models/conversation.dart';
import '../../services/chat_service.dart';
import '../../theme/app_theme.dart';

class ChatScreen extends StatefulWidget {
  final Conversation conversation;
  const ChatScreen({super.key, required this.conversation});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _chatService = ChatService();
  final _textController = TextEditingController();
  late Future<List<ChatMessage>> _future;
  List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<ChatMessage>> _load() async {
    final messages = await _chatService.messages(widget.conversation.id);
    setState(() => _messages = messages);
    return messages;
  }

  Future<void> _send({String? body, double? lat, double? lng}) async {
    if ((body == null || body.trim().isEmpty) && lat == null) return;
    final message = await _chatService.sendMessage(widget.conversation.id, body: body, lat: lat, lng: lng);
    setState(() => _messages = [..._messages, message]);
    _textController.clear();
  }

  Future<void> _shareLocation() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final requested = await Geolocator.requestPermission();
      if (requested == LocationPermission.denied) return;
    }
    final position = await Geolocator.getCurrentPosition();
    await _send(lat: position.latitude, lng: position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.conversation.area} · Ksh ${widget.conversation.price}')),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<ChatMessage>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && _messages.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, i) => _MessageBubble(message: _messages[i]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.place_outlined), onPressed: _shareLocation),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(hintText: 'Type a message...'),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send), onPressed: () => _send(body: _textController.text)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const _MessageBubble({required this.message});

  // NOTE: mine-vs-theirs styling needs the current user's id (from
  // AuthProvider) compared to message.senderId. Wire that in once the
  // provider is threaded through, or pass currentUserId into this widget.
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12)),
        child: message.isLocationShare
            ? Row(mainAxisSize: MainAxisSize.min, children: const [Icon(Icons.place, size: 14, color: AppColors.primary), SizedBox(width: 6), Text('Shared location')])
            : Text(message.body ?? ''),
      ),
    );
  }
}
