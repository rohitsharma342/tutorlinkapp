enum UserRole { student, tutor }

class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final UserRole role;
  final String? profilePhoto;
  final bool isApproved;
  final bool hasActiveSubscription;
  final List<String> favoritesTutorIds;
  final List<String> blockedUserIds;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.profilePhoto,
    this.isApproved = false,
    this.hasActiveSubscription = false,
    this.favoritesTutorIds = const [],
    this.blockedUserIds = const [],
  });

  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    UserRole? role,
    String? profilePhoto,
    bool? isApproved,
    bool? hasActiveSubscription,
    List<String>? favoritesTutorIds,
    List<String>? blockedUserIds,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      isApproved: isApproved ?? this.isApproved,
      hasActiveSubscription: hasActiveSubscription ?? this.hasActiveSubscription,
      favoritesTutorIds: favoritesTutorIds ?? this.favoritesTutorIds,
      blockedUserIds: blockedUserIds ?? this.blockedUserIds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role.toString(),
      'profilePhoto': profilePhoto,
      'isApproved': isApproved,
      'hasActiveSubscription': hasActiveSubscription,
      'favoritesTutorIds': favoritesTutorIds,
      'blockedUserIds': blockedUserIds,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      role: UserRole.values.firstWhere(
        (e) => e.toString() == json['role'],
      ),
      profilePhoto: json['profilePhoto'],
      isApproved: json['isApproved'] ?? false,
      hasActiveSubscription: json['hasActiveSubscription'] ?? false,
      favoritesTutorIds: List<String>.from(json['favoritesTutorIds'] ?? []),
      blockedUserIds: List<String>.from(json['blockedUserIds'] ?? []),
    );
  }
}