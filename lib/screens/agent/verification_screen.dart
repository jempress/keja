import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/agent_service.dart';
import '../../services/upload_service.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _idNumberController = TextEditingController();
  final _businessNameController = TextEditingController();
  XFile? _idPhoto;
  XFile? _selfie;
  bool _isSubmitting = false;
  String? _error;

  Future<void> _pick(void Function(XFile) onPicked, {required bool useCamera}) async {
    final file = await ImagePicker().pickImage(source: useCamera ? ImageSource.camera : ImageSource.gallery);
    if (file != null) onPicked(file);
  }

  Future<void> _submit() async {
    if (_idPhoto == null || _selfie == null || _idNumberController.text.trim().isEmpty) {
      setState(() => _error = 'ID number, ID photo, and selfie are all required');
      return;
    }
    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    try {
      final uploadService = UploadService();
      // Each upload goes through the backend's type-checked /uploads
      // endpoints (magic-byte sniffing, re-encoding) before we ever
      // reference the resulting URL here.
      final idUrl = await uploadService.uploadIdDocument(_idPhoto!.path);
      final selfieUrl = await uploadService.uploadSelfie(_selfie!.path);

      await AgentService().submitVerification(
        idNumber: _idNumberController.text.trim(),
        idDocumentUrl: idUrl,
        selfieUrl: selfieUrl,
        businessName: _businessNameController.text.trim().isEmpty ? null : _businessNameController.text.trim(),
      );

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      setState(() => _error = 'Submission failed. Please try again.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify your account')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('We verify agents to keep renters safe from scam listings. This usually takes a few hours.'),
          const SizedBox(height: 16),
          TextField(controller: _idNumberController, decoration: const InputDecoration(labelText: 'National ID number')),
          const SizedBox(height: 12),
          TextField(controller: _businessNameController, decoration: const InputDecoration(labelText: 'Business name (optional)')),
          const SizedBox(height: 16),
          _UploadTile(
            label: 'National ID photo',
            file: _idPhoto,
            onTap: () => _pick((f) => setState(() => _idPhoto = f), useCamera: false),
          ),
          const SizedBox(height: 12),
          _UploadTile(
            label: 'Selfie holding your ID',
            file: _selfie,
            onTap: () => _pick((f) => setState(() => _selfie = f), useCamera: true),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
          ],
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isSubmitting ? null : _submit,
            child: _isSubmitting
                ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Submit for verification'),
          ),
        ],
      ),
    );
  }
}

class _UploadTile extends StatelessWidget {
  final String label;
  final XFile? file;
  final VoidCallback onTap;
  const _UploadTile({required this.label, required this.file, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Icon(file != null ? Icons.check_circle : Icons.upload_outlined, color: file != null ? Colors.green : Colors.grey),
            const SizedBox(width: 10),
            Text(file != null ? '$label — selected' : label),
          ],
        ),
      ),
    );
  }
}
