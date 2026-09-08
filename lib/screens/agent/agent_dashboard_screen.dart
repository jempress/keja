import 'package:flutter/material.dart';
import '../../models/agent.dart';
import '../../services/agent_service.dart';
import '../../theme/app_theme.dart';
import 'post_listing_screen.dart';
import 'subscription_screen.dart';
import 'verification_screen.dart';

class AgentDashboardScreen extends StatefulWidget {
  const AgentDashboardScreen({super.key});

  @override
  State<AgentDashboardScreen> createState() => _AgentDashboardScreenState();
}

class _AgentDashboardScreenState extends State<AgentDashboardScreen> {
  late Future<Agent> _future;

  @override
  void initState() {
    super.initState();
    _future = AgentService().me();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your agent profile')),
      body: FutureBuilder<Agent>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Center(child: Text('Could not load your profile: ${snapshot.error}'));
          }
          final agent = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_statusLabel(agent.verificationStatus), style: TextStyle(color: _statusColor(agent.verificationStatus), fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text('Plan: ${agent.subscriptionTier}'),
                          ],
                        ),
                      ),
                      if (agent.verificationStatus != 'verified')
                        TextButton(
                          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const VerificationScreen())),
                          child: const Text('Verify now'),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Post a new listing'),
                onPressed: agent.isVerified
                    ? () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PostListingScreen()))
                    : null,
              ),
              if (!agent.isVerified) const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text('You need to be verified before you can post listings.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                icon: const Icon(Icons.workspace_premium_outlined),
                label: const Text('Manage subscription'),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SubscriptionScreen())),
              ),
            ],
          );
        },
      ),
    );
  }

  String _statusLabel(String status) => switch (status) {
        'verified' => 'Verified agent',
        'pending' => 'Verification pending review',
        'rejected' => 'Verification rejected — resubmit',
        'revoked' => 'Verification revoked',
        _ => 'Not verified yet',
      };

  Color _statusColor(String status) => switch (status) {
        'verified' => AppColors.success,
        'pending' => AppColors.accent,
        'rejected' || 'revoked' => AppColors.danger,
        _ => AppColors.textSecondary,
      };
}
