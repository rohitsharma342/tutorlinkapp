import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  final Rx<Locale> _currentLocale = Locale('en', 'US').obs;
  final RxBool isRTL = false.obs;

  Locale get currentLocale => _currentLocale.value;
  bool get isArabic => _currentLocale.value.languageCode == 'ar';

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString('language_code') ?? 'en';
      final countryCode = prefs.getString('country_code') ?? 'US';
      
      _currentLocale.value = Locale(languageCode, countryCode);
      isRTL.value = languageCode == 'ar';
      
      Get.updateLocale(_currentLocale.value);
    } catch (e) {
      print('Error loading saved language: $e');
    }
  }

  Future<void> changeLanguage(String languageCode, String countryCode) async {
    try {
      final newLocale = Locale(languageCode, countryCode);
      _currentLocale.value = newLocale;
      isRTL.value = languageCode == 'ar';
      
      Get.updateLocale(newLocale);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', languageCode);
      await prefs.setString('country_code', countryCode);
    } catch (e) {
      print('Error changing language: $e');
    }
  }

  void toggleLanguage() {
    if (isArabic) {
      changeLanguage('en', 'US');
    } else {
      changeLanguage('ar', 'SA');
    }
  }

  String translate(String key) {
    return Get.find<LanguageController>().isArabic 
        ? _getArabicTranslation(key)
        : _getEnglishTranslation(key);
  }

  String _getEnglishTranslation(String key) {
    final translations = {
      'app_name': 'TutorLink',
      'tagline': 'Made With BrainBox',
      'email': 'Email',
      'password': 'Password',
      'login': 'Login',
      'signup': 'Sign Up',
      'student': 'Student',
      'tutor': 'Tutor',
      'dashboard': 'Dashboard',
      'profile': 'Profile',
      'chat': 'Chat',
      'settings': 'Settings',
      'search': 'Search tutors...',
      'subjects': 'Subjects',
      'grades': 'Grades',
      'area': 'Area',
      'teaching_type': 'Teaching Type',
      'gender': 'Gender',
      'price_range': 'Price Range',
      'my_content': 'My Content',
      'discover_tutors': 'Discover Tutors',
      'favorites': 'Favorites',
      'messages': 'Messages',
      'notifications': 'Notifications',
      'verified': 'Verified',
      'per_hour': '/hour',
      'years_experience': 'years experience',
      'chat_now': 'Chat Now',
      'add_to_favorites': 'Add to Favorites',
      'remove_from_favorites': 'Remove from Favorites',
      'block_report': 'Block/Report',
      'edit_profile': 'Edit Profile',
      'save': 'Save',
      'cancel': 'Cancel',
      'send': 'Send',
      'type_message': 'Type a message...',
      'profile_views': 'Profile Views',
      'subscription_status': 'Subscription Status',
      'session_history': 'Session History',
      'interested_students': 'Interested Students',
      'bio': 'Bio',
      'hourly_rate': 'Hourly Rate',
      'experience': 'Experience',
      'male': 'Male',
      'female': 'Female',
      'in_person': 'In Person',
      'online': 'Online',
      'both': 'Both',
      'first_name': 'First Name',
      'last_name': 'Last Name',
      'confirm_password': 'Confirm Password',
      'select_role': 'Select Role',
      'forgot_password': 'Forgot Password?',
      'invalid_email': 'Please enter a valid email',
      'password_too_short': 'Password must be at least 6 characters',
      'passwords_dont_match': 'Passwords do not match',
      'field_required': 'This field is required',
    };
    return translations[key] ?? key;
  }

  String _getArabicTranslation(String key) {
    final translations = {
      'app_name': 'رابط المعلم',
      'tagline': 'صنع بواسطة برين بوكس',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'login': 'تسجيل الدخول',
      'signup': 'إنشاء حساب',
      'student': 'طالب',
      'tutor': 'معلم',
      'dashboard': 'الرئيسية',
      'profile': 'الملف الشخصي',
      'chat': 'المحادثة',
      'settings': 'الإعدادات',
      'search': 'البحث عن معلمين...',
      'subjects': 'المواد',
      'grades': 'الصفوف',
      'area': 'المنطقة',
      'teaching_type': 'نوع التدريس',
      'gender': 'الجنس',
      'price_range': 'نطاق السعر',
      'my_content': 'محتواي',
      'discover_tutors': 'اكتشف المعلمين',
      'favorites': 'المفضلة',
      'messages': 'الرسائل',
      'notifications': 'الإشعارات',
      'verified': 'موثق',
      'per_hour': '/ساعة',
      'years_experience': 'سنوات خبرة',
      'chat_now': 'محادثة الآن',
      'add_to_favorites': 'إضافة للمفضلة',
      'remove_from_favorites': 'إزالة من المفضلة',
      'block_report': 'حظر/إبلاغ',
      'edit_profile': 'تعديل الملف الشخصي',
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'send': 'إرسال',
      'type_message': 'اكتب رسالة...',
      'profile_views': 'مشاهدات الملف الشخصي',
      'subscription_status': 'حالة الاشتراك',
      'session_history': 'تاريخ الجلسات',
      'interested_students': 'الطلاب المهتمين',
      'bio': 'نبذة شخصية',
      'hourly_rate': 'السعر بالساعة',
      'experience': 'الخبرة',
      'male': 'ذكر',
      'female': 'أنثى',
      'in_person': 'وجهاً لوجه',
      'online': 'أونلاين',
      'both': 'كلاهما',
      'first_name': 'الاسم الأول',
      'last_name': 'الاسم الأخير',
      'confirm_password': 'تأكيد كلمة المرور',
      'select_role': 'اختر الدور',
      'forgot_password': 'نسيت كلمة المرور؟',
      'invalid_email': 'يرجى إدخال بريد إلكتروني صحيح',
      'password_too_short': 'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
      'passwords_dont_match': 'كلمات المرور غير متطابقة',
      'field_required': 'هذا الحقل مطلوب',
    };
    return translations[key] ?? key;
  }
}