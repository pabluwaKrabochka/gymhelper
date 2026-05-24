import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymhelper/app/utils/custom_snackbar.dart';
import 'package:gymhelper/features/tracker/presentation/cubit/tracker_cubit.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart'; 
import '../../../../data/models/user_model.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/tips_database.dart'; 

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late UserGoal _selectedGoal;
  String? _avatarPath;

  int _currentTipIndex = 0; 

  @override
  void initState() {
    super.initState();
    final user = context.read<TrackerCubit>().state.user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _weightController = TextEditingController(text: user?.weight.toString() ?? '');
    _heightController = TextEditingController(text: user?.height.toString() ?? '');
    _selectedGoal = user?.goal ?? UserGoal.maintain;
    _avatarPath = user?.avatarPath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _changeTip() {
    setState(() {
      _currentTipIndex = (_currentTipIndex + 1) % healthTips.length;
    });
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
            toolbarTitle: 'Відцентрувати фото',
            toolbarColor: AppColors.primary,
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

      if (!mounted) return;

      if (croppedFile != null) {
        setState(() {
          _avatarPath = croppedFile.path;
        });
        context.read<TrackerCubit>().updateAvatar(croppedFile.path);
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
      
      CustomSnackbar.showSuccess(context, 'Профіль оновлено! Норми КБЖВ перераховані.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Мій профіль', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: _pickAvatar,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: _avatarPath != null 
                              ? FileImage(File(_avatarPath!)) 
                              : null,
                          child: _avatarPath == null
                              ? Icon(IconsaxPlusLinear.user, size: 50, color: Colors.grey.shade600)
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: GestureDetector(
                          onTap: _pickAvatar,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              gradient: AppColors.premiumGradient,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(IconsaxPlusLinear.camera, color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                GestureDetector(
                  onTap: _changeTip,
                  // ДОДАНО: AnimatedSize плавно змінює висоту всієї картки
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOutCubic, // М'який старт і м'яке гальмування
                    alignment: Alignment.topCenter, // Картка розширюється вниз
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: AppColors.cardGradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(12),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(IconsaxPlusBold.lamp_on, color: AppColors.primary),
                              const SizedBox(width: 8),
                              Text(
                                'Корисна порада',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary.withAlpha(180),
                                ),
                              ),
                              const Spacer(),
                              Icon(IconsaxPlusLinear.refresh, size: 16, color: AppColors.primary.withAlpha(120)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.0, 0.1), 
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: Text(
                              healthTips[_currentTipIndex],
                              key: ValueKey<int>(_currentTipIndex), 
                              style: const TextStyle(
                                fontSize: 14, 
                                height: 1.4, 
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                TextFormField(
                  controller: _nameController,
                  maxLength: 30,
                  style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    labelText: 'Ім\'я / Нікнейм',
                    prefixIcon: const Icon(IconsaxPlusLinear.user),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
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
                  'Ваша мета', 
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
                const SizedBox(height: 18),

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
                      'Зберегти зміни', 
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}