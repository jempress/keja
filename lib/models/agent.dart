class Agent {
  final String id;
  final String userId;
  final String? businessName;
  final String verificationStatus; // unverified | pending | verified | rejected | revoked
  final String subscriptionTier; // basic | pro | agency
  final DateTime? subscriptionExpiresAt;

  Agent({
    required this.id,
    required this.userId,
    this.businessName,
    required this.verificationStatus,
    required this.subscriptionTier,
    this.subscriptionExpiresAt,
  });

  bool get isVerified => verificationStatus == 'verified';

  factory Agent.fromJson(Map<String, dynamic> json) => Agent(
        id: json['id'],
        userId: json['user_id'],
        businessName: json['business_name'],
        verificationStatus: json['verification_status'],
        subscriptionTier: json['subscription_tier'],
        subscriptionExpiresAt: json['subscription_expires_at'] != null
            ? DateTime.tryParse(json['subscription_expires_at'])
            : null,
      );
}
