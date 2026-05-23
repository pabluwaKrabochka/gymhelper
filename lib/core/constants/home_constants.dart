import 'package:flutter/material.dart';

class HomeConstants {
  static const List<String> months = [
    'Січень', 'Лютий', 'Березень', 'Квітень', 'Травень', 'Червень', 
    'Липень', 'Серпень', 'Вересень', 'Жовтень', 'Листопад', 'Грудень'
  ];

  static const List<Map<String, dynamic>> banners = [
    {
      "title": "Безпека та Приватність",
      "description": "Ваші фінансові дані — це ваша приватна справа. Ми використовуємо локальне сховище SQLite, що означає, що всі записи зберігаються лише на вашому смартфоні. Ніяких серверів, ніяких хмар, повна конфіденційність.",
      "image": "assets/banner1.png",
   
      "alignment": Alignment.topRight,
      "size": 70.0,
      "isFullWidth": false
    },
    {
      "title": "Завжди під рукою",
      "description": "Додаток працює повністю в офлайн-режимі. Ви можете вносити транзакції в літаку, у метро чи за кордоном без доступу до інтернету. Ваші дані завжди доступні для перегляду та редагування.",
      "image": "assets/banner2.png",
     
      "alignment": Alignment.topLeft,
      "size": 85.0,
      "isFullWidth": false
    },
    {
      "title": "Розумна аналітика",
      "description": "Зручні діаграми дозволяють візуалізувати ваші витрати за будь-який період. Дізнайтеся, куди йдуть ваші гроші, та оптимізуйте свій бюджет за допомогою наочної статистики по категоріях.",
      "image": "assets/banner3.png",
  
      "alignment": Alignment.centerRight,
      "size": 90.0,
      "isFullWidth": false
    },
    {
      "title": "Майбутнє з AI Gemini",
      "description": "Працюємо над впровадженням штучного інтелекту Google Gemini. В майбутньому ви зможете отримувати персональні поради, автоматичні звіти та проводити глибокий аналіз бюджету за допомогою простих запитів.",
      "image": "assets/banner4.png",
      
      "alignment": Alignment.bottomCenter,
      "size": 100.0,
      "isFullWidth": true
    }
  ];
}