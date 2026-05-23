import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymhelper/features/tracker/presentation/cubit/tracker_cubit.dart';
import 'package:gymhelper/features/tracker/presentation/screens/main_screen.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart'; // НОВИЙ ІМПОРТ

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

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  // ОНОВЛЕНИЙ МЕТОД З ОБРІЗКОЮ ФОТО
  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    
    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1), // Квадрат
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Відцентрувати фото',
            toolbarColor: AppColors.accent,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            hideBottomControls: true,
          ),
          IOSUiSettings(
            title: 'Відцентрувати фото',
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
    return Scaffold(
      backgroundColor: AppColors.background, 
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Давайте знайомитись! 👋',
                    style: TextStyle(
                      fontSize: 28, 
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Введіть свої дані, щоб ми змогли розрахувати вашу ідеальну норму КБЖВ.',
                    style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  Center(
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: _pickAvatar,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage: _avatarPath != null 
                                ? FileImage(File(_avatarPath!)) 
                                : null,
                            child: _avatarPath == null
                                ? Icon(IconsaxPlusLinear.user, size: 40, color: Colors.grey.shade600)
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickAvatar,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                gradient: AppColors.premiumGradient,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(IconsaxPlusLinear.camera, color: Colors.white, size: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  TextFormField(
                    controller: _nameController,
                    maxLength: 30,
                    style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      labelText: 'Ваше ім\'я або нікнейм',
                      prefixIcon: const Icon(IconsaxPlusLinear.user),
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (v) => v!.isEmpty ? 'Введіть ім\'я' : null,
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _weightController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                          decoration: InputDecoration(
                            labelText: 'Вага (кг)',
                            prefixIcon: const Icon(IconsaxPlusLinear.weight),
                            filled: true,
                            fillColor: AppColors.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (v) => (double.tryParse(v ?? '') ?? 0) <= 0 ? 'Помилка' : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _heightController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                          decoration: InputDecoration(
                            labelText: 'Зріст (см)',
                            prefixIcon: const Icon(IconsaxPlusLinear.ruler),
                            filled: true,
                            fillColor: AppColors.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (v) => (double.tryParse(v ?? '') ?? 0) <= 0 ? 'Помилка' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  const Text(
                    'Ваша мета:', 
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 12),

                  SegmentedButton<UserGoal>(
                    style: SegmentedButton.styleFrom(
                      backgroundColor: AppColors.surface,
                      selectedBackgroundColor: AppColors.primary,
                      selectedForegroundColor: Colors.white,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    segments: const [
                      ButtonSegment(
                        value: UserGoal.loseWeight, 
                        label: FittedBox(fit: BoxFit.scaleDown, child: Text('Сушка')),
                      ),
                      ButtonSegment(
                        value: UserGoal.maintain, 
                        label: FittedBox(fit: BoxFit.scaleDown, child: Text('Підтримка')),
                      ),
                      ButtonSegment(
                        value: UserGoal.gainWeight, 
                        label: FittedBox(fit: BoxFit.scaleDown, child: Text('Маса')),
                      ),
                    ],
                    selected: {_selectedGoal},
                    onSelectionChanged: (Set<UserGoal> newSelection) {
                      setState(() => _selectedGoal = newSelection.first);
                    },
                  ),
                  const SizedBox(height: 40),

                  Container(
                    height: 56,
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
                      child: const Text(
                        'Почати', 
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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