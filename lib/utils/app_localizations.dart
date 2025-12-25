import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppLocalizations {
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations();
  }

  // English translations
  static const Map<String, String> _englishValues = {
    'app_name': 'TutorLink',
    'tagline': 'Made With BrainBox',
    'welcome': 'Welcome',
    'login': 'Login',
    'signup': 'Sign Up',
    'email': 'Email',
    'password': 'Password',
    'confirm_password': 'Confirm Password',
    'first_name': 'First Name',
    'last_name': 'Last Name',
    'student': 'Student',
    'tutor': 'Tutor',
    'dashboard': 'Dashboard',
    'profile': 'Profile',
    'settings': 'Settings',
    'logout': 'Logout',
    'search': 'Search',
    'filter': 'Filter',
    'subjects': 'Subjects',
    'grades': 'Grades',
    'area': 'Area',
    'teaching_type': 'Teaching Type',
    'gender': 'Gender',
    'price_range': 'Price Range',
    'favorites': 'Favorites',
    'messages': 'Messages',
    'notifications': 'Notifications',
    'chat': 'Chat',
    'send': 'Send',
    'type_message': 'Type a message...',
    'verified': 'Verified',
    'per_hour': '/hour',
    'years_experience': 'years experience',
    'bio': 'Bio',
    'hourly_rate': 'Hourly Rate',
    'experience': 'Experience',
    'save': 'Save',
    'cancel': 'Cancel',
    'edit': 'Edit',
    'delete': 'Delete',
    'block': 'Block',
    'report': 'Report',
    'male': 'Male',
    'female': 'Female',
    'online': 'Online',
    'offline': 'Offline',
    'available': 'Available',
    'busy': 'Busy',
    'loading': 'Loading...',
    'error': 'Error',
    'success': 'Success',
    'warning': 'Warning',
    'info': 'Information',
    'yes': 'Yes',
    'no': 'No',
    'ok': 'OK',
    'retry': 'Retry',
    'close': 'Close',
    'back': 'Back',
    'next': 'Next',
    'previous': 'Previous',
    'continue': 'Continue',
    'finish': 'Finish',
    'upload': 'Upload',
    'download': 'Download',
    'share': 'Share',
    'copy': 'Copy',
    'paste': 'Paste',
    'select_all': 'Select All',
    'deselect_all': 'Deselect All',
    'required_field': 'This field is required',
    'invalid_email': 'Please enter a valid email',
    'password_too_short': 'Password must be at least 6 characters',
    'passwords_dont_match': 'Passwords do not match',
    'network_error': 'Network error. Please check your connection.',
    'server_error': 'Server error. Please try again later.',
    'no_data': 'No data available',
    'no_results': 'No results found',
    'try_again': 'Try again',
  };

  // Arabic translations
  static const Map<String, String> _arabicValues = {
    'app_name': 'رابط المعلم',
    'tagline': 'صنع بواسطة برين بوكس',
    'welcome': 'مرحباً',
    'login': 'تسجيل الدخول',
    'signup': 'إنشاء حساب',
    'email': 'البريد الإلكتروني',
    'password': 'كلمة المرور',
    'confirm_password': 'تأكيد كلمة المرور',
    'first_name': 'الاسم الأول',
    'last_name': 'الاسم الأخير',
    'student': 'طالب',
    'tutor': 'معلم',
    'dashboard': 'الرئيسية',
    'profile': 'الملف الشخصي',
    'settings': 'الإعدادات',
    'logout': 'تسجيل الخروج',
    'search': 'البحث',
    'filter': 'تصفية',
    'subjects': 'المواد',
    'grades': 'الصفوف',
    'area': 'المنطقة',
    'teaching_type': 'نوع التدريس',
    'gender': 'الجنس',
    'price_range': 'نطاق السعر',
    'favorites': 'المفضلة',
    'messages': 'الرسائل',
    'notifications': 'الإشعارات',
    'chat': 'المحادثة',
    'send': 'إرسال',
    'type_message': 'اكتب رسالة...',
    'verified': 'موثق',
    'per_hour': '/ساعة',
    'years_experience': 'سنوات خبرة',
    'bio': 'نبذة شخصية',
    'hourly_rate': 'السعر بالساعة',
    'experience': 'الخبرة',
    'save': 'حفظ',
    'cancel': 'إلغاء',
    'edit': 'تعديل',
    'delete': 'حذف',
    'block': 'حظر',
    'report': 'إبلاغ',
    'male': 'ذكر',
    'female': 'أنثى',
    'online': 'متصل',
    'offline': 'غير متصل',
    'available': 'متاح',
    'busy': 'مشغول',
    'loading': 'جاري التحميل...',
    'error': 'خطأ',
    'success': 'نجح',
    'warning': 'تحذير',
    'info': 'معلومات',
    'yes': 'نعم',
    'no': 'لا',
    'ok': 'موافق',
    'retry': 'إعادة المحاولة',
    'close': 'إغلاق',
    'back': 'رجوع',
    'next': 'التالي',
    'previous': 'السابق',
    'continue': 'متابعة',
    'finish': 'إنهاء',
    'upload': 'رفع',
    'download': 'تحميل',
    'share': 'مشاركة',
    'copy': 'نسخ',
    'paste': 'لصق',
    'select_all': 'تحديد الكل',
    'deselect_all': 'إلغاء تحديد الكل',
    'required_field': 'هذا الحقل مطلوب',
    'invalid_email': 'يرجى إدخال بريد إلكتروني صحيح',
    'password_too_short': 'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
    'passwords_dont_match': 'كلمات المرور غير متطابقة',
    'network_error': 'خطأ في الشبكة. يرجى التحقق من الاتصال.',
    'server_error': 'خطأ في الخادم. يرجى المحاولة لاحقاً.',
    'no_data': 'لا توجد بيانات متاحة',
    'no_results': 'لم يتم العثور على نتائج',
    'try_again': 'حاول مرة أخرى',
  };

  String translate(String key, [String? locale]) {
    final currentLocale = locale ?? Get.locale?.languageCode ?? 'en';
    
    if (currentLocale == 'ar') {
      return _arabicValues[key] ?? _englishValues[key] ?? key;
    } else {
      return _englishValues[key] ?? key;
    }
  }

  static String getString(String key) {
    final currentLocale = Get.locale?.languageCode ?? 'en';
    
    if (currentLocale == 'ar') {
      return _arabicValues[key] ?? _englishValues[key] ?? key;
    } else {
      return _englishValues[key] ?? key;
    }
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations();
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}