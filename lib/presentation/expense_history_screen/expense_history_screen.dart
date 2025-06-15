import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_filter_bottom_sheet.dart';
import './widgets/expense_history_card_widget.dart';
import './widgets/expense_type_filter_widget.dart';
import './widgets/period_filter_widget.dart';

class ExpenseHistoryScreen extends StatefulWidget {
  const ExpenseHistoryScreen({super.key});

  @override
  State<ExpenseHistoryScreen> createState() => _ExpenseHistoryScreenState();
}

class _ExpenseHistoryScreenState extends State<ExpenseHistoryScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = false;
  bool _isSearching = false;
  bool _isMultiSelectMode = false;
  String _selectedPeriod = 'день';
  String _selectedExpenseType = 'все';
  List<String> _selectedCategories = [];
  List<int> _selectedExpenseIds = [];
  String _searchQuery = '';

  // Mock data for expenses
  final List<Map<String, dynamic>> _allExpenses = [
    {
      "id": 1,
      "amount": 1250.50,
      "currency": "₽",
      "category": "Продукты",
      "subcategory": "Овощи и фрукты",
      "date": DateTime.now().subtract(const Duration(hours: 2)),
      "isIrregular": false,
      "notes": "Покупка в Пятёрочке",
      "categoryColor": const Color(0xFF4CAF50),
    },
    {
      "id": 2,
      "amount": 850.00,
      "currency": "₽",
      "category": "Питание вне дома",
      "subcategory": "Кафе",
      "date": DateTime.now().subtract(const Duration(hours: 5)),
      "isIrregular": false,
      "notes": "Обед с коллегами",
      "categoryColor": const Color(0xFFFF9800),
    },
    {
      "id": 3,
      "amount": 2500.00,
      "currency": "₽",
      "category": "Транспорт",
      "subcategory": "Такси",
      "date": DateTime.now().subtract(const Duration(days: 1)),
      "isIrregular": true,
      "notes": "Поездка в аэропорт",
      "categoryColor": const Color(0xFF2196F3),
    },
    {
      "id": 4,
      "amount": 3200.00,
      "currency": "₽",
      "category": "Здоровье",
      "subcategory": "Лекарства",
      "date": DateTime.now().subtract(const Duration(days: 2)),
      "isIrregular": false,
      "notes": "Аптека 36.6",
      "categoryColor": const Color(0xFFF44336),
    },
    {
      "id": 5,
      "amount": 1800.00,
      "currency": "₽",
      "category": "Развлечения",
      "subcategory": "Кино",
      "date": DateTime.now().subtract(const Duration(days: 3)),
      "isIrregular": false,
      "notes": "Билеты в кинотеатр",
      "categoryColor": const Color(0xFF9C27B0),
    },
    {
      "id": 6,
      "amount": 4500.00,
      "currency": "₽",
      "category": "Одежда",
      "subcategory": "Обувь",
      "date": DateTime.now().subtract(const Duration(days: 4)),
      "isIrregular": true,
      "notes": "Новые кроссовки",
      "categoryColor": const Color(0xFFE91E63),
    },
    {
      "id": 7,
      "amount": 750.00,
      "currency": "₽",
      "category": "Дети",
      "subcategory": "Игрушки",
      "date": DateTime.now().subtract(const Duration(days: 5)),
      "isIrregular": false,
      "notes": "Подарок для сына",
      "categoryColor": const Color(0xFF03A9F4),
    },
    {
      "id": 8,
      "amount": 1200.00,
      "currency": "₽",
      "category": "Связь",
      "subcategory": "Мобильная связь",
      "date": DateTime.now().subtract(const Duration(days: 6)),
      "isIrregular": false,
      "notes": "Пополнение баланса",
      "categoryColor": const Color(0xFF607D8B),
    },
    {
      "id": 9,
      "amount": 650.00,
      "currency": "₽",
      "category": "Табак",
      "subcategory": "Сигареты",
      "date": DateTime.now().subtract(const Duration(days: 7)),
      "isIrregular": false,
      "notes": "Покупка в магазине",
      "categoryColor": const Color(0xFF795548),
    },
    {
      "id": 10,
      "amount": 2200.00,
      "currency": "₽",
      "category": "Прочее",
      "subcategory": "Разное",
      "date": DateTime.now().subtract(const Duration(days: 8)),
      "isIrregular": true,
      "notes": "Непредвиденные расходы",
      "categoryColor": const Color(0xFF424242),
    },
  ];

  List<Map<String, dynamic>> _filteredExpenses = [];
  List<Map<String, dynamic>> _displayedExpenses = [];
  bool _showAllRecords = false;

  @override
  void initState() {
    super.initState();
    _filteredExpenses = List.from(_allExpenses);
    _updateDisplayedExpenses();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreExpenses();
    }
  }

  void _loadMoreExpenses() {
    if (!_isLoading && !_showAllRecords) {
      setState(() {
        _isLoading = true;
      });

      // Simulate loading delay
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _showAllRecords = true;
            _updateDisplayedExpenses();
          });
        }
      });
    }
  }

  void _updateDisplayedExpenses() {
    List<Map<String, dynamic>> filtered = List.from(_filteredExpenses);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((expense) {
        final amount = expense['amount'].toString();
        final category = (expense['category'] as String).toLowerCase();
        final subcategory = (expense['subcategory'] as String).toLowerCase();
        final notes = (expense['notes'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();

        return amount.contains(query) ||
            category.contains(query) ||
            subcategory.contains(query) ||
            notes.contains(query);
      }).toList();
    }

    // Apply category filter
    if (_selectedCategories.isNotEmpty) {
      filtered = filtered.where((expense) {
        return _selectedCategories.contains(expense['category']);
      }).toList();
    }

    // Apply expense type filter
    if (_selectedExpenseType != 'все') {
      filtered = filtered.where((expense) {
        if (_selectedExpenseType == 'обычные') {
          return !(expense['isIrregular'] as bool);
        } else if (_selectedExpenseType == 'нерегулярные') {
          return expense['isIrregular'] as bool;
        }
        return true;
      }).toList();
    }

    // Apply period filter (simplified for demo)
    // In real app, this would filter by actual date ranges

    setState(() {
      _filteredExpenses = filtered;
      if (_showAllRecords) {
        _displayedExpenses = filtered;
      } else {
        _displayedExpenses = filtered.take(15).toList();
      }
    });
  }

  void _onPeriodChanged(String period) {
    setState(() {
      _selectedPeriod = period;
    });
    _updateDisplayedExpenses();
  }

  void _onExpenseTypeChanged(String type) {
    setState(() {
      _selectedExpenseType = type;
    });
    _updateDisplayedExpenses();
  }

  void _onCategoriesChanged(List<String> categories) {
    setState(() {
      _selectedCategories = categories;
    });
    _updateDisplayedExpenses();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _updateDisplayedExpenses();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
        _updateDisplayedExpenses();
      }
    });
  }

  void _onExpenseLongPress(int expenseId) {
    HapticFeedback.mediumImpact();
    setState(() {
      _isMultiSelectMode = true;
      _selectedExpenseIds = [expenseId];
    });
  }

  void _onExpenseSelected(int expenseId, bool selected) {
    setState(() {
      if (selected) {
        _selectedExpenseIds.add(expenseId);
      } else {
        _selectedExpenseIds.remove(expenseId);
      }

      if (_selectedExpenseIds.isEmpty) {
        _isMultiSelectMode = false;
      }
    });
  }

  void _exitMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = false;
      _selectedExpenseIds.clear();
    });
  }

  void _deleteSelectedExpenses() {
    setState(() {
      _allExpenses.removeWhere(
          (expense) => _selectedExpenseIds.contains(expense['id']));
      _isMultiSelectMode = false;
      _selectedExpenseIds.clear();
    });
    _updateDisplayedExpenses();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Расходы удалены'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onExpenseEdit(int expenseId) {
    // Navigate to edit screen or show edit dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Редактирование расхода #$expenseId'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onExpenseDelete(int expenseId) {
    setState(() {
      _allExpenses.removeWhere((expense) => expense['id'] == expenseId);
    });
    _updateDisplayedExpenses();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Расход удален'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _onRefresh() async {
    HapticFeedback.lightImpact();

    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _showAllRecords = false;
    });
    _updateDisplayedExpenses();
  }

  void _showCategoryFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CategoryFilterBottomSheet(
        selectedCategories: _selectedCategories,
        onCategoriesChanged: _onCategoriesChanged,
      ),
    );
  }

  void _displayAllRecords() {
    setState(() {
      _showAllRecords = true;
    });
    _updateDisplayedExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _isMultiSelectMode ? null : _buildFAB(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    if (_isMultiSelectMode) {
      return AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: Colors.white,
        title: Text('Выбрано: ${_selectedExpenseIds.length}'),
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'close',
            color: Colors.white,
            size: 24,
          ),
          onPressed: _exitMultiSelectMode,
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'delete',
              color: Colors.white,
              size: 24,
            ),
            onPressed:
                _selectedExpenseIds.isNotEmpty ? _deleteSelectedExpenses : null,
          ),
        ],
      );
    }

    return AppBar(
      backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
      foregroundColor: AppTheme.lightTheme.appBarTheme.foregroundColor,
      elevation: AppTheme.lightTheme.appBarTheme.elevation,
      title: _isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Поиск расходов...',
                border: InputBorder.none,
              ),
              onChanged: _onSearchChanged,
            )
          : const Text('История расходов'),
      actions: [
        IconButton(
          icon: CustomIconWidget(
            iconName: _isSearching ? 'close' : 'search',
            color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
            size: 24,
          ),
          onPressed: _toggleSearch,
        ),
        IconButton(
          icon: CustomIconWidget(
            iconName: 'filter_list',
            color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
            size: 24,
          ),
          onPressed: _showCategoryFilter,
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildFilters(),
        Expanded(
          child: _displayedExpenses.isEmpty
              ? _buildEmptyState()
              : _buildExpenseList(),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Container(
      color: AppTheme.lightTheme.colorScheme.surface,
      child: Column(
        children: [
          PeriodFilterWidget(
            selectedPeriod: _selectedPeriod,
            onPeriodChanged: _onPeriodChanged,
          ),
          ExpenseTypeFilterWidget(
            selectedType: _selectedExpenseType,
            onTypeChanged: _onExpenseTypeChanged,
          ),
          SizedBox(height: 1.h),
        ],
      ),
    );
  }

  Widget _buildExpenseList() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        itemCount: _displayedExpenses.length +
            (_isLoading ? 3 : 0) +
            (!_showAllRecords && _filteredExpenses.length > 15 ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < _displayedExpenses.length) {
            final expense = _displayedExpenses[index];
            return ExpenseHistoryCardWidget(
              expense: expense,
              isSelected: _selectedExpenseIds.contains(expense['id']),
              isMultiSelectMode: _isMultiSelectMode,
              onLongPress: () => _onExpenseLongPress(expense['id']),
              onSelected: (selected) =>
                  _onExpenseSelected(expense['id'], selected),
              onEdit: () => _onExpenseEdit(expense['id']),
              onDelete: () => _onExpenseDelete(expense['id']),
            );
          } else if (!_showAllRecords &&
              _filteredExpenses.length > 15 &&
              index == _displayedExpenses.length) {
            return _buildShowAllButton();
          } else {
            return _buildSkeletonCard();
          }
        },
      ),
    );
  }

  Widget _buildShowAllButton() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      child: Center(
        child: ElevatedButton(
          onPressed: _displayAllRecords,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.5.h),
          ),
          child: const Text('Показать все записи'),
        ),
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Card(
        child: Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 20.w,
                    height: 2.h,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    width: 25.w,
                    height: 2.5.h,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Container(
                width: 40.w,
                height: 1.8.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'receipt_long',
            color: AppTheme.lightTheme.colorScheme.outline,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Нет расходов',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'Добавьте первый расход для\nначала отслеживания',
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/expense-entry-screen');
            },
            child: const Text('Добавить первый расход'),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, '/expense-entry-screen');
      },
      child: CustomIconWidget(
        iconName: 'add',
        color: Colors.white,
        size: 24,
      ),
    );
  }
}
