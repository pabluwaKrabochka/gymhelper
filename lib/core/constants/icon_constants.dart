// ФАЙЛ: lib/core/constants/category_icons.dart

import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class CategoryIcons {
  static final Map<IconData, String> availableIcons = {
    // 🍔 ЇЖА ТА НАПОЇ
    IconsaxPlusLinear.coffee: "кава чай напої кафе coffee tea",
    IconsaxPlusLinear.glass: "алкоголь бар вечірка drinks коктейль wine",
    IconsaxPlusLinear.milk: "молоко вода напої milk",
    IconsaxPlusLinear.cake: "торт солодощі десерт свято cake sweets",
    IconsaxPlusLinear.cup: "чашка напій cup",
    IconsaxPlusLinear.reserve: "ресторан кафе обід restaurant їжа",
    IconsaxPlusLinear.shop: "магазин кіоск крамниця shop store market",

    // 🛒 ШОПІНГ ТА ОДЯГ
    IconsaxPlusLinear.bag_2: "кошик покупки продукти basket bag пакет",
    IconsaxPlusLinear.shopping_bag: "шопінг пакет магазин покупки",
    IconsaxPlusLinear.tag: "цінник покупка шопінг tag",
    IconsaxPlusLinear.discount_shape: "знижка акція розпродаж discount",
    IconsaxPlusLinear.card: "кредитка оплата card",
    IconsaxPlusLinear.shopping_cart: "візок супермаркет shopping cart",

    // 🚗 ТРАНСПОРТ
    IconsaxPlusLinear.car: "авто машина транспорт таксі car taxi автомобіль",
    IconsaxPlusLinear.bus: "автобус маршрутка громадський транспорт bus",
    IconsaxPlusLinear.airplane: "подорожі літак відпустка flight travel тур",
    IconsaxPlusLinear.ship: "корабель човен море подорож ship boat",
    IconsaxPlusLinear.smart_car: "електромобіль авто car",
    IconsaxPlusLinear.gas_station: "паливо бензин заправка gas fuel азс",
    IconsaxPlusLinear.ticket: "квиток проїзд талон ticket pass",
    IconsaxPlusLinear.routing_2: "маршрут навігатор карта map route",

    // 🏠 ДІМ ТА КОМУНАЛКА
    IconsaxPlusLinear.home: "дім оренда житло квартира home house будинок",
    IconsaxPlusLinear.building: "квартира іпотека офіс building",
    IconsaxPlusLinear.flash: "електрика світло комуналка electricity",
    IconsaxPlusLinear.drop: "вода комуналка сантехніка water",
    IconsaxPlusLinear.wifi: "інтернет зв'язок телефон internet wifi вайфай",
    IconsaxPlusLinear.key: "ключ безпека оренда key",
    IconsaxPlusLinear.lamp: "світло декор ремонт lamp",
    IconsaxPlusLinear.moon: "ніч відпочинок сон moon",

    // 💊 ЗДОРОВ'Я ТА КРАСА
    IconsaxPlusLinear.health: "ліки аптека здоров'я лікар health медицина",
    IconsaxPlusLinear.heart: "здоров'я краса серце heart",
    IconsaxPlusLinear.activity: "пульс спорт здоров'я фітнес",
    IconsaxPlusLinear.scissor: "перукарня стрижка салон краса beauty",
    IconsaxPlusLinear.weight_1: "спорт вага дієта фітнес weight",

    // 🎮 РОЗВАГИ ТА ТЕХНІКА
    IconsaxPlusLinear.video: "кіно розваги фільми театр cinema movie",
    IconsaxPlusLinear.music: "музика концерт підписка music audio",
    IconsaxPlusLinear.camera: "фото техніка хобі photo camera",
    IconsaxPlusLinear.game: "ігри розваги дозвілля games console",
    IconsaxPlusLinear.brush_1: "мистецтво малювання творчість art",
    IconsaxPlusLinear.microphone_2: "караоке подкаст музика mic",
    IconsaxPlusLinear.headphone: "навушники аудіо музика music",
    IconsaxPlusLinear.monitor: "комп'ютер пк техніка pc monitor",
    IconsaxPlusLinear.mobile: "телефон смартфон зв'язок phone mobile",

    // 👨‍👩‍👧 СІМ'Я, РОБОТА, ІНШЕ
    IconsaxPlusLinear.user: "особисте я user",
    IconsaxPlusLinear.people: "сім'я друзі люди family",
    IconsaxPlusLinear.book: "книги література навчання education books",
    IconsaxPlusLinear.briefcase: "офіс робота кар'єра office work",
    IconsaxPlusLinear.box: "посилка коробка речі box",
    IconsaxPlusLinear.trash: "видалення сміття втрати trash",
    IconsaxPlusLinear.gift: "подарунок свято день народження gift презент",
    IconsaxPlusLinear.shield: "страховка захист безпека insurance",
    IconsaxPlusLinear.truck_fast: "доставка пошта кур'єр delivery",
    IconsaxPlusLinear.setting_2: "ремонт інструменти налаштування",

    // 💰 ФІНАНСИ
    IconsaxPlusLinear.money_2: "зарплата гроші дохід money salary готівка",
    IconsaxPlusLinear.wallet_1: "гаманець гроші витрати wallet",
    IconsaxPlusLinear.bank: "банківська карта банк рахунок card",
    IconsaxPlusLinear.receipt_2: "податки чеки квитанції tax чек",
    IconsaxPlusLinear.chart: "акції інвестиції ріст profit",
    IconsaxPlusLinear.coin: "монети крипта криптовалюта coin",
  };

  // ТЕМАТИЧНІ ВКЛАДКИ (Повністю на Iconsax)
  static final List<Map<String, dynamic>> iconGroups = [
    {
      'tabIcon': IconsaxPlusLinear.cup, // Їжа
      'icons': [IconsaxPlusLinear.coffee, IconsaxPlusLinear.glass, IconsaxPlusLinear.milk, IconsaxPlusLinear.cake, IconsaxPlusLinear.cup, IconsaxPlusLinear.reserve, IconsaxPlusLinear.shop]
    },
    {
      'tabIcon': IconsaxPlusLinear.bag_2, // Шопінг
      'icons': [IconsaxPlusLinear.bag_2, IconsaxPlusLinear.shopping_bag, IconsaxPlusLinear.tag, IconsaxPlusLinear.discount_shape, IconsaxPlusLinear.card, IconsaxPlusLinear.shopping_cart]
    },
    {
      'tabIcon': IconsaxPlusLinear.car, // Транспорт
      'icons': [IconsaxPlusLinear.car, IconsaxPlusLinear.bus, IconsaxPlusLinear.airplane, IconsaxPlusLinear.ship, IconsaxPlusLinear.smart_car, IconsaxPlusLinear.gas_station, IconsaxPlusLinear.ticket, IconsaxPlusLinear.routing_2]
    },
    {
      'tabIcon': IconsaxPlusLinear.home, // Дім
      'icons': [IconsaxPlusLinear.home, IconsaxPlusLinear.building, IconsaxPlusLinear.flash, IconsaxPlusLinear.drop, IconsaxPlusLinear.wifi, IconsaxPlusLinear.key, IconsaxPlusLinear.lamp, IconsaxPlusLinear.moon]
    },
    {
      'tabIcon': IconsaxPlusLinear.heart, // Здоров'я
      'icons': [IconsaxPlusLinear.health, IconsaxPlusLinear.heart, IconsaxPlusLinear.activity, IconsaxPlusLinear.scissor, IconsaxPlusLinear.weight_1]
    },
    {
      'tabIcon': IconsaxPlusLinear.game, // Розваги
      'icons': [IconsaxPlusLinear.video, IconsaxPlusLinear.music, IconsaxPlusLinear.camera, IconsaxPlusLinear.game, IconsaxPlusLinear.brush_1, IconsaxPlusLinear.microphone_2, IconsaxPlusLinear.headphone, IconsaxPlusLinear.monitor, IconsaxPlusLinear.mobile]
    },
    {
      'tabIcon': IconsaxPlusLinear.people, // Сім'я/Робота
      'icons': [IconsaxPlusLinear.user, IconsaxPlusLinear.people, IconsaxPlusLinear.book, IconsaxPlusLinear.briefcase, IconsaxPlusLinear.box, IconsaxPlusLinear.trash, IconsaxPlusLinear.gift, IconsaxPlusLinear.shield, IconsaxPlusLinear.truck_fast, IconsaxPlusLinear.setting_2]
    },
    {
      'tabIcon': IconsaxPlusLinear.wallet_1, // Фінанси
      'icons': [IconsaxPlusLinear.money_2, IconsaxPlusLinear.wallet_1, IconsaxPlusLinear.bank, IconsaxPlusLinear.receipt_2, IconsaxPlusLinear.chart, IconsaxPlusLinear.coin]
    },
  ];
}