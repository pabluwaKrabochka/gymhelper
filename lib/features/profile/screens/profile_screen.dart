import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ВАЖЛИВО ДЛЯ FilteringTextInputFormatter
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymhelper/app/utils/custom_snackbar.dart';
import 'package:gymhelper/features/tracker/presentation/cubit/tracker_cubit.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart'; 
import 'package:easy_localization/easy_localization.dart'; 
import '../../../data/models/user_model.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/tips_database.dart'; 

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  UserModel? _originalUser;

  late TextEditingController _nameController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late UserGoal _selectedGoal;
  String? _avatarPath;

  int _currentTipIndex = 0; 

  // Допоміжна функція для визначення розміру екрану
  bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 600;

  @override
  void initState() {
    super.initState();
    _originalUser = context.read<TrackerCubit>().state.user;
    
    // Якщо вага/зріст цілі (напр. 80.0), прибираємо дробову частину для зручності
    final initialWeight = _originalUser?.weight.toInt().toString() ?? '';
    final initialHeight = _originalUser?.height.toInt().toString() ?? '';

    _nameController = TextEditingController(text: _originalUser?.name ?? '');
    _weightController = TextEditingController(text: initialWeight);
    _heightController = TextEditingController(text: initialHeight);
    _selectedGoal = _originalUser?.goal ?? UserGoal.maintain;
    _avatarPath = _originalUser?.avatarPath;

    _nameController.addListener(_onFieldChanged);
    _weightController.addListener(_onFieldChanged);
    _heightController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onFieldChanged);
    _weightController.removeListener(_onFieldChanged);
    _heightController.removeListener(_onFieldChanged);
    
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    setState(() {});
  }

  bool get _hasChanges {
    if (_originalUser == null) return true;

    final currentName = _nameController.text.trim();
    final currentWeight = double.tryParse(_weightController.text.trim()) ?? 0.0;
    final currentHeight = double.tryParse(_heightController.text.trim()) ?? 0.0;

    return currentName != _originalUser!.name ||
           currentWeight != _originalUser!.weight ||
           currentHeight != _originalUser!.height ||
           _selectedGoal != _originalUser!.goal ||
           _avatarPath != _originalUser!.avatarPath;
  }

  void _changeTip() {
    setState(() {
      final tipsList = healthTips[context.locale.languageCode] ?? healthTips['uk']!;
      _currentTipIndex = (_currentTipIndex + 1) % tipsList.length;
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
            toolbarTitle: 'profile.center_photo'.tr(), 
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
    if (_formKey.currentState!.validate() && _hasChanges) {
      final user = UserModel(
        name: _nameController.text.trim(),
        // Поля тепер приймають тільки цифри, тому parse безпечний
        weight: double.parse(_weightController.text.trim()),
        height: double.parse(_heightController.text.trim()),
        goal: _selectedGoal,
        avatarPath: _avatarPath, 
      );

      context.read<TrackerCubit>().saveUserProfile(user);
      
      setState(() {
        _originalUser = user; 
      });
      
      CustomSnackbar.showSuccess(context, 'profile.profile_updated'.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    final tablet = isTablet(context);
    final screenWidth = MediaQuery.of(context).size.width;
    
    final horizontalPadding = tablet ? screenWidth * 0.15 : 24.0;
    final contentPadding = EdgeInsets.symmetric(vertical: tablet ? 20 : 16, horizontal: 16);
    final fontSize = tablet ? 18.0 : 16.0;
    final smallFontSize = tablet ? 16.0 : 13.0; // Зменшений шрифт для підписів полів в рядку

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('profile.title'.tr(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: tablet ? 24 : 20)), 
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: tablet ? 20.0 : 10.0),
          physics: const BouncingScrollPhysics(),
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
                          radius: tablet ? 80 : 60,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: _avatarPath != null ? FileImage(File(_avatarPath!)) : null,
                          child: _avatarPath == null ? Icon(IconsaxPlusLinear.user, size: tablet ? 70 : 50, color: Colors.grey.shade600) : null,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: tablet ? 8 : 4,
                        child: GestureDetector(
                          onTap: _pickAvatar,
                          child: Container(
                            padding: EdgeInsets.all(tablet ? 12 : 8),
                            decoration: BoxDecoration(gradient: AppColors.premiumGradient, shape: BoxShape.circle),
                            child: Icon(IconsaxPlusLinear.camera, color: Colors.white, size: tablet ? 24 : 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: tablet ? 32 : 24),

                GestureDetector(
                  onTap: _changeTip,
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOutCubic,
                    alignment: Alignment.topCenter,
                    child: Container(
                      padding: EdgeInsets.all(tablet ? 24 : 16),
                      decoration: BoxDecoration(
                        gradient: AppColors.cardGradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: AppColors.primary.withAlpha(12), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(IconsaxPlusBold.lamp_on, color: AppColors.primary, size: tablet ? 32 : 24),
                              const SizedBox(width: 8),
                              Text(
                                'profile.health_tip'.tr(), 
                                style: TextStyle(fontSize: tablet ? 14 : 12, fontWeight: FontWeight.bold, color: AppColors.primary.withAlpha(180)),
                              ),
                              const Spacer(),
                              Icon(IconsaxPlusLinear.refresh, size: tablet ? 20 : 16, color: AppColors.primary.withAlpha(120)),
                            ],
                          ),
                          SizedBox(height: tablet ? 16 : 12),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(begin: const Offset(0.0, 0.1), end: Offset.zero).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: Text(
                              healthTips[context.locale.languageCode]![_currentTipIndex],
                              key: ValueKey<String>('${context.locale.languageCode}_$_currentTipIndex'), 
                              style: TextStyle(fontSize: tablet ? 18 : 14, height: 1.4, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: tablet ? 40 : 30),

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
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                  validator: (v) => v!.isEmpty ? 'profile.enter_name'.tr() : null, 
                ),
                SizedBox(height: tablet ? 24 : 16),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // Вирівнюємо по верхньому краю для помилок
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: fontSize),
                        decoration: InputDecoration(
                          counterText: '', // Ховаємо лічильник символів
                          labelText: 'profile.weight_hint'.tr(), 
                          labelStyle: TextStyle(fontSize: smallFontSize),
                          prefixIcon: Icon(IconsaxPlusLinear.weight, size: tablet ? 28 : 22),
                          filled: true,
                          fillColor: AppColors.surface,
                          contentPadding: contentPadding,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'profile.err_empty'.tr();
                          if (v.length < 2) return 'profile.err_min_chars'.tr();
                          
                          final val = int.tryParse(v);
                          if (val == null) return 'profile.err_empty'.tr();
                          if (val < 30 || val > 190) return 'profile.err_weight_range'.tr();
                          
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _heightController,
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: fontSize),
                        decoration: InputDecoration(
                          counterText: '', // Ховаємо лічильник символів
                          labelText: 'profile.height_hint'.tr(), 
                          labelStyle: TextStyle(fontSize: smallFontSize),
                          prefixIcon: Icon(IconsaxPlusLinear.ruler, size: tablet ? 28 : 22),
                          filled: true,
                          fillColor: AppColors.surface,
                          contentPadding: contentPadding,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'profile.err_empty'.tr();
                          if (v.length < 2) return 'profile.err_min_chars'.tr();
                          
                          final val = int.tryParse(v);
                          if (val == null) return 'profile.err_empty'.tr();
                          if (val < 100 || val > 250) return 'profile.err_height_range'.tr();
                          
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: tablet ? 40 : 28),

                Text('profile.your_goal'.tr(), style: TextStyle(fontSize: tablet ? 20 : 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)), 
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
                SizedBox(height: tablet ? 32 : 18),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: tablet ? 65 : 56,
                  decoration: BoxDecoration(
                    gradient: _hasChanges ? AppColors.premiumGradient : null,
                    color: _hasChanges ? null : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: _hasChanges 
                        ? [BoxShadow(color: AppColors.primary.withAlpha(76), blurRadius: 12, offset: const Offset(0, 4))] 
                        : [],
                  ),
                  child: ElevatedButton(
                    onPressed: _hasChanges ? _saveProfile : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      disabledBackgroundColor: Colors.transparent, 
                      disabledForegroundColor: Colors.grey.shade600,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      'profile.save_changes'.tr(), 
                      style: TextStyle(fontSize: tablet ? 22 : 18, fontWeight: FontWeight.bold, color: _hasChanges ? Colors.white : Colors.grey.shade500)
                    ),
                  ),
                ),
                const SizedBox(height: 90), 
              ],
            ),
          ),
        ),
      ),
    );
  }
}