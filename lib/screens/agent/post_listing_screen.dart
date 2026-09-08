import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/listing_service.dart';
import '../../services/upload_service.dart';
import '../../theme/app_theme.dart';

class PostListingScreen extends StatefulWidget {
  const PostListingScreen({super.key});

  @override
  State<PostListingScreen> createState() => _PostListingScreenState();
}

class _PostListingScreenState extends State<PostListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _areaController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _bedroomsController = TextEditingController();
  final _bathroomsController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _listingType = 'rent';
  final List<XFile> _pickedPhotos = [];
  bool _isSubmitting = false;
  String? _error;

  Future<void> _pickPhotos() async {
    final images = await ImagePicker().pickMultiImage(limit: 10);
    setState(() => _pickedPhotos.addAll(images));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    try {
      // Photos are uploaded first (through the type-checked /uploads
      // endpoint) so the listing is created with real URLs, not local
      // file paths. If you want to attach photo URLs to the listing
      // itself, extend POST /listings on the backend to accept them.
      if (_pickedPhotos.isNotEmpty) {
        await UploadService().uploadListingPhotos(_pickedPhotos.map((f) => f.path).toList());
      }

      await ListingService().create(
        listingType: _listingType,
        price: int.parse(_priceController.text),
        area: _areaController.text.trim(),
        landmark: _landmarkController.text.trim(),
        bedrooms: int.tryParse(_bedroomsController.text),
        bathrooms: int.tryParse(_bathroomsController.text),
        description: _descriptionController.text.trim(),
      );

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      setState(() => _error = 'Could not submit listing. Please try again.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New listing')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Photos', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._pickedPhotos.map((f) => ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(width: 72, height: 72, child: Image.file(File(f.path), fit: BoxFit.cover)),
                    )),
                InkWell(
                  onTap: _pickPhotos,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
                    child: const Icon(Icons.add_a_photo_outlined, color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SegmentedButton<String>(
              segments: const [ButtonSegment(value: 'rent', label: Text('To rent')), ButtonSegment(value: 'sale', label: Text('For sale'))],
              selected: {_listingType},
              onSelectionChanged: (s) => setState(() => _listingType = s.first),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Price (Ksh)'),
              validator: (v) => (v == null || int.tryParse(v) == null) ? 'Enter a valid price' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _areaController,
              decoration: const InputDecoration(labelText: 'Area / estate'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(controller: _landmarkController, decoration: const InputDecoration(labelText: 'Landmark (optional)')),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: TextFormField(controller: _bedroomsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Bedrooms'))),
              const SizedBox(width: 10),
              Expanded(child: TextFormField(controller: _bathroomsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Bathrooms'))),
            ]),
            const SizedBox(height: 12),
            TextFormField(controller: _descriptionController, maxLines: 4, decoration: const InputDecoration(labelText: 'Description')),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
              child: const Text('New listings are reviewed before going live, usually within a few hours.', style: TextStyle(fontSize: 12, color: AppColors.primary)),
            ),
            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Submit for review'),
            ),
          ],
        ),
      ),
    );
  }
}
