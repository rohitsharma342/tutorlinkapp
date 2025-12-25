class AppConstants {
  static const String appName = 'TutorLink';
  static const String tagline = 'Made With BrainBox';
  static const String primaryColorHex = '#0768FF';
  
  // API URLs (for future implementation)
  static const String baseUrl = 'https://api.tutorlink.com';
  static const String authEndpoint = '/auth';
  static const String tutorsEndpoint = '/tutors';
  static const String chatEndpoint = '/chat';
  
  // Shared Preferences Keys
  static const String currentUserIdKey = 'current_user_id';
  static const String languageCodeKey = 'language_code';
  static const String countryCodeKey = 'country_code';
  
  // File Upload Constraints
  static const int maxProfilePhotoSize = 5 * 1024 * 1024; // 5MB
  static const int maxIntroVideoSize = 50 * 1024 * 1024; // 50MB
  static const int maxDocumentSize = 10 * 1024 * 1024; // 10MB
  
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png'];
  static const List<String> allowedVideoTypes = ['mp4', 'mov', 'avi'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx'];
  
  // App Settings
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration autoLogoutDuration = Duration(hours: 24);
  static const int maxSearchResults = 50;
  static const double minHourlyRate = 50.0;
  static const double maxHourlyRate = 500.0;
  
  // Rating Constraints
  static const double minRating = 1.0;
  static const double maxRating = 5.0;
  static const int minRatingComment = 10;
  static const int maxRatingComment = 500;
  
  // Chat Settings
  static const int maxMessageLength = 1000;
  static const int maxAttachmentSize = 10 * 1024 * 1024; // 10MB
  
  // Subscription Settings
  static const List<String> subscriptionPlans = [
    'basic_monthly',
    'premium_monthly',
    'basic_yearly',
    'premium_yearly'
  ];
  
  // Error Messages
  static const String genericErrorMessage = 'Something went wrong. Please try again.';
  static const String networkErrorMessage = 'Please check your internet connection.';
  static const String timeoutErrorMessage = 'Request timeout. Please try again.';
  static const String unauthorizedErrorMessage = 'Session expired. Please login again.';
  
  // Success Messages
  static const String profileUpdatedMessage = 'Profile updated successfully';
  static const String messageSentMessage = 'Message sent successfully';
  static const String ratingSubmittedMessage = 'Rating submitted successfully';
  static const String complaintSubmittedMessage = 'Complaint submitted successfully';
}