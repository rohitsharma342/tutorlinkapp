import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../data/mock_data.dart';

class AuthController extends GetxController {
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedUser();
  }

  Future<void> _loadSavedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('current_user_id');
      if (userId != null) {
        final user = MockData.users.firstWhereOrNull((u) => u.id == userId);
        if (user != null) {
          currentUser.value = user;
        }
      }
    } catch (e) {
      print('Error loading saved user: $e');
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await Future.delayed(Duration(seconds: 1));

      final user = MockData.users.firstWhereOrNull(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
      );

      if (user == null) {
        errorMessage.value = 'User not found';
        return false;
      }

      if (user.role == UserRole.tutor && !user.isApproved) {
        errorMessage.value = 'Your account is pending approval';
        return false;
      }

      currentUser.value = user;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user_id', user.id);

      return true;
    } catch (e) {
      errorMessage.value = 'Login failed. Please try again.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signup({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
    required UserRole role,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await Future.delayed(Duration(seconds: 1));

      final existingUser = MockData.users.firstWhereOrNull(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
      );

      if (existingUser != null) {
        errorMessage.value = 'Email already exists';
        return false;
      }

      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        firstName: firstName,
        lastName: lastName,
        role: role,
        isApproved: role == UserRole.student,
        hasActiveSubscription: role == UserRole.student,
      );

      MockData.users.add(newUser);
      currentUser.value = newUser;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user_id', newUser.id);

      return true;
    } catch (e) {
      errorMessage.value = 'Signup failed. Please try again.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('current_user_id');
      currentUser.value = null;
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  void updateUser(User user) {
    currentUser.value = user;
    final index = MockData.users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      MockData.users[index] = user;
    }
  }

  void addToFavorites(String tutorId) {
    if (currentUser.value != null) {
      final updatedFavorites = [...currentUser.value!.favoritesTutorIds, tutorId];
      final updatedUser = currentUser.value!.copyWith(
        favoritesTutorIds: updatedFavorites,
      );
      updateUser(updatedUser);
    }
  }

  void removeFromFavorites(String tutorId) {
    if (currentUser.value != null) {
      final updatedFavorites = currentUser.value!.favoritesTutorIds
          .where((id) => id != tutorId)
          .toList();
      final updatedUser = currentUser.value!.copyWith(
        favoritesTutorIds: updatedFavorites,
      );
      updateUser(updatedUser);
    }
  }

  void blockUser(String userId) {
    if (currentUser.value != null) {
      final updatedBlocked = [...currentUser.value!.blockedUserIds, userId];
      final updatedUser = currentUser.value!.copyWith(
        blockedUserIds: updatedBlocked,
      );
      updateUser(updatedUser);
    }
  }

  bool isLoggedIn() => currentUser.value != null;
  bool isStudent() => currentUser.value?.role == UserRole.student;
  bool isTutor() => currentUser.value?.role == UserRole.tutor;
}