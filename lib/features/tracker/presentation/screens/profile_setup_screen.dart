import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymhelper/features/tracker/presentation/cubit/tracker_cubit.dart';
import 'package:gymhelper/features/tracker/presentation/screens/main_screen.dart';
import '../../../../data/models/user_model.dart';


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

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final user = UserModel(
        name: _nameController.text.trim(),
        weight: double.parse(_weightController.text.trim()),
        height: double.parse(_heightController.text.trim()),
        goal: _selectedGoal,
      );

      // Зберігаємо юзера через Cubit
      context.read<TrackerCubit>().saveUserProfile(user);

      // Переходимо на головний екран і забороняємо повернення назад
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Введіть свої дані, щоб ми змогли розрахувати вашу ідеальну норму КБЖВ.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  TextFormField(
                    controller: _nameController,
                    maxLength: 30,
                    decoration: InputDecoration(
                      labelText: 'Ваше ім\'я або нікнейм',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
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
                          decoration: InputDecoration(
                            labelText: 'Вага (кг)',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          validator: (v) => (double.tryParse(v ?? '') ?? 0) <= 0 ? 'Помилка' : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _heightController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Зріст (см)',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          validator: (v) => (double.tryParse(v ?? '') ?? 0) <= 0 ? 'Помилка' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const Text('Ваша мета:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  SegmentedButton<UserGoal>(
                    segments: const [
                      ButtonSegment(value: UserGoal.loseWeight, label: Text('Сушка')),
                      ButtonSegment(value: UserGoal.maintain, label: Text('Підтримка')),
                      ButtonSegment(value: UserGoal.gainWeight, label: Text('Маса')),
                    ],
                    selected: {_selectedGoal},
                    onSelectionChanged: (Set<UserGoal> newSelection) {
                      setState(() => _selectedGoal = newSelection.first);
                    },
                  ),
                  const SizedBox(height: 40),

                  ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Почати', style: TextStyle(fontSize: 18)),
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