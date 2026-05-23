import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../../../app/theme/app_colors.dart';

class AmountAndCurrencyInput extends StatelessWidget {
  final TextEditingController amountController;
  final String selectedCurrency;
  final Map<String, String> currencyData;
  final ValueChanged<String> onCurrencyChanged;
  final VoidCallback onClearAmount;

  const AmountAndCurrencyInput({
    super.key,
    required this.amountController,
    required this.selectedCurrency,
    required this.currencyData,
    required this.onCurrencyChanged,
    required this.onClearAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: TextFormField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: '0.00',
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                suffixIcon: amountController.text.isNotEmpty 
                  ? IconButton(
                      icon: const Icon(IconsaxPlusLinear.close_circle, color: Colors.grey, size: 20),
                      onPressed: onClearAmount,
                    ) 
                  : null,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Введіть суму';
                if (double.tryParse(value) == null) return 'Некоректне число';
                return null;
              },
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 68, 
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: PopupMenuButton<String>(
            position: PopupMenuPosition.under,
            initialValue: selectedCurrency,
            onSelected: onCurrencyChanged,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Colors.white,
            elevation: 10,
            itemBuilder: (context) => currencyData.entries.map((entry) {
              return PopupMenuItem<String>(
                value: entry.key,
                child: Text('${entry.key} - ${entry.value}', style: const TextStyle(fontWeight: FontWeight.bold)),
              );
            }).toList(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    selectedCurrency,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  const SizedBox(width: 4),
                  const Icon(IconsaxPlusLinear.arrow_down_1, color: AppColors.textSecondary, size: 18),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}