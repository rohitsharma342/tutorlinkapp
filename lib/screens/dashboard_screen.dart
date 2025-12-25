import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/language_controller.dart';
import '../controllers/data_controller.dart';
import '../models/user.dart';
import '../models/tutor.dart';
import '../widgets/tutor_card.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/language_toggle.dart';
import '../data/mock_data.dart';
import 'tutor_dashboard_screen.dart';
import 'profile_edit_screen.dart';
import 'chat_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  int _selectedIndex = 0;
  bool _showFilters = false;

  String? _selectedSubject;
  String? _selectedGrade;
  String? _selectedArea;
  TeachingType? _selectedTeachingType;
  Gender? _selectedGender;
  double _minPrice = 0;
  double _maxPrice = 300;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final languageController = Get.find<LanguageController>();
    final dataController = Get.find<DataController>();

    if (authController.isTutor()) {
      return TutorDashboardScreen();
    }

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
            languageController.translate('dashboard'),
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
                // TODO: Navigate to notifications
              },
            ),
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: LanguageToggle(),
            ),
          ],
        ),
        body: Column(
          children: [
            _buildSearchBar(dataController, languageController),
            if (_showFilters) _buildFiltersSection(languageController),
            _buildTabBar(languageController),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildMyContentTab(authController, languageController),
                  _buildDiscoverTutorsTab(dataController, languageController),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomNavigationBar(authController, languageController),
      ),
    );
  }

  Widget _buildSearchBar(DataController dataController, LanguageController languageController) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _searchController,
                  label: languageController.translate('search'),
                  prefixIcon: Icons.search,
                  onChanged: (value) {
                    dataController.searchTutors(value);
                  },
                ),
              ),
              SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showFilters = !_showFilters;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _showFilters ? Color(0xFF0768FF) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.tune,
                    color: _showFilters ? Colors.white : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection(LanguageController languageController) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: Colors.grey[300]),
          SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildFilterDropdown(
                label: languageController.translate('subjects'),
                value: _selectedSubject,
                items: MockData.subjects,
                onChanged: (value) {
                  setState(() {
                    _selectedSubject = value;
                  });
                  _applyFilters();
                },
              ),
              _buildFilterDropdown(
                label: languageController.translate('grades'),
                value: _selectedGrade,
                items: MockData.grades,
                onChanged: (value) {
                  setState(() {
                    _selectedGrade = value;
                  });
                  _applyFilters();
                },
              ),
              _buildFilterDropdown(
                label: languageController.translate('area'),
                value: _selectedArea,
                items: MockData.areas,
                onChanged: (value) {
                  setState(() {
                    _selectedArea = value;
                  });
                  _applyFilters();
                },
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            '${languageController.translate('price_range')}: ${_minPrice.round()} - ${_maxPrice.round()} SAR',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          RangeSlider(
            values: RangeValues(_minPrice, _maxPrice),
            min: 0,
            max: 300,
            divisions: 30,
            activeColor: Color(0xFF0768FF),
            onChanged: (values) {
              setState(() {
                _minPrice = values.start;
                _maxPrice = values.end;
              });
            },
            onChangeEnd: (values) {
              _applyFilters();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      width: 120,
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        items: [
          DropdownMenuItem<String>(
            value: null,
            child: Text('All'),
          ),
          ...items.map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          )),
        ],
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildTabBar(LanguageController languageController) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: Color(0xFF0768FF),
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: Color(0xFF0768FF),
        tabs: [
          Tab(text: languageController.translate('my_content')),
          Tab(text: languageController.translate('discover_tutors')),
        ],
      ),
    );
  }

  Widget _buildMyContentTab(AuthController authController, LanguageController languageController) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            title: languageController.translate('favorites'),
            icon: Icons.favorite,
            child: _buildFavoritesTutors(authController),
          ),
          SizedBox(height: 24),
          _buildSection(
            title: languageController.translate('messages'),
            icon: Icons.message,
            child: _buildRecentChats(authController),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoverTutorsTab(DataController dataController, LanguageController languageController) {
    return Obx(() {
      final tutors = dataController.filteredTutors;
      
      if (tutors.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16),
              Text(
                'No tutors found',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: tutors.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: TutorCard(
              tutor: tutors[index],
              onTap: () {
                dataController.incrementProfileViews(tutors[index].id);
                Get.toNamed('/tutor_profile', arguments: tutors[index]);
              },
            ),
          );
        },
      );
    });
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Color(0xFF0768FF),
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildFavoritesTutors(AuthController authController) {
    final user = authController.currentUser.value;
    if (user == null || user.favoritesTutorIds.isEmpty) {
      return Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Center(
          child: Text(
            'No favorite tutors yet',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    final dataController = Get.find<DataController>();
    final favoriteTutors = user.favoritesTutorIds
        .map((id) => dataController.getTutorById(id))
        .where((tutor) => tutor != null)
        .cast<Tutor>()
        .toList();

    return Column(
      children: favoriteTutors.map((tutor) => Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: TutorCard(
          tutor: tutor,
          onTap: () {
            dataController.incrementProfileViews(tutor.id);
            Get.toNamed('/tutor_profile', arguments: tutor);
          },
        ),
      )).toList(),
    );
  }

  Widget _buildRecentChats(AuthController authController) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.chat_bubble_outline,
            color: Colors.grey[400],
            size: 32,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No recent conversations',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Start chatting with tutors to see your conversations here',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
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
            Get.to(() => ChatScreen(receiverId: '2'));
            break;
          case 2:
            if (authController.isTutor()) {
              Get.to(() => ProfileEditScreen());
            }
            break;
          case 3:
            // TODO: Navigate to Settings
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
          label: languageController.translate('chat'),
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

  void _applyFilters() {
    final dataController = Get.find<DataController>();
    final filters = {
      'subject': _selectedSubject,
      'grade': _selectedGrade,
      'area': _selectedArea,
      'teachingType': _selectedTeachingType,
      'gender': _selectedGender,
      'minPrice': _minPrice,
      'maxPrice': _maxPrice,
    };
    dataController.updateFilters(filters);
  }
}