import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/language_controller.dart';
import '../models/user.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/language_toggle.dart';
import 'dashboard_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isLoginMode = true;
  UserRole _selectedRole = UserRole.student;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final languageController = Get.find<LanguageController>();

    return Directionality(
      textDirection: languageController.isRTL.value 
          ? TextDirection.rtl 
          : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: LanguageToggle(),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  _buildHeader(),
                  SizedBox(height: 40),
                  if (!_isLoginMode) ..._buildSignupFields(),
                  _buildEmailField(),
                  SizedBox(height: 16),
                  _buildPasswordField(),
                  if (!_isLoginMode) ..._buildConfirmPasswordField(),
                  SizedBox(height: 24),
                  if (!_isLoginMode) _buildRoleSelection(),
                  if (_isLoginMode) _buildForgotPassword(),
                  SizedBox(height: 32),
                  _buildMainButton(authController),
                  SizedBox(height: 16),
                  _buildToggleModeButton(),
                  Obx(() {
                    if (authController.errorMessage.value.isNotEmpty) {
                      return Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text(
                          authController.errorMessage.value,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final languageController = Get.find<LanguageController>();
    
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Color(0xFF0768FF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.school,
            size: 40,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 24),
        Text(
          _isLoginMode 
              ? languageController.translate('login')
              : languageController.translate('signup'),
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0768FF),
          ),
        ),
        SizedBox(height: 8),
        Text(
          _isLoginMode
              ? 'Welcome back to TutorLink'
              : 'Join TutorLink today',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildSignupFields() {
    final languageController = Get.find<LanguageController>();
    
    return [
      CustomTextField(
        controller: _firstNameController,
        label: languageController.translate('first_name'),
        prefixIcon: Icons.person_outline,
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return languageController.translate('field_required');
          }
          return null;
        },
      ),
      SizedBox(height: 16),
      CustomTextField(
        controller: _lastNameController,
        label: languageController.translate('last_name'),
        prefixIcon: Icons.person_outline,
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return languageController.translate('field_required');
          }
          return null;
        },
      ),
      SizedBox(height: 16),
    ];
  }

  Widget _buildEmailField() {
    final languageController = Get.find<LanguageController>();
    
    return CustomTextField(
      controller: _emailController,
      label: languageController.translate('email'),
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return languageController.translate('field_required');
        }
        if (!GetUtils.isEmail(value!)) {
          return languageController.translate('invalid_email');
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    final languageController = Get.find<LanguageController>();
    
    return CustomTextField(
      controller: _passwordController,
      label: languageController.translate('password'),
      prefixIcon: Icons.lock_outline,
      obscureText: _obscurePassword,
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey[600],
        ),
        onPressed: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return languageController.translate('field_required');
        }
        if (value!.length < 6) {
          return languageController.translate('password_too_short');
        }
        return null;
      },
    );
  }

  List<Widget> _buildConfirmPasswordField() {
    final languageController = Get.find<LanguageController>();
    
    return [
      SizedBox(height: 16),
      CustomTextField(
        controller: _confirmPasswordController,
        label: languageController.translate('confirm_password'),
        prefixIcon: Icons.lock_outline,
        obscureText: _obscureConfirmPassword,
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[600],
          ),
          onPressed: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return languageController.translate('field_required');
          }
          if (value != _passwordController.text) {
            return languageController.translate('passwords_dont_match');
          }
          return null;
        },
      ),
    ];
  }

  Widget _buildRoleSelection() {
    final languageController = Get.find<LanguageController>();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          languageController.translate('select_role'),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedRole = UserRole.student),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _selectedRole == UserRole.student
                        ? Color(0xFF0768FF).withOpacity(0.1)
                        : Colors.grey[100],
                    border: Border.all(
                      color: _selectedRole == UserRole.student
                          ? Color(0xFF0768FF)
                          : Colors.grey[300]!,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.school,
                        color: _selectedRole == UserRole.student
                            ? Color(0xFF0768FF)
                            : Colors.grey[600],
                        size: 30,
                      ),
                      SizedBox(height: 8),
                      Text(
                        languageController.translate('student'),
                        style: TextStyle(
                          color: _selectedRole == UserRole.student
                              ? Color(0xFF0768FF)
                              : Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedRole = UserRole.tutor),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _selectedRole == UserRole.tutor
                        ? Color(0xFF0768FF).withOpacity(0.1)
                        : Colors.grey[100],
                    border: Border.all(
                      color: _selectedRole == UserRole.tutor
                          ? Color(0xFF0768FF)
                          : Colors.grey[300]!,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.person,
                        color: _selectedRole == UserRole.tutor
                            ? Color(0xFF0768FF)
                            : Colors.grey[600],
                        size: 30,
                      ),
                      SizedBox(height: 8),
                      Text(
                        languageController.translate('tutor'),
                        style: TextStyle(
                          color: _selectedRole == UserRole.tutor
                              ? Color(0xFF0768FF)
                              : Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildForgotPassword() {
    final languageController = Get.find<LanguageController>();
    
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // TODO: Implement forgot password functionality
        },
        child: Text(
          languageController.translate('forgot_password'),
          style: TextStyle(
            color: Color(0xFF0768FF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildMainButton(AuthController authController) {
    final languageController = Get.find<LanguageController>();
    
    return Obx(() => ElevatedButton(
      onPressed: authController.isLoading.value ? null : _handleSubmit,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF0768FF),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      child: authController.isLoading.value
          ? CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            )
          : Text(
              _isLoginMode
                  ? languageController.translate('login')
                  : languageController.translate('signup'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
    ));
  }

  Widget _buildToggleModeButton() {
    final languageController = Get.find<LanguageController>();
    
    return TextButton(
      onPressed: () {
        setState(() {
          _isLoginMode = !_isLoginMode;
          _formKey.currentState?.reset();
        });
      },
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
          children: [
            TextSpan(
              text: _isLoginMode
                  ? "Don't have an account? "
                  : "Already have an account? ",
            ),
            TextSpan(
              text: _isLoginMode
                  ? languageController.translate('signup')
                  : languageController.translate('login'),
              style: TextStyle(
                color: Color(0xFF0768FF),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final authController = Get.find<AuthController>();
    bool success;

    if (_isLoginMode) {
      success = await authController.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
    } else {
      success = await authController.signup(
        email: _emailController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        password: _passwordController.text,
        role: _selectedRole,
      );
    }

    if (success) {
      Get.offAll(() => DashboardScreen());
    }
  }
}