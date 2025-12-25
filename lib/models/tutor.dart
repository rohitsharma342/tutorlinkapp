enum TeachingType { inPerson, online, both }
enum Gender { male, female }

class Tutor {
  final String id;
  final String firstName;
  final String lastName;
  final Gender gender;
  final String? profilePhoto;
  final String? introVideo;
  final String bio;
  final List<String> subjects;
  final List<String> grades;
  final TeachingType teachingType;
  final String area;
  final double hourlyRate;
  final int experienceYears;
  final double averageRating;
  final int totalRatings;
  final bool isVerified;
  final bool hasActiveSubscription;
  final int profileViews;
  final List<String> interestedStudents;

  Tutor({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    this.profilePhoto,
    this.introVideo,
    required this.bio,
    required this.subjects,
    required this.grades,
    required this.teachingType,
    required this.area,
    required this.hourlyRate,
    required this.experienceYears,
    this.averageRating = 0.0,
    this.totalRatings = 0,
    this.isVerified = false,
    this.hasActiveSubscription = false,
    this.profileViews = 0,
    this.interestedStudents = const [],
  });

  String get fullName => '$firstName $lastName';

  String get teachingTypeText {
    switch (teachingType) {
      case TeachingType.inPerson:
        return 'In Person';
      case TeachingType.online:
        return 'Online';
      case TeachingType.both:
        return 'Both';
    }
  }

  String get genderText {
    switch (gender) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
    }
  }

  Tutor copyWith({
    String? id,
    String? firstName,
    String? lastName,
    Gender? gender,
    String? profilePhoto,
    String? introVideo,
    String? bio,
    List<String>? subjects,
    List<String>? grades,
    TeachingType? teachingType,
    String? area,
    double? hourlyRate,
    int? experienceYears,
    double? averageRating,
    int? totalRatings,
    bool? isVerified,
    bool? hasActiveSubscription,
    int? profileViews,
    List<String>? interestedStudents,
  }) {
    return Tutor(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      introVideo: introVideo ?? this.introVideo,
      bio: bio ?? this.bio,
      subjects: subjects ?? this.subjects,
      grades: grades ?? this.grades,
      teachingType: teachingType ?? this.teachingType,
      area: area ?? this.area,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      experienceYears: experienceYears ?? this.experienceYears,
      averageRating: averageRating ?? this.averageRating,
      totalRatings: totalRatings ?? this.totalRatings,
      isVerified: isVerified ?? this.isVerified,
      hasActiveSubscription: hasActiveSubscription ?? this.hasActiveSubscription,
      profileViews: profileViews ?? this.profileViews,
      interestedStudents: interestedStudents ?? this.interestedStudents,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender.toString(),
      'profilePhoto': profilePhoto,
      'introVideo': introVideo,
      'bio': bio,
      'subjects': subjects,
      'grades': grades,
      'teachingType': teachingType.toString(),
      'area': area,
      'hourlyRate': hourlyRate,
      'experienceYears': experienceYears,
      'averageRating': averageRating,
      'totalRatings': totalRatings,
      'isVerified': isVerified,
      'hasActiveSubscription': hasActiveSubscription,
      'profileViews': profileViews,
      'interestedStudents': interestedStudents,
    };
  }

  factory Tutor.fromJson(Map<String, dynamic> json) {
    return Tutor(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      gender: Gender.values.firstWhere(
        (e) => e.toString() == json['gender'],
      ),
      profilePhoto: json['profilePhoto'],
      introVideo: json['introVideo'],
      bio: json['bio'],
      subjects: List<String>.from(json['subjects']),
      grades: List<String>.from(json['grades']),
      teachingType: TeachingType.values.firstWhere(
        (e) => e.toString() == json['teachingType'],
      ),
      area: json['area'],
      hourlyRate: json['hourlyRate'].toDouble(),
      experienceYears: json['experienceYears'],
      averageRating: json['averageRating'].toDouble(),
      totalRatings: json['totalRatings'],
      isVerified: json['isVerified'],
      hasActiveSubscription: json['hasActiveSubscription'],
      profileViews: json['profileViews'],
      interestedStudents: List<String>.from(json['interestedStudents'] ?? []),
    );
  }
}