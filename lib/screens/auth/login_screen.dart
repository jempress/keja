import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  String _role = 'renter';
  bool _isSubmitting = false;
  String? _error;

  Future<void> _submit() async {
    final phone = _phoneController.text.trim();
    if (!RegExp(r'^254[17]\d{8}$').hasMatch(phone)) {
      setState(() => _error = 'Enter a valid number like 2547XXXXXXXX');
      return;
    }
    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    try {
      await context.read<AuthProvider>().requestOtp(phone);
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => OtpScreen(phone: phone, role: _role)),
      );
    } catch (e) {
      setState(() => _error = 'Could not send code. Check your connection and try again.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Keja', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              const Text('Find a verified home, or list yours.'),
              const SizedBox(height: 32),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(hintText: '2547XXXXXXXX', prefixIcon: Icon(Icons.phone_outlined)),
              ),
              const SizedBox(height: 12),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'renter', label: Text('I am looking for a house')),
                  ButtonSegment(value: 'agent', label: Text('I am an agent/landlord')),
                ],
                selected: {_role},
                onSelectionChanged: (s) => setState(() => _role = s.first),
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
                    : const Text('Send code'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
