import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/auth_controller.dart';
import '../controllers/language_controller.dart';
import '../controllers/data_controller.dart';
import '../models/tutor.dart';
import '../widgets/rating_stars.dart';
import 'chat_screen.dart';
import 'profile_edit_screen.dart';

class TutorProfileScreen extends StatefulWidget {
  final Tutor tutor;

  TutorProfileScreen({required this.tutor});

  @override
  _TutorProfileScreenState createState() => _TutorProfileScreenState();
}

class _TutorProfileScreenState extends State<TutorProfileScreen> {
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  void _checkFavoriteStatus() {
    final authController = Get.find<AuthController>();
    final user = authController.currentUser.value;
    if (user != null) {
      setState(() {
        _isFavorited = user.favoritesTutorIds.contains(widget.tutor.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final languageController = Get.find<LanguageController>();
    final isCurrentUser = authController.currentUser.value?.id == widget.tutor.id;

    return Directionality(
      textDirection: languageController.isRTL.value 
          ? TextDirection.rtl 
          : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Get.back(),
          ),
          title: Text(
            widget.tutor.fullName,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            if (isCurrentUser)
              IconButton(
                icon: Icon(Icons.edit, color: Colors.grey[700]),
                onPressed: () => Get.to(() => ProfileEditScreen()),
              ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(languageController),
              _buildProfileInfo(languageController),
              _buildSubjectsAndGrades(languageController),
              _buildBio(languageController),
              if (!isCurrentUser && authController.isStudent())
                _buildActionButtons(authController, languageController),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(LanguageController languageController) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: widget.tutor.profilePhoto != null
                      ? CachedNetworkImage(
                          imageUrl: widget.tutor.profilePhoto!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey[400],
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey[400],
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.grey[400],
                          ),
                        ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.tutor.fullName,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        if (widget.tutor.isVerified)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Color(0xFF0768FF).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.verified,
                                  size: 16,
                                  color: Color(0xFF0768FF),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  languageController.translate('verified'),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0768FF),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${widget.tutor.genderText} • ${widget.tutor.area}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        RatingStars(
                          rating: widget.tutor.averageRating,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${widget.tutor.averageRating.toStringAsFixed(1)} (${widget.tutor.totalRatings})',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${widget.tutor.hourlyRate.toStringAsFixed(0)} SAR${languageController.translate('per_hour')}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0768FF),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(LanguageController languageController) {
    return Container(
      margin: EdgeInsets.all(16),
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
        children: [
          _buildInfoRow(
            icon: Icons.work_outline,
            label: languageController.translate('teaching_type'),
            value: widget.tutor.teachingTypeText,
          ),
          Divider(color: Colors.grey[200]),
          _buildInfoRow(
            icon: Icons.schedule,
            label: languageController.translate('experience'),
            value: '${widget.tutor.experienceYears} ${languageController.translate('years_experience')}',
          ),
          Divider(color: Colors.grey[200]),
          _buildInfoRow(
            icon: Icons.location_on_outlined,
            label: languageController.translate('area'),
            value: widget.tutor.area,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: Color(0xFF0768FF),
            size: 20,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectsAndGrades(LanguageController languageController) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
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
          Text(
            languageController.translate('subjects'),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.tutor.subjects.map((subject) => Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFF0768FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                subject,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF0768FF),
                  fontWeight: FontWeight.w600,
                ),
              ),
            )).toList(),
          ),
          SizedBox(height: 20),
          Text(
            languageController.translate('grades'),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.tutor.grades.map((grade) => Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                grade,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBio(LanguageController languageController) {
    return Container(
      margin: EdgeInsets.all(16),
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
          Text(
            languageController.translate('bio'),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          Text(
            widget.tutor.bio,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(AuthController authController, LanguageController languageController) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final dataController = Get.find<DataController>();
                    dataController.addInterestedStudent(
                      widget.tutor.id,
                      authController.currentUser.value!.id,
                    );
                    Get.to(() => ChatScreen(receiverId: widget.tutor.id));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0768FF),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat, size: 20),
                      SizedBox(width: 8),
                      Text(
                        languageController.translate('chat_now'),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12),
              GestureDetector(
                onTap: _toggleFavorite,
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _isFavorited ? Color(0xFF0768FF) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isFavorited ? Color(0xFF0768FF) : Colors.grey[300]!,
                    ),
                  ),
                  child: Icon(
                    Icons.favorite,
                    color: _isFavorited ? Colors.white : Colors.grey[600],
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          TextButton(
            onPressed: () => _showBlockReportDialog(languageController),
            child: Text(
              languageController.translate('block_report'),
              style: TextStyle(
                color: Colors.red[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleFavorite() {
    final authController = Get.find<AuthController>();
    
    if (_isFavorited) {
      authController.removeFromFavorites(widget.tutor.id);
    } else {
      authController.addToFavorites(widget.tutor.id);
    }
    
    setState(() {
      _isFavorited = !_isFavorited;
    });
  }

  void _showBlockReportDialog(LanguageController languageController) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(languageController.translate('block_report')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.block, color: Colors.red),
              title: Text('Block Tutor'),
              onTap: () {
                Get.back();
                _blockTutor();
              },
            ),
            ListTile(
              leading: Icon(Icons.report, color: Colors.orange),
              title: Text('Report Tutor'),
              onTap: () {
                Get.back();
                _showReportDialog(languageController);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(languageController.translate('cancel')),
          ),
        ],
      ),
    );
  }

  void _blockTutor() {
    final authController = Get.find<AuthController>();
    authController.blockUser(widget.tutor.id);
    
    Get.snackbar(
      'Blocked',
      'Tutor has been blocked successfully',
      backgroundColor: Colors.red[100],
      colorText: Colors.red[800],
    );
  }

  void _showReportDialog(LanguageController languageController) {
    final _reportController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report Tutor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _reportController,
              decoration: InputDecoration(
                labelText: 'Reason for reporting',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(languageController.translate('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Reported',
                'Report submitted successfully',
                backgroundColor: Colors.orange[100],
                colorText: Colors.orange[800],
              );
            },
            child: Text('Submit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}