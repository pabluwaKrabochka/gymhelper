// ФАЙЛ: lib/features/transactions/presentation/screens/category_widgets/add_category_form.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymhelper/core/icon_constants.dart';
import 'package:gymhelper/features/transactions/presentation/cubit/transaction_cubit.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../data/models/category_model.dart';

class AddCategoryForm extends StatefulWidget {
  final CategoryModel? categoryToEdit;
  const AddCategoryForm({super.key, this.categoryToEdit});

  static void show(BuildContext context, [CategoryModel? categoryToEdit]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, 
      builder: (_) => BlocProvider.value(
        value: context.read<TransactionCubit>(),
        child: AddCategoryForm(categoryToEdit: categoryToEdit),
      ),
    );
  }

  @override
  State<AddCategoryForm> createState() => _AddCategoryFormState();
}

class _AddCategoryFormState extends State<AddCategoryForm> {
  // ДОДАНО: Ключ для форми
  final _formKey = GlobalKey<FormState>();
  
  late final TextEditingController _nameController;
  late String _type;
  late Color _selectedColor;
  IconData? _selectedIcon;

  final List<Color> _customColors = [
    Colors.red[300]!, Colors.red[500]!, Colors.red[700]!, Colors.pink[300]!, Colors.pink[500]!,
    Colors.purple[300]!, Colors.purple[500]!, Colors.deepPurple[400]!, Colors.deepPurple[600]!, Colors.indigo[400]!,
    Colors.indigo[600]!, Colors.blue[400]!, Colors.blue[600]!, Colors.lightBlue[400]!, Colors.cyan[500]!,
    
    Colors.teal[400]!, Colors.teal[600]!, Colors.green[400]!, Colors.green[600]!, Colors.lightGreen[500]!,
    Colors.lime[600]!, Colors.yellow[600]!, Colors.amber[500]!, Colors.amber[700]!, Colors.orange[400]!,
    Colors.orange[600]!, Colors.deepOrange[400]!, Colors.deepOrange[600]!, Colors.brown[400]!, Colors.brown[600]!,
    
    Colors.grey[500]!, Colors.grey[700]!, Colors.blueGrey[400]!, Colors.blueGrey[600]!, Colors.blueGrey[800]!,
    const Color(0xFFF472B6), const Color(0xFF818CF8), const Color(0xFF34D399), const Color(0xFFFBBF24), const Color(0xFFF87171),
    const Color(0xFFA78BFA), const Color(0xFF60A5FA), const Color(0xFF34D399), const Color(0xFFFCD34D), const Color(0xFF9CA3AF),
  ];

  @override
  void initState() {
    super.initState();
    final c = widget.categoryToEdit;
    _nameController = TextEditingController(text: c?.name ?? '');
    _type = c?.type ?? 'expense';
    _selectedColor = c != null ? Color(int.parse(c.colorHex)) : AppColors.expense;
    
    _selectedIcon = c != null 
      ? IconData(c.iconCode, fontFamily: c.iconCode > 0xe000 ? 'MaterialIcons' : 'IconsaxPlusLinear', fontPackage: c.iconCode > 0xe000 ? null : 'iconsax_plus') 
      : IconsaxPlusLinear.category;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _pickIcon() {
    String searchQuery = "";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredIcons = CategoryIcons.availableIcons.entries.where((entry) {
              if (searchQuery.isEmpty) return true;
              return entry.value.toLowerCase().contains(searchQuery.toLowerCase());
            }).toList();

            final isSearching = searchQuery.isNotEmpty;

            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 16),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.55,
                child: Column(
                  children: [
                    Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
                    const SizedBox(height: 20),
                    const Text('Оберіть іконку', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Наприклад: їжа, гроші, авто...',
                          hintStyle: const TextStyle(color: AppColors.textSecondary),
                          prefixIcon: const Icon(IconsaxPlusLinear.search_normal, color: AppColors.textSecondary),
                          suffixIcon: isSearching 
                            ? IconButton(icon: const Icon(IconsaxPlusLinear.close_circle, color: AppColors.textSecondary), onPressed: () => setModalState(() => searchQuery = ""))
                            : null,
                          filled: true,
                          fillColor: AppColors.background,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        ),
                        onChanged: (val) => setModalState(() => searchQuery = val),
                      ),
                    ),

                    Expanded(
                      child: isSearching 
                        ? GridView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisSpacing: 16, crossAxisSpacing: 16),
                            itemCount: filteredIcons.length,
                            itemBuilder: (context, index) {
                              return _buildIconTile(filteredIcons[index].key);
                            },
                          )
                        : DefaultTabController(
                            length: CategoryIcons.iconGroups.length, 
                            child: Column(
                              children: [
                                TabBar(
                                  isScrollable: true,
                                  tabAlignment: TabAlignment.start, 
                                  padding: EdgeInsets.zero,       
                                  indicatorColor: _selectedColor,
                                  labelColor: _selectedColor,
                                  unselectedLabelColor: AppColors.textSecondary.withAlpha(127),
                                  tabs: CategoryIcons.iconGroups.map((g) => Tab(icon: Icon(g['tabIcon'] as IconData, size: 28))).toList(),
                                ),
                                const SizedBox(height: 16),
                                Expanded(
                                  child: TabBarView(
                                    children: CategoryIcons.iconGroups.map((group) { 
                                      final icons = group['icons'] as List<IconData>;
                                      return GridView.builder(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisSpacing: 16, crossAxisSpacing: 16),
                                        itemCount: icons.length,
                                        itemBuilder: (context, index) => _buildIconTile(icons[index]),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildIconTile(IconData iconData) {
    final isSelected = _selectedIcon == iconData;
    return InkWell(
      onTap: () {
        setState(() => _selectedIcon = iconData);
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? _selectedColor.withAlpha(40) : AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? _selectedColor : Colors.transparent, width: 2),
        ),
        child: Icon(iconData, size: 28, color: isSelected ? _selectedColor : AppColors.textPrimary),
      ),
    );
  }

  void _pickColor() {
    PageController pageController = PageController();
    
    List<List<Color>> colorPages = [];
    for (var i = 0; i < _customColors.length; i += 15) {
      colorPages.add(_customColors.sublist(i, i + 15 > _customColors.length ? _customColors.length : i + 15));
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea( 
              child: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 20), 
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
                    const SizedBox(height: 20),
                    const Text('Колір категорії', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 24),
                    
                    SizedBox(
                      height: 240, 
                      child: PageView.builder(
                        controller: pageController,
                        onPageChanged: (index) => setModalState(() {}), 
                        itemCount: colorPages.length,
                        itemBuilder: (context, pageIndex) {
                          final pageColors = colorPages[pageIndex];
                          return GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5, 
                              mainAxisSpacing: 20, 
                              crossAxisSpacing: 20,
                              childAspectRatio: 1.0, 
                            ),
                            itemCount: pageColors.length,
                            itemBuilder: (context, index) {
                              final color = pageColors[index];
                              final isSelected = _selectedColor == color;
                              return GestureDetector(
                                onTap: () {
                                  setState(() => _selectedColor = color);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: isSelected ? AppColors.textPrimary : Colors.transparent, width: 3),
                                    boxShadow: [BoxShadow(color: color.withAlpha(102), blurRadius: 8, offset: const Offset(0, 4))],
                                  ),
                                  child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16), 
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(colorPages.length, (index) {
                        final isActive = pageController.hasClients && pageController.page?.round() == index || (!pageController.hasClients && index == 0);
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: isActive ? 24 : 8,
                          decoration: BoxDecoration(
                            color: isActive ? _selectedColor : Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _saveCategory() {
    // ДОДАНО: Перевірка валідації форми перед збереженням
    if (_formKey.currentState!.validate() && _selectedIcon != null) {
      final isEditing = widget.categoryToEdit != null;
      final newCategory = CategoryModel(
        id: isEditing ? widget.categoryToEdit!.id : null,
        name: _nameController.text.trim(), // Видаляємо зайві пробіли по краях
        iconCode: _selectedIcon!.codePoint,
        colorHex: '0x${_selectedColor.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}',
        type: _type,
      );
      
      if (isEditing) {
        context.read<TransactionCubit>().updateCategory(newCategory);
      } else {
        context.read<TransactionCubit>().addCategory(newCategory);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20, left: 24, right: 24, top: 12),
      // ДОДАНО: Обгортка Form для валідації
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 24),
            Text(widget.categoryToEdit == null ? 'Нова категорія' : 'Налаштування', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 24),
            
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'expense', label: Text('Витрата'), icon: Icon(IconsaxPlusLinear.minus_cirlce)),
                  ButtonSegment(value: 'income', label: Text('Дохід'), icon: Icon(IconsaxPlusLinear.add_circle)),
                ],
                selected: {_type},
                onSelectionChanged: (val) => setState(() => _type = val.first),
                style: SegmentedButton.styleFrom(
                  backgroundColor: Colors.white,
                  selectedBackgroundColor: AppColors.primary.withAlpha(25),
                  selectedForegroundColor: AppColors.primary,
                  side: BorderSide(color: Colors.grey.withAlpha(25)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ДОДАНО: TextFormField замість TextField + Тінь тепер не ламається при помилці
            Container(
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 10, offset: const Offset(0, 4))],
                borderRadius: BorderRadius.circular(16),
                color: Colors.white, // Фон перенесено сюди, щоб тінь виглядала коректно
              ),
              child: TextFormField(
                controller: _nameController,
                style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                // ДОДАНО: Автоматичне зняття помилки при введенні
                onChanged: (value) {
                  if (value.length == 1) {
                    _formKey.currentState!.validate(); 
                  }
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Введіть назву категорії';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Назва категорії',
                  hintStyle: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.normal),
                  contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  // Додаємо стиль для стану з помилкою
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16), 
                    borderSide: const BorderSide(color: AppColors.expense, width: 1.5)
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16), 
                    borderSide: const BorderSide(color: AppColors.expense, width: 1.5)
                  ),
                  errorStyle: const TextStyle(color: AppColors.expense, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _pickColor,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 8, offset: const Offset(0, 2))]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(backgroundColor: _selectedColor, radius: 12),
                          const SizedBox(width: 8),
                          const Text('Колір', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: _pickIcon,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 8, offset: const Offset(0, 2))]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(_selectedIcon, color: _selectedColor, size: 24),
                          const SizedBox(width: 8),
                          const Text('Іконка', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: _saveCategory,
                child: const Text('ЗБЕРЕГТИ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}