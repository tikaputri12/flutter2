class UserModel {
  final int id;
  final String documentid;
  final String username;
  final String email;
  final String provider;
  final int confirmed;
  final int blocked;
  final DateTime? createdat;
  final DateTime? updatedat;
  final DateTime? publishedat;

  UserModel({
    required this.id,
    required this.documentid,
    required this.username,
    required this.email,
    required this.provider,
    required this.confirmed,
    required this.blocked,
    required this.createdat,
    required this.updatedat,
    required this.publishedat,
  });

  UserModel copyWith({
    int? id,
    String? documentid,
    String? username,
    String? email,
    String? provider,
    int? confirmed,
    int? blocked,
    DateTime? createdat,
    DateTime? updatedat,
    DateTime? publishedat,
  }) {
    return UserModel(
      id: id ?? this.id,
      documentid: documentid ?? this.documentid,
      username: username ?? this.username,
      email: email ?? this.email,
      provider: provider ?? this.provider,
      confirmed: confirmed ?? this.confirmed,
      blocked: blocked ?? this.blocked,
      createdat: createdat ?? this.createdat,
      updatedat: updatedat ?? this.updatedat,
      publishedat: publishedat ?? this.publishedat,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      documentid: json['documentId'],
      username: json['username'],
      email: json['email'],
      provider: json['provider'],
      confirmed: json['confirmed'],
      blocked: json['blocked'],
      createdat: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedat: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      publishedat: json['publishedAt'] != null ? DateTime.parse(json['publishedAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'documentId': documentid,
      'username': username,
      'email': email,
      'provider': provider,
      'confirmed': confirmed,
      'blocked': blocked,
      'createdAt': createdat?.toIso8601String(),
      'updatedAt': updatedat?.toIso8601String(),
      'publishedAt': publishedat?.toIso8601String(),
    };
  }
}
