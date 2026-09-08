import 'package:flutter/material.dart';
import '../../models/listing.dart';
import '../../services/listing_service.dart';
import '../listing/listing_detail_screen.dart';
import 'widgets/listing_card.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final _listingService = ListingService();
  final _searchController = TextEditingController();
  bool _isMapView = false;
  late Future<List<Listing>> _future;

  @override
  void initState() {
    super.initState();
    _future = _listingService.search();
  }

  void _runSearch() {
    setState(() {
      _future = _listingService.search(area: _searchController.text.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keja'),
        actions: [
          IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onSubmitted: (_) => _runSearch(),
              decoration: InputDecoration(
                hintText: 'Search estate, town, road...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(icon: const Icon(Icons.arrow_forward), onPressed: _runSearch),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(value: false, icon: Icon(Icons.list), label: Text('List')),
                      ButtonSegment(value: true, icon: Icon(Icons.map_outlined), label: Text('Map')),
                    ],
                    selected: {_isMapView},
                    onSelectionChanged: (s) => setState(() => _isMapView = s.first),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _isMapView
                  ? const _MapPlaceholder()
                  : FutureBuilder<List<Listing>>(
                      future: _future,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Could not load listings: ${snapshot.error}'));
                        }
                        final listings = snapshot.data ?? [];
                        if (listings.isEmpty) {
                          return const Center(child: Text('No listings match your search yet.'));
                        }
                        return ListView.builder(
                          itemCount: listings.length,
                          itemBuilder: (context, i) => ListingCard(
                            listing: listings[i],
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => ListingDetailScreen(listingId: listings[i].id)),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// Real map view: swap this for a GoogleMap widget (google_maps_flutter is
// already a dependency) plotting `listing.latitude/longitude` as markers,
// once you've added your Maps API key per platform.
class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.grey.shade100),
      alignment: Alignment.center,
      child: const Text('Map view — plot listings with google_maps_flutter here'),
    );
  }
}
