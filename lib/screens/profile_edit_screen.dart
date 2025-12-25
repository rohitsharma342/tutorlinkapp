import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../controllers/auth_controller.dart';
import '../controllers/language_controller.dart';
import '../controllers/data_controller.dart';
import '../models/tutor.dart';
import '../widgets/custom_text_field.dart';
import '../data/mock_data.dart';

class ProfileEditScreen extends StatefulWidget {
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bioController = TextEditingController();
  final _hourlyRateController = TextEditingController();
  final _experienceController = TextEditingController();
  
  List<String> _selectedSubjects = [];
  List<String> _selectedGrades = [];
  TeachingType _selectedTeachingType = TeachingType.both;
  String _selectedArea = '';
  String? _profilePhotoPath;
  String? _introVideoPath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentProfile();
  }

  void _loadCurrentProfile() {
    final authController = Get.find<AuthController>();
    final dataController = Get.find<DataController>();
    final currentUser = authController.currentUser.value;
    
    if (currentUser != null) {
      final tutor = dataController.getTutorById(currentUser.id);
      if (tutor != null) {
        _bioController.text = tutor.bio;
        _hourlyRateController.text = tutor.hourlyRate.toString();
        _experienceController.text = tutor.experienceYears.toString();
        _selectedSubjects = List.from(tutor.subjects);
        _selectedGrades = List.from(tutor.grades);
        _selectedTeachingType = tutor.teachingType;
        _selectedArea = tutor.area;
        _profilePhotoPath = tutor.profilePhoto;
        _introVideoPath = tutor.introVideo;
      }
    }
  }

  @override
  void dispose() {
    _bioController.dispose();
    _hourlyRateController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();

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
            languageController.translate('edit_profile'),
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMediaSection(languageController),
                SizedBox(height: 20),
                _buildBasicInfoSection(languageController),
                SizedBox(height: 20),
                _buildSubjectsSection(languageController),
                SizedBox(height: 20),
                _buildGradesSection(languageController),
                SizedBox(height: 20),
                _buildTeachingDetailsSection(languageController),
                SizedBox(height: 32),
                _buildSaveButton(languageController),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMediaSection(LanguageController languageController) {
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
          Text(
            'Media',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMediaUpload(
                  title: 'Profile Photo',
                  subtitle: 'Upload your photo',
                  icon: Icons.photo_camera,
                  onTap: _pickProfilePhoto,
                  hasFile: _profilePhotoPath != null,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildMediaUpload(
                  title: 'Intro Video',
                  subtitle: 'Upload intro video',
                  icon: Icons.videocam,
                  onTap: _pickIntroVideo,
                  hasFile: _introVideoPath != null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMediaUpload({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required bool hasFile,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: hasFile ? Color(0xFF0768FF).withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasFile ? Color(0xFF0768FF) : Colors.grey[300]!,
          ),
        ),
        child: Column(
          children: [
            Icon(
              hasFile ? Icons.check_circle : icon,
              color: hasFile ? Color(0xFF0768FF) : Colors.grey[600],
              size: 32,
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: hasFile ? Color(0xFF0768FF) : Colors.black87,
              ),
            ),
            SizedBox(height: 4),
            Text(
              hasFile ? 'Uploaded' : subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection(LanguageController languageController) {
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
          Text(
            'Basic Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          CustomTextField(
            controller: _bioController,
            label: languageController.translate('bio'),
            prefixIcon: Icons.info_outline,
            maxLines: 3,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return languageController.translate('field_required');
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _hourlyRateController,
                  label: '${languageController.translate('hourly_rate')} (SAR)',
                  prefixIcon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return languageController.translate('field_required');
                    }
                    if (double.tryParse(value!) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: CustomTextField(
                  controller: _experienceController,
                  label: '${languageController.translate('experience')} (Years)',
                  prefixIcon: Icons.work_outline,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return languageController.translate('field_required');
                    }
                    if (int.tryParse(value!) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectsSection(LanguageController languageController) {
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
          Text(
            languageController.translate('subjects'),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: MockData.subjects.map((subject) {
              final isSelected = _selectedSubjects.contains(subject);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedSubjects.remove(subject);
                    } else {
                      _selectedSubjects.add(subject);
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? Color(0xFF0768FF).withOpacity(0.1)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected 
                          ? Color(0xFF0768FF)
                          : Colors.grey[300]!,
                    ),
                  ),
                  child: Text(
                    subject,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected 
                          ? Color(0xFF0768FF)
                          : Colors.grey[700],
                      fontWeight: isSelected 
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGradesSection(LanguageController languageController) {
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
          Text(
            languageController.translate('grades'),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: MockData.grades.map((grade) {
              final isSelected = _selectedGrades.contains(grade);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedGrades.remove(grade);
                    } else {
                      _selectedGrades.add(grade);
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? Color(0xFF0768FF).withOpacity(0.1)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected 
                          ? Color(0xFF0768FF)
                          : Colors.grey[300]!,
                    ),
                  ),
                  child: Text(
                    grade,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected 
                          ? Color(0xFF0768FF)
                          : Colors.grey[700],
                      fontWeight: isSelected 
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTeachingDetailsSection(LanguageController languageController) {
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
          Text(
            'Teaching Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          Text(
            languageController.translate('teaching_type'),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: TeachingType.values.map((type) {
              final isSelected = _selectedTeachingType == type;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTeachingType = type;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 8),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? Color(0xFF0768FF).withOpacity(0.1)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected 
                            ? Color(0xFF0768FF)
                            : Colors.grey[300]!,
                      ),
                    ),
                    child: Text(
                      _getTeachingTypeText(type),
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected 
                            ? Color(0xFF0768FF)
                            : Colors.grey[700],
                        fontWeight: isSelected 
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedArea.isEmpty ? null : _selectedArea,
            decoration: InputDecoration(
              labelText: languageController.translate('area'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
            items: MockData.areas.map((area) => DropdownMenuItem<String>(
              value: area,
              child: Text(area),
            )).toList(),
            onChanged: (value) {
              setState(() {
                _selectedArea = value ?? '';
              });
            },
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return languageController.translate('field_required');
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(LanguageController languageController) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Get.back(),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: Colors.grey[400]!),
            ),
            child: Text(
              languageController.translate('cancel'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF0768FF),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: _isLoading
                ? CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  )
                : Text(
                    languageController.translate('save'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  String _getTeachingTypeText(TeachingType type) {
    switch (type) {
      case TeachingType.inPerson:
        return 'In Person';
      case TeachingType.online:
        return 'Online';
      case TeachingType.both:
        return 'Both';
    }
  }

  Future<void> _pickProfilePhoto() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _profilePhotoPath = image.path;
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  Future<void> _pickIntroVideo() async {
    try {
      final picker = ImagePicker();
      final video = await picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: Duration(minutes: 2),
      );
      
      if (video != null) {
        setState(() {
          _introVideoPath = video.path;
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick video',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedSubjects.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select at least one subject',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }
    
    if (_selectedGrades.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select at least one grade',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(Duration(seconds: 2)); // Simulate API call
      
      final authController = Get.find<AuthController>();
      final dataController = Get.find<DataController>();
      final currentUser = authController.currentUser.value;
      
      if (currentUser != null) {
        final currentTutor = dataController.getTutorById(currentUser.id);
        if (currentTutor != null) {
          final updatedTutor = currentTutor.copyWith(
            bio: _bioController.text.trim(),
            hourlyRate: double.parse(_hourlyRateController.text),
            experienceYears: int.parse(_experienceController.text),
            subjects: _selectedSubjects,
            grades: _selectedGrades,
            teachingType: _selectedTeachingType,
            area: _selectedArea,
            profilePhoto: _profilePhotoPath,
            introVideo: _introVideoPath,
          );
          
          dataController.updateTutor(updatedTutor);
          
          Get.back();
          Get.snackbar(
            'Success',
            'Profile updated successfully',
            backgroundColor: Colors.green[100],
            colorText: Colors.green[800],
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}