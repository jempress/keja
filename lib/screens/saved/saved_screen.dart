import 'package:flutter/material.dart';
import '../../models/listing.dart';
import '../../services/favorite_service.dart';
import '../browse/widgets/listing_card.dart';
import '../listing/listing_detail_screen.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  late Future<List<Listing>> _future;

  @override
  void initState() {
    super.initState();
    _future = FavoriteService().list();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FutureBuilder<List<Listing>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final saved = snapshot.data ?? [];
            if (saved.isEmpty) {
              return const Center(child: Text('Nothing saved yet — tap the heart on a listing to save it here.'));
            }
            return ListView.builder(
              itemCount: saved.length,
              itemBuilder: (context, i) => ListingCard(
                listing: saved[i],
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ListingDetailScreen(listingId: saved[i].id)),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
