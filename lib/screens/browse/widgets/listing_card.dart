import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../models/listing.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/verified_badge.dart';

class ListingCard extends StatelessWidget {
  final Listing listing;
  final VoidCallback onTap;

  const ListingCard({super.key, required this.listing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: listing.photoUrls.isNotEmpty
                      ? CachedNetworkImage(imageUrl: listing.photoUrls.first, fit: BoxFit.cover)
                      : Container(
                          color: AppColors.primary.withOpacity(0.08),
                          child: const Icon(Icons.home_outlined, size: 32, color: AppColors.primary),
                        ),
                ),
                const Positioned(top: 10, right: 10, child: VerifiedBadge()),
                if (listing.featured) const Positioned(bottom: 8, left: 8, child: FeaturedTag()),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(listing.formattedPrice, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.place_outlined, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          [listing.area, listing.landmark].where((s) => s != null && s.isNotEmpty).join(', '),
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (listing.bedrooms != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.bed_outlined, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text('${listing.bedrooms} bed', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        const SizedBox(width: 12),
                        const Icon(Icons.bathtub_outlined, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text('${listing.bathrooms ?? '-'} bath', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
