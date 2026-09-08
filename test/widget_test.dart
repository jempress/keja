import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keja_app/models/listing.dart';

void main() {
  test('Listing.formattedPrice formats rent with thousands separator', () {
    final listing = Listing(
      id: '1',
      agentId: 'a1',
      listingType: 'rent',
      price: 18000,
      area: 'Kasarani',
      status: 'active',
      featured: false,
    );
    expect(listing.formattedPrice, 'Ksh 18,000/mo');
  });

  test('Listing.formattedPrice omits /mo for sale listings', () {
    final listing = Listing(
      id: '2',
      agentId: 'a1',
      listingType: 'sale',
      price: 4500000,
      area: 'Kilimani',
      status: 'active',
      featured: false,
    );
    expect(listing.formattedPrice, 'Ksh 4,500,000');
  });

  testWidgets('App theme builds without throwing', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: const Scaffold(body: Text('Keja')),
      ),
    );
    expect(find.text('Keja'), findsOneWidget);
  });
}
