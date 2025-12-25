import 'package:get/get.dart';
import '../models/tutor.dart';
import '../models/chat_message.dart';
import '../data/mock_data.dart';

class DataController extends GetxController {
  final RxList<Tutor> allTutors = <Tutor>[].obs;
  final RxList<Tutor> filteredTutors = <Tutor>[].obs;
  final RxList<ChatMessage> chatMessages = <ChatMessage>[].obs;
  final RxString searchQuery = ''.obs;
  final RxMap<String, dynamic> filters = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadTutors();
    loadChatMessages();
  }

  void loadTutors() {
    allTutors.value = MockData.tutors;
    filteredTutors.value = allTutors.where((tutor) => 
      tutor.hasActiveSubscription && tutor.isVerified
    ).toList();
  }

  void loadChatMessages() {
    chatMessages.value = MockData.chatMessages;
  }

  void searchTutors(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void updateFilters(Map<String, dynamic> newFilters) {
    filters.value = newFilters;
    applyFilters();
  }

  void applyFilters() {
    var result = allTutors.where((tutor) => 
      tutor.hasActiveSubscription && tutor.isVerified
    );

    if (searchQuery.value.isNotEmpty) {
      result = result.where((tutor) => 
        tutor.fullName.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        tutor.subjects.any((subject) => 
          subject.toLowerCase().contains(searchQuery.value.toLowerCase())
        )
      );
    }

    if (filters['subject'] != null && filters['subject'].isNotEmpty) {
      result = result.where((tutor) => 
        tutor.subjects.contains(filters['subject'])
      );
    }

    if (filters['grade'] != null && filters['grade'].isNotEmpty) {
      result = result.where((tutor) => 
        tutor.grades.contains(filters['grade'])
      );
    }

    if (filters['area'] != null && filters['area'].isNotEmpty) {
      result = result.where((tutor) => 
        tutor.area.toLowerCase().contains(filters['area'].toLowerCase())
      );
    }

    if (filters['teachingType'] != null) {
      result = result.where((tutor) => 
        tutor.teachingType == filters['teachingType'] || 
        tutor.teachingType == TeachingType.both
      );
    }

    if (filters['gender'] != null) {
      result = result.where((tutor) => 
        tutor.gender == filters['gender']
      );
    }

    if (filters['minPrice'] != null) {
      result = result.where((tutor) => 
        tutor.hourlyRate >= filters['minPrice']
      );
    }

    if (filters['maxPrice'] != null) {
      result = result.where((tutor) => 
        tutor.hourlyRate <= filters['maxPrice']
      );
    }

    var sortedResult = result.toList();
    sortedResult.sort((a, b) {
      if (a.averageRating != b.averageRating) {
        return b.averageRating.compareTo(a.averageRating);
      }
      return b.totalRatings.compareTo(a.totalRatings);
    });

    filteredTutors.value = sortedResult;
  }

  Tutor? getTutorById(String id) {
    return allTutors.firstWhereOrNull((tutor) => tutor.id == id);
  }

  List<ChatMessage> getMessagesForChat(String userId1, String userId2) {
    return chatMessages.where((message) => 
      (message.senderId == userId1 && message.receiverId == userId2) ||
      (message.senderId == userId2 && message.receiverId == userId1)
    ).toList()..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  void sendMessage(String senderId, String receiverId, String message) {
    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      timestamp: DateTime.now(),
    );
    
    chatMessages.add(newMessage);
    MockData.chatMessages.add(newMessage);
  }

  void updateTutor(Tutor tutor) {
    final index = allTutors.indexWhere((t) => t.id == tutor.id);
    if (index != -1) {
      allTutors[index] = tutor;
      MockData.tutors[MockData.tutors.indexWhere((t) => t.id == tutor.id)] = tutor;
      applyFilters();
    }
  }

  void incrementProfileViews(String tutorId) {
    final tutor = getTutorById(tutorId);
    if (tutor != null) {
      final updatedTutor = tutor.copyWith(
        profileViews: tutor.profileViews + 1,
      );
      updateTutor(updatedTutor);
    }
  }

  void addInterestedStudent(String tutorId, String studentId) {
    final tutor = getTutorById(tutorId);
    if (tutor != null && !tutor.interestedStudents.contains(studentId)) {
      final updatedTutor = tutor.copyWith(
        interestedStudents: [...tutor.interestedStudents, studentId],
      );
      updateTutor(updatedTutor);
    }
  }
}