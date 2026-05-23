import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymhelper/features/tracker/presentation/cubit/tracker_cubit.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../data/models/user_model.dart';
import '../../../../core/constants/color_constants.dart'; // Обов'язково перевір цей імпорт під свій шлях

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
  Timer? _tipTimer;

  final List<String> _tips = [
    'Рівномірний розподіл: Організм найкраще засвоює білок, якщо розділити добову норму на 3–5 прийомів (приблизно по 25–40 г за один раз).',
    'Якість джерел: Віддавайте перевагу повноцінному тваринному білку (м\'ясо, риба, яйця, сир). Також враховуйте рослинний білок із бобових та злаків.',
    'Розрахунок: Пам\'ятайте, що вага продукту не дорівнює вазі чистого білка. Наприклад, 100 г курячого філе містить близько 23–30 г білка.'
  ];

  @override
  void initState() {
    super.initState();
    final user = context.read<TrackerCubit>().state.user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _weightController = TextEditingController(text: user?.weight.toString() ?? '');
    _heightController = TextEditingController(text: user?.height.toString() ?? '');
    _selectedGoal = user?.goal ?? UserGoal.maintain;
    _avatarPath = user?.avatarPath;

    _tipTimer = Timer.periodic(const Duration(seconds: 7), (timer) {
      if (mounted) {
        setState(() {
          _currentTipIndex = (_currentTipIndex + 1) % _tips.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _tipTimer?.cancel();
    super.dispose();
  }

  // Метод для вибору зображення з галереї
  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    
    if (pickedFile != null) {
      setState(() {
        _avatarPath = pickedFile.path;
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final user = UserModel(
        name: _nameController.text.trim(),
        weight: double.parse(_weightController.text.trim()),
        height: double.parse(_heightController.text.trim()),
        goal: _selectedGoal,
        avatarPath: _avatarPath, // Додаємо шлях до обраної аватарки в модель
      );

      context.read<TrackerCubit>().saveUserProfile(user);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Профіль оновлено! Норми КБЖВ перераховані.')),
      );
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
                // Блок Аватарки користувача
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

                // Блок з порадами (Градієнтний стиль)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    key: ValueKey<int>(_currentTipIndex),
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(IconsaxPlusBold.lamp_on, color: AppColors.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _tips[_currentTipIndex],
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
                const SizedBox(height: 30),

                // Поля вводу тексту
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

                // Оновлена кнопка вибору мети із FittedBox проти вилізання тексту
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

                // Красива градієнтна кнопка збереження запису
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