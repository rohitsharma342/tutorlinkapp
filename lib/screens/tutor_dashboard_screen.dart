import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/auth_controller.dart';
import '../controllers/language_controller.dart';
import '../controllers/data_controller.dart';
import '../widgets/language_toggle.dart';
import 'profile_edit_screen.dart';
import 'chat_screen.dart';

class TutorDashboardScreen extends StatefulWidget {
  @override
  _TutorDashboardScreenState createState() => _TutorDashboardScreenState();
}

class _TutorDashboardScreenState extends State<TutorDashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final languageController = Get.find<LanguageController>();
    final dataController = Get.find<DataController>();
    
    final currentUser = authController.currentUser.value;
    final currentTutor = dataController.getTutorById(currentUser?.id ?? '');

    return Directionality(
      textDirection: languageController.isRTL.value 
          ? TextDirection.rtl 
          : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: Text(
            'Tutor ${languageController.translate('dashboard')}',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.notifications_outlined,
                color: Colors.grey[700],
              ),
              onPressed: () {
                _showNotifications(languageController);
              },
            ),
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: LanguageToggle(),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileOverview(currentTutor, languageController),
              SizedBox(height: 20),
              _buildStatsCards(currentTutor, languageController),
              SizedBox(height: 20),
              _buildSubscriptionStatus(currentTutor, languageController),
              SizedBox(height: 20),
              _buildInterestedStudents(currentTutor, languageController),
              SizedBox(height: 20),
              _buildSessionHistory(languageController),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(authController, languageController),
      ),
    );
  }

  Widget _buildProfileOverview(dynamic tutor, LanguageController languageController) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: tutor?.profilePhoto != null
                  ? CachedNetworkImage(
                      imageUrl: tutor!.profilePhoto!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: Icon(Icons.person, color: Colors.grey[400]),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: Icon(Icons.person, color: Colors.grey[400]),
                      ),
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: Icon(Icons.person, color: Colors.grey[400]),
                    ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tutor?.fullName ?? 'Unknown Tutor',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  tutor?.subjects?.join(', ') ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    if (tutor?.isVerified == true)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Color(0xFF0768FF).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          languageController.translate('verified'),
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF0768FF),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    SizedBox(width: 8),
                    Text(
                      '⭐ ${tutor?.averageRating?.toStringAsFixed(1) ?? '0.0'}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.orange[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Color(0xFF0768FF)),
            onPressed: () => Get.to(() => ProfileEditScreen()),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(dynamic tutor, LanguageController languageController) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: languageController.translate('profile_views'),
            value: tutor?.profileViews?.toString() ?? '0',
            icon: Icons.visibility,
            color: Color(0xFF0768FF),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'Total Ratings',
            value: tutor?.totalRatings?.toString() ?? '0',
            icon: Icons.star,
            color: Colors.orange,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'Interested',
            value: tutor?.interestedStudents?.length?.toString() ?? '0',
            icon: Icons.favorite,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionStatus(dynamic tutor, LanguageController languageController) {
    final isActive = tutor?.hasActiveSubscription == true;
    
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.card_membership,
                color: isActive ? Colors.green : Colors.red,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                languageController.translate('subscription_status'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isActive ? Colors.green[50] : Colors.red[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isActive ? Colors.green[200]! : Colors.red[200]!,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isActive ? Icons.check_circle : Icons.warning,
                  color: isActive ? Colors.green[600] : Colors.red[600],
                  size: 20,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isActive 
                        ? 'Your subscription is active. You can receive messages from students.'
                        : 'Your subscription has expired. Renew to continue receiving messages.',
                    style: TextStyle(
                      fontSize: 14,
                      color: isActive ? Colors.green[700] : Colors.red[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!isActive) ..[
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to subscription renewal
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0768FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Renew Subscription'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInterestedStudents(dynamic tutor, LanguageController languageController) {
    final interestedStudents = tutor?.interestedStudents ?? <String>[];
    
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.people,
                color: Color(0xFF0768FF),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                languageController.translate('interested_students'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          if (interestedStudents.isEmpty)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'No interested students yet',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
            )
          else
            Column(
              children: interestedStudents.take(3).map((studentId) {
                return _buildStudentCard(studentId);
              }).toList(),
            ),
          if (interestedStudents.length > 3) ..[
            SizedBox(height: 8),
            Center(
              child: Text(
                '+${interestedStudents.length - 3} more students',
                style: TextStyle(
                  color: Color(0xFF0768FF),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStudentCard(String studentId) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFF0768FF),
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Student ${studentId.substring(0, 1).toUpperCase()}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Grade 10 • Riyadh',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.chat, color: Color(0xFF0768FF), size: 20),
                onPressed: () => Get.to(() => ChatScreen(receiverId: studentId)),
              ),
              IconButton(
                icon: Icon(Icons.block, color: Colors.red, size: 20),
                onPressed: () => _showBlockStudentDialog(studentId),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSessionHistory(LanguageController languageController) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.history,
                color: Color(0xFF0768FF),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                languageController.translate('session_history'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'No completed sessions yet',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(AuthController authController, LanguageController languageController) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        
        switch (index) {
          case 0:
            // Already on Dashboard
            break;
          case 1:
            // TODO: Navigate to Messages
            break;
          case 2:
            Get.to(() => ProfileEditScreen());
            break;
          case 3:
            _showSettings(authController, languageController);
            break;
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Color(0xFF0768FF),
      unselectedItemColor: Colors.grey[600],
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: languageController.translate('dashboard'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: languageController.translate('messages'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: languageController.translate('profile'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: languageController.translate('settings'),
        ),
      ],
    );
  }

  void _showNotifications(LanguageController languageController) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              languageController.translate('notifications'),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('Profile Approved'),
              subtitle: Text('Your tutor profile has been approved by admin'),
              trailing: Text('2 days ago'),
            ),
            ListTile(
              leading: Icon(Icons.star, color: Colors.orange),
              title: Text('New Rating Received'),
              subtitle: Text('You received a 5-star rating from Ahmed'),
              trailing: Text('1 week ago'),
            ),
            ListTile(
              leading: Icon(Icons.message, color: Color(0xFF0768FF)),
              title: Text('New Message'),
              subtitle: Text('You have a new message from a student'),
              trailing: Text('2 weeks ago'),
            ),
          ],
        ),
      ),
    );
  }

  void _showBlockStudentDialog(String studentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Block Student'),
        content: Text('Are you sure you want to block this student? They will not be able to contact you anymore.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Blocked',
                'Student has been blocked successfully',
                backgroundColor: Colors.red[100],
                colorText: Colors.red[800],
              );
            },
            child: Text('Block'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  void _showSettings(AuthController authController, LanguageController languageController) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.language, color: Color(0xFF0768FF)),
              title: Text('Language'),
              subtitle: Text(languageController.isArabic ? 'العربية' : 'English'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Get.back();
                languageController.toggleLanguage();
              },
            ),
            ListTile(
              leading: Icon(Icons.help, color: Colors.orange),
              title: Text('Help & Support'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Get.back();
                // TODO: Navigate to help
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Logout'),
              onTap: () {
                Get.back();
                _showLogoutDialog(authController);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(AuthController authController) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              authController.logout();
              Get.offAllNamed('/auth');
            },
            child: Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}