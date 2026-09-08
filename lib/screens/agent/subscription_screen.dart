import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/payment_service.dart';
import '../../services/upload_service.dart';
import '../../theme/app_theme.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String _tier = 'pro';
  String _method = 'mpesa';
  final _phoneController = TextEditingController();
  final _bankRefController = TextEditingController();
  XFile? _proofFile;
  bool _isSubmitting = false;
  String? _status;

  static const _tierPrices = {'pro': 1500, 'agency': 5000};

  Future<void> _payMpesa() async {
    setState(() {
      _isSubmitting = true;
      _status = null;
    });
    try {
      await PaymentService().payWithMpesa(tier: _tier, phone: _phoneController.text.trim());
      setState(() => _status = 'Check your phone to enter your M-Pesa PIN.');
    } catch (e) {
      setState(() => _status = 'Could not start the M-Pesa payment. Try again.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _pickProof() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => _proofFile = file);
  }

  Future<void> _submitBankProof() async {
    if (_proofFile == null || _bankRefController.text.trim().isEmpty) {
      setState(() => _status = 'Add the reference and a screenshot of the transfer.');
      return;
    }
    setState(() {
      _isSubmitting = true;
      _status = null;
    });
    try {
      final proofUrl = await UploadService().uploadPaymentProof(_proofFile!.path);
      await PaymentService().submitBankTransferProof(
        tier: _tier,
        bankReference: _bankRefController.text.trim(),
        proofUrl: proofUrl,
      );
      setState(() => _status = 'Submitted — we\'ll confirm once it matches our bank statement.');
    } catch (e) {
      setState(() => _status = 'Could not submit proof. Try again.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final amount = _tierPrices[_tier]!;
    return Scaffold(
      appBar: AppBar(title: const Text('Subscription')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentedButton<String>(
            segments: const [ButtonSegment(value: 'pro', label: Text('Pro — Ksh 1,500')), ButtonSegment(value: 'agency', label: Text('Agency — Ksh 5,000'))],
            selected: {_tier},
            onSelectionChanged: (s) => setState(() => _tier = s.first),
          ),
          const SizedBox(height: 16),
          const Text('Payment method', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [ButtonSegment(value: 'mpesa', icon: Icon(Icons.phone_android), label: Text('M-Pesa')), ButtonSegment(value: 'bank_transfer', icon: Icon(Icons.account_balance_outlined), label: Text('Bank transfer'))],
            selected: {_method},
            onSelectionChanged: (s) => setState(() => _method = s.first),
          ),
          const SizedBox(height: 16),
          if (_method == 'mpesa') ...[
            TextField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'M-Pesa phone (2547XXXXXXXX)')),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              icon: const Icon(Icons.phone_android),
              label: Text(_isSubmitting ? 'Starting...' : 'Pay Ksh $amount via M-Pesa'),
              onPressed: _isSubmitting ? null : _payMpesa,
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(10)),
              child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Bank: Equity Bank'),
                Text('Account name: Keja Ltd'),
                Text('Account no.: 0123456789'),
              ]),
            ),
            const SizedBox(height: 12),
            TextField(controller: _bankRefController, decoration: const InputDecoration(labelText: 'Transfer reference')),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              icon: const Icon(Icons.upload_outlined),
              label: Text(_proofFile == null ? 'Upload payment proof' : 'Proof selected'),
              onPressed: _pickProof,
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitBankProof,
              child: Text(_isSubmitting ? 'Submitting...' : 'Submit proof for review'),
            ),
          ],
          if (_status != null) ...[
            const SizedBox(height: 14),
            Text(_status!, style: const TextStyle(fontSize: 13)),
          ],
        ],
      ),
    );
  }
}
