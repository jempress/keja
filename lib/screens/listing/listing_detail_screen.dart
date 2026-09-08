import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../models/listing.dart';
import '../../services/chat_service.dart';
import '../../services/listing_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/verified_badge.dart';
import '../chat/chat_screen.dart';

class ListingDetailScreen extends StatefulWidget {
  final String listingId;
  const ListingDetailScreen({super.key, required this.listingId});

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  late Future<Listing> _future;

  @override
  void initState() {
    super.initState();
    _future = ListingService().getById(widget.listingId);
  }

  Future<void> _contactAgent(Listing listing) async {
    final conversation = await ChatService().startConversation(listing.id);
    if (!mounted) return;
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChatScreen(conversation: conversation)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Listing>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text('Could not load this listing: ${snapshot.error}'));
          }
          final listing = snapshot.data!;
          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
                    const Spacer(),
                    IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
                  ],
                ),
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: listing.photoUrls.isNotEmpty
                            ? PageView(children: listing.photoUrls.map((u) => CachedNetworkImage(imageUrl: u, fit: BoxFit.cover)).toList())
                            : Container(
                                color: AppColors.primary.withOpacity(0.08),
                                child: const Icon(Icons.home_outlined, size: 40, color: AppColors.primary),
                              ),
                      ),
                    ),
                    const Positioned(top: 10, right: 10, child: VerifiedBadge()),
                  ],
                ),
                const SizedBox(height: 14),
                Text(listing.formattedPrice, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.place_outlined, size: 15, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text([listing.area, listing.landmark].where((s) => s != null && s.isNotEmpty).join(', ')),
                ]),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _SpecTile(icon: Icons.bed_outlined, label: '${listing.bedrooms ?? '-'} bed'),
                    const SizedBox(width: 10),
                    _SpecTile(icon: Icons.bathtub_outlined, label: '${listing.bathrooms ?? '-'} bath'),
                  ],
                ),
                const SizedBox(height: 16),
                if (listing.amenities.isNotEmpty) ...[
                  const Text('Amenities', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: listing.amenities.map((a) => Chip(label: Text(a))).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
                if (listing.description != null) ...[
                  const Text('Description', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(listing.description!),
                  const SizedBox(height: 20),
                ],
                ElevatedButton(onPressed: () => _contactAgent(listing), child: const Text('Contact agent')),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SpecTile extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SpecTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
        child: Column(children: [Icon(icon, size: 18, color: AppColors.textSecondary), const SizedBox(height: 4), Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))]),
      ),
    );
  }
}
