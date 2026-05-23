import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../data/models/category_model.dart';

class CategoryDropdownPicker extends StatefulWidget {
  final CategoryModel? selectedCategory;
  final List<CategoryModel> categories;
  final bool hasError;
  final ValueChanged<CategoryModel> onCategorySelected;

  const CategoryDropdownPicker({
    super.key,
    required this.selectedCategory,
    required this.categories,
    required this.hasError,
    required this.onCategorySelected,
  });

  @override
  State<CategoryDropdownPicker> createState() => _CategoryDropdownPickerState();
}

class _CategoryDropdownPickerState extends State<CategoryDropdownPicker> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    // Ховаємо клавіатуру, якщо вона відкрита
    FocusScope.of(context).unfocus();
    
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isOpen = false);
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Невидимий шар на весь екран для закриття меню при кліку повз
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeDropdown,
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),
          // Саме меню, прив'язане до інпута
          CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, size.height + 8), // Відступ 8px вниз від інпута
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: size.width,
                constraints: const BoxConstraints(maxHeight: 250), // Обмеження висоти
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: RawScrollbar(
                    thumbColor: Colors.grey.withAlpha(100),
                    radius: const Radius.circular(8),
                    thickness: 4,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true, // Щоб меню не було більшим, ніж треба
                      itemCount: widget.categories.length,
                      itemBuilder: (context, index) {
                        final category = widget.categories[index];
                        final catColor = Color(int.parse(category.colorHex));
                        final isSelected = widget.selectedCategory?.id == category.id;

                        return InkWell(
                          onTap: () {
                            widget.onCategorySelected(category);
                            _closeDropdown();
                          },
                          child: Container(
                            color: isSelected ? AppColors.primary.withAlpha(15) : Colors.transparent,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: catColor.withAlpha(40),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    IconData(category.iconCode, fontFamily: 'IconsaxPlusLinear', fontPackage: 'iconsax_plus'),
                                    color: catColor,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    category.name,
                                    style: TextStyle(
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                      color: AppColors.textPrimary,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: _toggleDropdown,
            child: Container(
              height: 64,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.hasError ? AppColors.expense : (_isOpen ? AppColors.primary : Colors.transparent),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                children: [
                  if (widget.selectedCategory != null) ...[
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Color(int.parse(widget.selectedCategory!.colorHex)).withAlpha(40),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        IconData(widget.selectedCategory!.iconCode, fontFamily: 'IconsaxPlusLinear', fontPackage: 'iconsax_plus'),
                        color: Color(int.parse(widget.selectedCategory!.colorHex)),
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.selectedCategory!.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                    ),
                  ] else ...[
                    const Icon(IconsaxPlusLinear.category_2, color: AppColors.textSecondary, size: 24),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text('Оберіть категорію', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
                    ),
                  ],
                  AnimatedRotation(
                    turns: _isOpen ? 0.5 : 0.0, // Стрілочка перевертається при відкритті
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(IconsaxPlusLinear.arrow_down_1, color: AppColors.textSecondary, size: 20),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.hasError)
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 8),
            child: Text(
              'Будь ласка, оберіть категорію',
              style: TextStyle(color: AppColors.expense, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
      ],
    );
  }
}