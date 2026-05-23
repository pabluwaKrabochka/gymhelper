import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyApiService {
  static const String _cacheKey = 'cached_currency_rates';

  Future<List<dynamic>> getPrivatRates() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final response = await http.get(
        Uri.parse('https://api.privatbank.ua/p24api/pubinfo?json&exchange&coursid=5'),
      );

      if (response.statusCode == 200) {
        // Якщо інтернет є, зберігаємо новий курс у кеш
        await prefs.setString(_cacheKey, response.body);
        return json.decode(response.body);
      }
    } catch (e) {
      // Якщо немає інтернету, читаємо з кешу
      final cachedData = prefs.getString(_cacheKey);
      if (cachedData != null) {
        return json.decode(cachedData);
      }
    }
    
    // Резервний варіант (якщо ніколи не було інтернету)
    return [
      {"ccy": "USD", "base_ccy": "UAH", "buy": "43.74", "sale": "44.24"},
      {"ccy": "EUR", "base_ccy": "UAH", "buy": "50.25", "sale": "50.75"}
    ];
  }
}