import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymhelper/features/tracker/presentation/cubit/tracker_cubit.dart';
import 'package:gymhelper/features/tracker/presentation/screens/main_screen.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart'; 
import 'package:easy_localization/easy_localization.dart'; // ДОДАНО ІМПОРТ

import '../../../../data/models/user_model.dart';
import '../../../../core/constants/color_constants.dart'; 

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  
  UserGoal _selectedGoal = UserGoal.maintain;
  String? _avatarPath; 

  // Допоміжна функція для визначення розміру екрану
  bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 600;

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    
    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1), 
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'profile.center_photo'.tr(), // Використовуємо ключ з профілю
            toolbarColor: AppColors.primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            hideBottomControls: true,
          ),
          IOSUiSettings(
            title: 'profile.center_photo'.tr(),
            aspectRatioLockEnabled: true,
            resetButtonHidden: true,
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          _avatarPath = croppedFile.path;
        });
      }
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final user = UserModel(
        name: _nameController.text.trim(),
        weight: double.parse(_weightController.text.trim()),
        height: double.parse(_heightController.text.trim()),
        goal: _selectedGoal,
        avatarPath: _avatarPath, 
      );

      context.read<TrackerCubit>().saveUserProfile(user);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tablet = isTablet(context);
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Динамічний відступ: на планшеті форма буде вужчою і по центру
    final horizontalPadding = tablet ? screenWidth * 0.2 : 24.0;
    final contentPadding = EdgeInsets.symmetric(vertical: tablet ? 20 : 16, horizontal: 16);
    final fontSize = tablet ? 18.0 : 16.0;

    return Scaffold(
      backgroundColor: AppColors.background, 
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: tablet ? 40.0 : 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'profile_setup.welcome'.tr(), // Давайте знайомитись! 👋
                    style: TextStyle(
                      fontSize: tablet ? 36 : 28, 
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: tablet ? 12 : 8),
                  Text(
                    'profile_setup.subtitle'.tr(), // Введіть свої дані...
                    style: TextStyle(fontSize: tablet ? 18 : 16, color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: tablet ? 48 : 32),

                  Center(
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: _pickAvatar,
                          child: CircleAvatar(
                            radius: tablet ? 75 : 50,
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage: _avatarPath != null 
                                ? FileImage(File(_avatarPath!)) 
                                : null,
                            child: _avatarPath == null
                                ? Icon(IconsaxPlusLinear.user, size: tablet ? 60 : 40, color: Colors.grey.shade600)
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: tablet ? 4 : 0,
                          child: GestureDetector(
                            onTap: _pickAvatar,
                            child: Container(
                              padding: EdgeInsets.all(tablet ? 12 : 8),
                              decoration: const BoxDecoration(
                                gradient: AppColors.premiumGradient,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(IconsaxPlusLinear.camera, color: Colors.white, size: tablet ? 20 : 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: tablet ? 40 : 32),

                  TextFormField(
                    controller: _nameController,
                    maxLength: 30,
                    style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: fontSize),
                    decoration: InputDecoration(
                      labelText: 'profile.name_hint'.tr(),
                      labelStyle: TextStyle(fontSize: fontSize),
                      prefixIcon: Icon(IconsaxPlusLinear.user, size: tablet ? 28 : 24),
                      filled: true,
                      fillColor: AppColors.surface,
                      contentPadding: contentPadding,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (v) => v!.isEmpty ? 'profile.enter_name'.tr() : null,
                  ),
                  SizedBox(height: tablet ? 24 : 16),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _weightController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: fontSize),
                          decoration: InputDecoration(
                            labelText: 'profile.weight_hint'.tr(),
                            labelStyle: TextStyle(fontSize: fontSize),
                            prefixIcon: Icon(IconsaxPlusLinear.weight, size: tablet ? 28 : 24),
                            filled: true,
                            fillColor: AppColors.surface,
                            contentPadding: contentPadding,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (v) => (double.tryParse(v ?? '') ?? 0) <= 0 ? 'profile.error_value'.tr() : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _heightController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: fontSize),
                          decoration: InputDecoration(
                            labelText: 'profile.height_hint'.tr(),
                            labelStyle: TextStyle(fontSize: fontSize),
                            prefixIcon: Icon(IconsaxPlusLinear.ruler, size: tablet ? 28 : 24),
                            filled: true,
                            fillColor: AppColors.surface,
                            contentPadding: contentPadding,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (v) => (double.tryParse(v ?? '') ?? 0) <= 0 ? 'profile.error_value'.tr() : null,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: tablet ? 36 : 28),

                  Text(
                    'profile.your_goal'.tr(), 
                    style: TextStyle(fontSize: tablet ? 20 : 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  SizedBox(height: tablet ? 16 : 12),

                  SegmentedButton<UserGoal>(
                    style: SegmentedButton.styleFrom(
                      backgroundColor: AppColors.surface,
                      selectedBackgroundColor: AppColors.primary,
                      selectedForegroundColor: Colors.white,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: EdgeInsets.symmetric(vertical: tablet ? 16 : 8),
                    ),
                    segments: [
                      ButtonSegment(
                        value: UserGoal.loseWeight, 
                        label: FittedBox(fit: BoxFit.scaleDown, child: Text('profile.cut'.tr(), style: TextStyle(fontSize: tablet ? 18 : 14))),
                      ),
                      ButtonSegment(
                        value: UserGoal.maintain, 
                        label: FittedBox(fit: BoxFit.scaleDown, child: Text('profile.maintain'.tr(), style: TextStyle(fontSize: tablet ? 18 : 14))),
                      ),
                      ButtonSegment(
                        value: UserGoal.gainWeight, 
                        label: FittedBox(fit: BoxFit.scaleDown, child: Text('profile.bulk'.tr(), style: TextStyle(fontSize: tablet ? 18 : 14))),
                      ),
                    ],
                    selected: {_selectedGoal},
                    onSelectionChanged: (Set<UserGoal> newSelection) {
                      setState(() => _selectedGoal = newSelection.first);
                    },
                  ),
                  SizedBox(height: tablet ? 50 : 40),

                  Container(
                    height: tablet ? 65 : 56,
                    decoration: BoxDecoration(
                      gradient: AppColors.premiumGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(76),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                        'profile_setup.start'.tr(), 
                        style: TextStyle(fontSize: tablet ? 22 : 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}