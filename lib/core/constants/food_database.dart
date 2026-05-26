class FoodItemData {
  final String nameUk;
  final String nameEn;
  final int calories;
  final double proteins;
  final double fats;
  final double carbs;

  const FoodItemData({
    required this.nameUk,
    required this.nameEn,
    required this.calories,
    required this.proteins,
    required this.fats,
    required this.carbs,
  });

  // Зручний геттер: віддає потрібну мову
  String getName(String langCode) {
    return langCode == 'en' ? nameEn : nameUk;
  }
}

// Велика локальна база продуктів (Двомовна)
const List<FoodItemData> foodDatabase = [
  // --- М'ЯСО ТА ПТИЦЯ ---
  FoodItemData(nameUk: 'Куряче філе (варене)', nameEn: 'Chicken breast (boiled)', calories: 165, proteins: 31.0, fats: 3.6, carbs: 0.0),
  FoodItemData(nameUk: 'Куряче філе (смажене/запечене)', nameEn: 'Chicken breast (roasted/baked)', calories: 195, proteins: 29.0, fats: 7.0, carbs: 0.0),
  FoodItemData(nameUk: 'Яловичина (пісна, варена)', nameEn: 'Beef (lean, boiled)', calories: 250, proteins: 26.0, fats: 15.0, carbs: 0.0),
  FoodItemData(nameUk: 'Свинина (нежирна, запечена)', nameEn: 'Pork (lean, baked)', calories: 271, proteins: 27.0, fats: 17.0, carbs: 0.0),
  FoodItemData(nameUk: 'Індичка (філе)', nameEn: 'Turkey (fillet)', calories: 147, proteins: 24.0, fats: 5.0, carbs: 0.0),
  
  // --- РИБА ТА МОРЕПРОДУКТИ ---
  FoodItemData(nameUk: 'Лосось (запечений)', nameEn: 'Salmon (baked)', calories: 206, proteins: 22.0, fats: 13.0, carbs: 0.0),
  FoodItemData(nameUk: 'Тунець (у власному соку)', nameEn: 'Tuna (in own juice)', calories: 101, proteins: 22.0, fats: 1.0, carbs: 0.0),
  FoodItemData(nameUk: 'Хек (відварений)', nameEn: 'Hake (boiled)', calories: 86, proteins: 16.6, fats: 2.2, carbs: 0.0),
  FoodItemData(nameUk: 'Креветки', nameEn: 'Shrimps', calories: 99, proteins: 24.0, fats: 0.3, carbs: 0.2),

  // --- КРУПИ, МАКАРОНИ ТА КАРТОПЛЯ ---
  FoodItemData(nameUk: 'Гречка (варена)', nameEn: 'Buckwheat (boiled)', calories: 132, proteins: 4.5, fats: 1.1, carbs: 27.0),
  FoodItemData(nameUk: 'Рис білий (варений)', nameEn: 'White rice (boiled)', calories: 130, proteins: 2.7, fats: 0.3, carbs: 28.0),
  FoodItemData(nameUk: 'Рис бурий (варений)', nameEn: 'Brown rice (boiled)', calories: 111, proteins: 2.6, fats: 0.9, carbs: 23.0),
  FoodItemData(nameUk: 'Вівсянка (суха)', nameEn: 'Oatmeal (dry)', calories: 389, proteins: 16.9, fats: 6.9, carbs: 66.3),
  FoodItemData(nameUk: 'Вівсянка (варена на воді)', nameEn: 'Oatmeal (boiled in water)', calories: 68, proteins: 2.4, fats: 1.2, carbs: 11.5),
  FoodItemData(nameUk: 'Макарони (відварені)', nameEn: 'Pasta (boiled)', calories: 158, proteins: 5.8, fats: 0.9, carbs: 31.0),
  FoodItemData(nameUk: 'Картопля (варена)', nameEn: 'Potato (boiled)', calories: 86, proteins: 2.0, fats: 0.1, carbs: 20.0),
  FoodItemData(nameUk: 'Картопля (запечена)', nameEn: 'Potato (baked)', calories: 93, proteins: 2.5, fats: 0.1, carbs: 21.0),
  FoodItemData(nameUk: 'Хліб цільнозерновий', nameEn: 'Whole grain bread', calories: 247, proteins: 13.0, fats: 4.0, carbs: 41.0),
  FoodItemData(nameUk: 'Хлібець хрусткий', nameEn: 'Crispbread', calories: 310, proteins: 11.0, fats: 2.0, carbs: 60.0),

  // --- ЯЙЦЯ ТА МОЛОЧНІ ПРОДУКТИ ---
  FoodItemData(nameUk: 'Яйце куряче (1 шт ~50г)', nameEn: 'Chicken egg (1 pc ~50g)', calories: 78, proteins: 6.3, fats: 5.3, carbs: 0.3),
  FoodItemData(nameUk: 'Яйце куряче (смажене 1 шт)', nameEn: 'Fried egg (1 pc)', calories: 90, proteins: 6.2, fats: 7.0, carbs: 0.4),
  FoodItemData(nameUk: 'Сир кисломолочний 5%', nameEn: 'Cottage cheese 5%', calories: 121, proteins: 21.2, fats: 5.0, carbs: 1.2),
  FoodItemData(nameUk: 'Сир кисломолочний 0%', nameEn: 'Cottage cheese 0%', calories: 71, proteins: 16.5, fats: 0.0, carbs: 1.3),
  FoodItemData(nameUk: 'Молоко 2.5%', nameEn: 'Milk 2.5%', calories: 54, proteins: 2.9, fats: 2.5, carbs: 4.8),
  FoodItemData(nameUk: 'Кефір 2.5%', nameEn: 'Kefir 2.5%', calories: 53, proteins: 2.9, fats: 2.5, carbs: 4.0),
  FoodItemData(nameUk: 'Твердий сир (Голландський)', nameEn: 'Hard cheese (Dutch)', calories: 350, proteins: 26.0, fats: 26.0, carbs: 0.0),

  // --- ОВОЧІ ---
  FoodItemData(nameUk: 'Огірок', nameEn: 'Cucumber', calories: 15, proteins: 0.8, fats: 0.1, carbs: 2.8),
  FoodItemData(nameUk: 'Помідор', nameEn: 'Tomato', calories: 18, proteins: 0.9, fats: 0.2, carbs: 3.9),
  FoodItemData(nameUk: 'Капуста білокачанна', nameEn: 'White cabbage', calories: 25, proteins: 1.3, fats: 0.1, carbs: 5.8),
  FoodItemData(nameUk: 'Броколі', nameEn: 'Broccoli', calories: 34, proteins: 2.8, fats: 0.4, carbs: 6.6),
  FoodItemData(nameUk: 'Морква', nameEn: 'Carrot', calories: 41, proteins: 0.9, fats: 0.2, carbs: 9.6),
  FoodItemData(nameUk: 'Перець солодкий', nameEn: 'Bell pepper', calories: 27, proteins: 1.3, fats: 0.0, carbs: 5.7),
  
  // --- ФРУКТИ, ЯГОДИ, ГОРІХИ ---
  FoodItemData(nameUk: 'Банан (без шкірки)', nameEn: 'Banana (peeled)', calories: 89, proteins: 1.1, fats: 0.3, carbs: 22.8),
  FoodItemData(nameUk: 'Яблуко', nameEn: 'Apple', calories: 52, proteins: 0.3, fats: 0.2, carbs: 13.8),
  FoodItemData(nameUk: 'Апельсин', nameEn: 'Orange', calories: 47, proteins: 0.9, fats: 0.1, carbs: 11.8),
  FoodItemData(nameUk: 'Авокадо', nameEn: 'Avocado', calories: 160, proteins: 2.0, fats: 14.7, carbs: 8.5),
  FoodItemData(nameUk: 'Полуниця', nameEn: 'Strawberry', calories: 33, proteins: 0.7, fats: 0.3, carbs: 7.7),
  FoodItemData(nameUk: 'Волоські горіхи', nameEn: 'Walnuts', calories: 654, proteins: 15.2, fats: 65.2, carbs: 13.7),
  FoodItemData(nameUk: 'Мигдаль', nameEn: 'Almonds', calories: 579, proteins: 21.1, fats: 49.9, carbs: 21.6),
];