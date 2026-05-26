// База перевірених порад для кращого результату (Локалізована)
const Map<String, List<String>> healthTips = {
  'uk': [
    'Рівномірний розподіл: Організм найкраще засвоює білок, якщо розділити добову норму на 3–5 прийомів (приблизно по 25–40 г за один раз).',
    'Якість джерел: Віддавайте перевагу повноцінному тваринному білку (м\'ясо, риба, яйця, сир). Також враховуйте рослинний білок із бобових та злаків.',
    'Розрахунок: Пам\'ятайте, що вага продукту не дорівнює вазі чистого білка. Наприклад, 100 г курячого філе містить близько 23–30 г білка.',
    'Гідратація: Пийте достатньо води. М\'язи на 75% складаються з води, і навіть легке зневоднення знижує силові показники на 10-15%.',
    'Вуглеводи = Енергія: Складні вуглеводи (гречка, рис, овес) заповнюють запаси глікогену, який є основним паливом для важких тренувань.',
    'Корисні жири: Жири критично важливі для синтезу гормонів (зокрема тестостерону) та засвоєння вітамінів. Додавайте в раціон горіхи, авокадо, оливкову олію.',
    'Відновлення: М\'язи ростуть не під час тренування, а під час відпочинку. Здоровий 7-8 годинний сон — ваш головний анаболічний "інструмент".',
    'Прогресивне навантаження: Щоб м\'язи росли, поступово збільшуйте робочу вагу або кількість повторень. Організм швидко адаптується до рутини.',
    'Баланс калорій: Для схуднення потрібен лише дефіцит калорій, а для набору — профіцит. Жоден продукт сам по собі не "спалює жир".',
    'Системність: Жодне ідеальне тренування не перевершить регулярність. Краще 3 середніх тренування щотижня, ніж 1 ідеальне раз на місяць.',
  ],
  'en': [
    'Even distribution: The body absorbs protein best if the daily allowance is divided into 3-5 meals (approximately 25-40 g at a time).',
    'Source quality: Give preference to complete animal protein (meat, fish, eggs, cheese). Also consider plant protein from legumes and grains.',
    'Calculation: Remember that the weight of the product does not equal the weight of pure protein. For example, 100 g of chicken breast contains about 23-30 g of protein.',
    'Hydration: Drink enough water. Muscles are 75% water, and even mild dehydration reduces strength performance by 10-15%.',
    'Carbs = Energy: Complex carbohydrates (buckwheat, rice, oats) replenish glycogen stores, which are the main fuel for heavy workouts.',
    'Healthy fats: Fats are critically important for hormone synthesis (including testosterone) and vitamin absorption. Add nuts, avocado, and olive oil to your diet.',
    'Recovery: Muscles grow not during the workout, but during rest. A healthy 7-8 hours of sleep is your main anabolic "tool".',
    'Progressive overload: For muscles to grow, gradually increase the working weight or the number of reps. The body quickly adapts to a routine.',
    'Calorie balance: Weight loss only requires a calorie deficit, and weight gain requires a surplus. No single product "burns fat" on its own.',
    'Consistency: No perfect workout can beat regularity. Better to have 3 average workouts a week than 1 perfect one once a month.',
  ],
};