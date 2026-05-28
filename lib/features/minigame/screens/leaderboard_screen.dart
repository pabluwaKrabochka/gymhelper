import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/color_constants.dart';
import '../presentation/game_state.dart'; 
import 'ranks_info_screen.dart'; 

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late DateTime _selectedMonth;
  GameDifficulty _selectedDifficulty = GameDifficulty.medium;
  Timer? _countdownTimer;
  String _timeLeftString = '';

  List<Map<String, dynamic>> _allScores = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
    
    _loadScores();
    _updateCountdown();
    _countdownTimer = Timer.periodic(const Duration(minutes: 1), (_) => _updateCountdown());
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  // Допоміжна функція перевірки на планшет
  bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 600;

  Future<void> _loadScores() async {
    final prefs = await SharedPreferences.getInstance();
    final scoresJson = prefs.getStringList('game_scores') ?? [];
    
    final loadedScores = scoresJson.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
    
    setState(() {
      _allScores = loadedScores;
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> get _filteredScores {
    final filtered = _allScores.where((s) {
      final date = DateTime.parse(s['date']);
      final isSameMonth = date.year == _selectedMonth.year && date.month == _selectedMonth.month;
      final isSameDifficulty = s['difficulty'] == _selectedDifficulty.name;
      return isSameMonth && isSameDifficulty;
    }).toList();

    filtered.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));
    return filtered;
  }

  int get _highestScore {
    if (_filteredScores.isEmpty) {
      return 0;
    }
    return _filteredScores.first['score'] as int;
  }

  void _updateCountdown() {
    final now = DateTime.now();
    final nextMonth = now.month == 12 
        ? DateTime(now.year + 1, 1, 1) 
        : DateTime(now.year, now.month + 1, 1);
    
    final difference = nextMonth.difference(now);
    final days = difference.inDays;
    final hours = difference.inHours % 24;

    setState(() {
      _timeLeftString = 'game.days_hours'.tr(namedArgs: {'days': days.toString(), 'hours': hours.toString()});
    });
  }

  @override
  Widget build(BuildContext context) {
    final tablet = isTablet(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final hPadding = tablet ? screenWidth * 0.1 : 24.0; // Динамічний відступ по боках
    final maxWidth = tablet ? 500.0 : double.infinity;
    final fontSizeTabs = tablet ? 18.0 : 14.0;

    final isCurrentMonth = _selectedMonth.year == DateTime.now().year && _selectedMonth.month == DateTime.now().month;
    final monthFormatter = DateFormat('LLLL yyyy', context.locale.languageCode == 'en' ? 'en_US' : 'uk_UA');

    final scoresList = _filteredScores;
    final myRank = RankHelper.getRank(_highestScore);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('game.leaderboard'.tr(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: tablet ? 24 : 20)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: tablet ? hPadding : 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(IconsaxPlusLinear.arrow_square_left, size: tablet ? 28 : 24),
                    onPressed: () => setState(() => _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1)),
                  ),
                  Text(
                    monthFormatter.format(_selectedMonth).toUpperCase(),
                    style: TextStyle(fontSize: tablet ? 20 : 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(IconsaxPlusLinear.arrow_square_right, size: tablet ? 28 : 24),
                    onPressed: isCurrentMonth ? null : () => setState(() => _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1)),
                  ),
                ],
              ),
            ),

            if (isCurrentMonth)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.timer_outlined, color: AppColors.primary, size: tablet ? 24 : 20),
                    const SizedBox(width: 8),
                    Text(
                      '${'game.season_ends'.tr()} $_timeLeftString',
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: tablet ? 18 : 14),
                    ),
                  ],
                ),
              ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Center(
                child: SizedBox(
                  width: maxWidth,
                  child: SegmentedButton<GameDifficulty>(
                    style: SegmentedButton.styleFrom(
                      backgroundColor: AppColors.surface,
                      selectedBackgroundColor: AppColors.primary,
                      selectedForegroundColor: Colors.white,
                      side: BorderSide.none,
                      padding: EdgeInsets.symmetric(vertical: tablet ? 16 : 8),
                    ),
                    segments: [
                      ButtonSegment(
                        value: GameDifficulty.easy, 
                        label: FittedBox(fit: BoxFit.scaleDown, child: Text('game.easy'.tr(), style: TextStyle(fontSize: fontSizeTabs)))
                      ),
                      ButtonSegment(
                        value: GameDifficulty.medium, 
                        label: FittedBox(fit: BoxFit.scaleDown, child: Text('game.medium'.tr(), style: TextStyle(fontSize: fontSizeTabs)))
                      ),
                      ButtonSegment(
                        value: GameDifficulty.hard, 
                        label: FittedBox(fit: BoxFit.scaleDown, child: Text('game.hard'.tr(), style: TextStyle(fontSize: fontSizeTabs)))
                      ),
                    ],
                    selected: {_selectedDifficulty},
                    onSelectionChanged: (Set<GameDifficulty> newSelection) {
                      setState(() => _selectedDifficulty = newSelection.first);
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: tablet ? 24 : 16),

            // --- КАРТКА КОРИСТУВАЧА ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPadding),
              child: Container(
                padding: EdgeInsets.all(tablet ? 30 : 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [myRank.color, myRank.color.withAlpha(200)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: myRank.color.withAlpha(76), blurRadius: 15, offset: const Offset(0, 8))],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(tablet ? 16 : 12),
                      decoration: BoxDecoration(color: Colors.white.withAlpha(50), shape: BoxShape.circle),
                      child: Icon(myRank.icon, color: Colors.white, size: tablet ? 48 : 36),
                    ),
                    SizedBox(width: tablet ? 24 : 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('game.your_rank'.tr(), style: TextStyle(color: Colors.white70, fontSize: tablet ? 18 : 14)),
                          Text(
                            myRank.nameKey.tr(), 
                            style: TextStyle(color: Colors.white, fontSize: tablet ? 32 : 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.info_outline_rounded, color: Colors.white, size: tablet ? 36 : 24),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RanksInfoScreen())),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: tablet ? 32 : 24),

            // --- ТАБЛИЦЯ ЛІДЕРІВ ---
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
                    const SizedBox(height: 16),
                    Expanded(
                      child: _isLoading 
                        ? const Center(child: CircularProgressIndicator())
                        : scoresList.isEmpty
                          ? Center(
                              child: Text(
                                'game.no_games_this_month'.tr(),
                                style: TextStyle(color: AppColors.textSecondary, fontSize: tablet ? 20 : 16),
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: 8),
                              physics: const BouncingScrollPhysics(),
                              itemCount: scoresList.length,
                              itemBuilder: (context, index) {
                                final scoreData = scoresList[index];
                                final rankIndex = index + 1;
                                
                                final itemRank = RankHelper.getRank(scoreData['score']);
                                
                                Color medalColor = Colors.transparent;
                                if (rankIndex == 1) {
                                  medalColor = Colors.amber;
                                } else if (rankIndex == 2) {
                                  medalColor = Colors.grey.shade400;
                                } else if (rankIndex == 3) {
                                  medalColor = Colors.brown.shade300;
                                }

                                final date = DateTime.parse(scoreData['date']);
                                final dateStr = DateFormat('dd MMM, HH:mm', context.locale.languageCode == 'en' ? 'en_US' : 'uk_UA').format(date);

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: EdgeInsets.all(tablet ? 24 : 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: rankIndex <= 3 ? medalColor.withAlpha(150) : Colors.transparent, width: 2),
                                    boxShadow: [BoxShadow(color: Colors.grey.withAlpha(20), blurRadius: 10, offset: const Offset(0, 4))],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: tablet ? 50 : 40,
                                        height: tablet ? 50 : 40,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: itemRank.color.withAlpha(30),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(itemRank.icon, color: itemRank.color, size: tablet ? 28 : 22),
                                      ),
                                      SizedBox(width: tablet ? 24 : 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(itemRank.nameKey.tr(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: tablet ? 20 : 16)),
                                            Text(dateStr, style: TextStyle(color: Colors.grey, fontSize: tablet ? 14 : 12)),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '${scoreData['score']}',
                                        style: TextStyle(
                                          fontSize: tablet ? 28 : 22, 
                                          fontWeight: FontWeight.w900, 
                                          color: itemRank.color
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
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
  }
}