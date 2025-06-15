import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_card_widget.dart';
import './widgets/expense_amount_header_widget.dart';
import './widgets/subcategory_list_widget.dart';

class CategorySelectionScreen extends StatefulWidget {
  const CategorySelectionScreen({super.key});

  @override
  State<CategorySelectionScreen> createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen>
    with TickerProviderStateMixin {
  String? expandedCategoryId;
  bool isLoading = false;
  String selectedAmount = "0";
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Mock categories data with Russian names and predefined colors
  final List<Map<String, dynamic>> categories = [
    {
      "id": "food",
      "name": "Продукты",
      "icon": "shopping_cart",
      "color": Color(0xFF4CAF50),
      "subcategories": [
        {"id": "food_1", "name": "Мясо и птица"},
        {"id": "food_2", "name": "Рыба и морепродукты"},
        {"id": "food_3", "name": "Молочные продукты"},
        {"id": "food_4", "name": "Хлеб и выпечка"},
        {"id": "food_5", "name": "Овощи и фрукты"},
      ]
    },
    {
      "id": "dining",
      "name": "Питание вне дома",
      "icon": "restaurant",
      "color": Color(0xFFFF9800),
      "subcategories": [
        {"id": "dining_1", "name": "Рестораны"},
        {"id": "dining_2", "name": "Кафе"},
        {"id": "dining_3", "name": "Фастфуд"},
        {"id": "dining_4", "name": "Доставка еды"},
      ]
    },
    {
      "id": "transport",
      "name": "Транспорт",
      "icon": "directions_car",
      "color": Color(0xFF2196F3),
      "subcategories": [
        {"id": "transport_1", "name": "Общественный транспорт"},
        {"id": "transport_2", "name": "Такси"},
        {"id": "transport_3", "name": "Бензин"},
        {"id": "transport_4", "name": "Парковка"},
        {"id": "transport_5", "name": "Ремонт авто"},
      ]
    },
    {
      "id": "health",
      "name": "Здоровье",
      "icon": "local_hospital",
      "color": Color(0xFFF44336),
      "subcategories": [
        {"id": "health_1", "name": "Лекарства"},
        {"id": "health_2", "name": "Врачи"},
        {"id": "health_3", "name": "Анализы"},
        {"id": "health_4", "name": "Стоматология"},
      ]
    },
    {
      "id": "entertainment",
      "name": "Развлечения",
      "icon": "movie",
      "color": Color(0xFF9C27B0),
      "subcategories": [
        {"id": "entertainment_1", "name": "Кино"},
        {"id": "entertainment_2", "name": "Театр"},
        {"id": "entertainment_3", "name": "Концерты"},
        {"id": "entertainment_4", "name": "Игры"},
      ]
    },
    {
      "id": "clothing",
      "name": "Одежда",
      "icon": "checkroom",
      "color": Color(0xFFE91E63),
      "subcategories": [
        {"id": "clothing_1", "name": "Верхняя одежда"},
        {"id": "clothing_2", "name": "Обувь"},
        {"id": "clothing_3", "name": "Аксессуары"},
        {"id": "clothing_4", "name": "Белье"},
      ]
    },
    {
      "id": "children",
      "name": "Дети",
      "icon": "child_care",
      "color": Color(0xFF03A9F4),
      "subcategories": [
        {"id": "children_1", "name": "Игрушки"},
        {"id": "children_2", "name": "Детская одежда"},
        {"id": "children_3", "name": "Образование"},
        {"id": "children_4", "name": "Детское питание"},
      ]
    },
    {
      "id": "communication",
      "name": "Связь",
      "icon": "phone",
      "color": Color(0xFF607D8B),
      "subcategories": [
        {"id": "communication_1", "name": "Мобильная связь"},
        {"id": "communication_2", "name": "Интернет"},
        {"id": "communication_3", "name": "Телевидение"},
      ]
    },
    {
      "id": "tobacco",
      "name": "Табак",
      "icon": "smoking_rooms",
      "color": Color(0xFF795548),
      "subcategories": [
        {"id": "tobacco_1", "name": "Сигареты"},
        {"id": "tobacco_2", "name": "Электронные сигареты"},
      ]
    },
    {
      "id": "other",
      "name": "Прочее",
      "icon": "more_horiz",
      "color": Color(0xFF424242),
      "subcategories": [
        {"id": "other_1", "name": "Подарки"},
        {"id": "other_2", "name": "Благотворительность"},
        {"id": "other_3", "name": "Штрафы"},
        {"id": "other_4", "name": "Прочие расходы"},
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Get amount from navigation arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['amount'] != null) {
        setState(() {
          selectedAmount = args['amount'].toString();
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleCategory(String categoryId) {
    setState(() {
      if (expandedCategoryId == categoryId) {
        expandedCategoryId = null;
        _animationController.reverse();
      } else {
        expandedCategoryId = categoryId;
        _animationController.forward();
      }
    });

    // Haptic feedback
    HapticFeedback.lightImpact();
  }

  Future<void> _selectSubcategory(
      String categoryId, String subcategoryId, String subcategoryName) async {
    setState(() {
      isLoading = true;
    });

    // Haptic feedback
    HapticFeedback.mediumImpact();

    try {
      // Simulate database save operation
      await Future.delayed(const Duration(milliseconds: 800));

      // Show success toast
      Fluttertoast.showToast(
        msg: "Расход сохранен",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        textColor: Colors.white,
        fontSize: 14.sp,
      );

      // Navigate back to expense entry screen
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/expense-entry-screen',
          (route) => false,
        );
      }
    } catch (e) {
      // Handle error
      if (mounted) {
        Fluttertoast.showToast(
          msg: "Ошибка сохранения. Попробуйте снова.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          textColor: Colors.white,
          fontSize: 14.sp,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: Text(
          'Выберите категорию',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Sticky expense amount header
          ExpenseAmountHeaderWidget(
            amount: selectedAmount,
          ),

          // Categories list
          Expanded(
            child: isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Сохранение расхода...',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.all(16),
                    itemCount: categories.length,
                    separatorBuilder: (context, index) => SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isExpanded = expandedCategoryId == category['id'];

                      return Column(
                        children: [
                          CategoryCardWidget(
                            category: category,
                            isExpanded: isExpanded,
                            onTap: () => _toggleCategory(category['id']),
                          ),

                          // Animated subcategory list
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            height: isExpanded
                                ? (category['subcategories'] as List).length *
                                        56.0 +
                                    16
                                : 0,
                            child: isExpanded
                                ? FadeTransition(
                                    opacity: _fadeAnimation,
                                    child: SubcategoryListWidget(
                                      subcategories: category['subcategories']
                                          as List<Map<String, dynamic>>,
                                      categoryColor: category['color'] as Color,
                                      onSubcategorySelected:
                                          (subcategoryId, subcategoryName) {
                                        _selectSubcategory(
                                          category['id'],
                                          subcategoryId,
                                          subcategoryName,
                                        );
                                      },
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
