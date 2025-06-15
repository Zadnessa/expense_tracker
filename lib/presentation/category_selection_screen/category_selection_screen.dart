import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/category_service.dart';
import './widgets/category_card_widget.dart';
import './widgets/expense_amount_header_widget.dart';
import './widgets/subcategory_list_widget.dart';

// lib/presentation/category_selection_screen/category_selection_screen.dart

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
  bool isLoadingCategories = true;
  String selectedAmount = "0";
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Используем сервис категорий для работы с БД
  final CategoryService _categoryService = CategoryService();

  // Список категорий из БД
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    // Получаем сумму из предыдущего экрана
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['amount'] != null) {
        setState(() {
          selectedAmount = args['amount'].toString();
        });
      }

      // Загружаем категории из БД
      _loadCategories();
    });
  }

  // Загрузка категорий из БД
  Future<void> _loadCategories() async {
    try {
      List<Map<String, dynamic>> loadedCategories =
          await _categoryService.getAllCategoriesWithSubcategories();

      setState(() {
        categories = loadedCategories.map((category) {
          Map<String, dynamic> newCategory = Map<String, dynamic>.from(category);
          newCategory['subcategories'] = List<Map<String, dynamic>>.from(category['subcategories'] ?? []);
          return newCategory;
        }).toList();
    isLoading = false;
  });
    } catch (e) {
      setState(() {
        isLoadingCategories = false;
      });
      Fluttertoast.showToast(
          msg: "Ошибка загрузки категорий: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          textColor: Colors.white);
    }
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
          fontSize: 14.sp);

      // Navigate back to expense entry screen
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/expense-entry-screen', (route) => false);
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
            fontSize: 14.sp);
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Диалог добавления новой категории
  Future<void> _showAddCategoryDialog() async {
    String newCategoryName = '';
    String selectedIcon = 'category'; // Иконка по умолчанию
    Color selectedColor =
        AppTheme.lightTheme.colorScheme.primary; // Цвет по умолчанию

    // Список доступных иконок для выбора
    List<String> availableIcons = [
      'category',
      'shopping_cart',
      'restaurant',
      'directions_car',
      'local_hospital',
      'movie',
      'checkroom',
      'child_care',
      'phone',
      'smoking_rooms',
      'more_horiz',
      'home',
      'work',
      'flight',
      'school',
      'sports_basketball',
      'pets',
      'favorite',
      'fitness_center'
    ];

    // Список цветов для выбора
    List<Color> availableColors = [
      Color(0xFF4CAF50),
      Color(0xFFFF9800),
      Color(0xFF2196F3),
      Color(0xFFF44336),
      Color(0xFF9C27B0),
      Color(0xFFE91E63),
      Color(0xFF03A9F4),
      Color(0xFF607D8B),
      Color(0xFF795548),
      Color(0xFF424242)
    ];

    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                title: Text('Добавить категорию',
                    style: AppTheme.lightTheme.textTheme.titleLarge),
                content: SingleChildScrollView(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                  // Поле ввода названия категории
                  TextField(
                      decoration: InputDecoration(
                          labelText: 'Название категории',
                          border: OutlineInputBorder()),
                      onChanged: (value) {
                        newCategoryName = value;
                      }),

                  SizedBox(height: 16),

                  // Выбор иконки
                  Text('Выберите иконку',
                      style: AppTheme.lightTheme.textTheme.bodyLarge),
                  SizedBox(height: 8),
                  Container(
                      height: 150,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline),
                          borderRadius: BorderRadius.circular(8)),
                      child: GridView.builder(
                          padding: EdgeInsets.all(8),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8),
                          itemBuilder: (context, index) {
                            final iconName = availableIcons[index];
                            final isSelected = selectedIcon == iconName;

                            return InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedIcon = iconName;
                                  });
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: isSelected
                                            ? selectedColor.withAlpha(51)
                                            : null,
                                        borderRadius: BorderRadius.circular(8),
                                        border: isSelected
                                            ? Border.all(color: selectedColor)
                                            : null),
                                    child: Center(
                                        child: CustomIconWidget(
                                            iconName: iconName,
                                            color: isSelected
                                                ? selectedColor
                                                : AppTheme.lightTheme
                                                    .colorScheme.onSurface,
                                            size: 24))));
                          })),

                  SizedBox(height: 16),

                  // Выбор цвета
                  Text('Выберите цвет',
                      style: AppTheme.lightTheme.textTheme.bodyLarge),
                  SizedBox(height: 8),
                  SizedBox(
                      height: 70,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: availableColors.length,
                          itemBuilder: (context, index) {
                            final color = availableColors[index];
                            final isSelected =
                                selectedColor.value == color.value;

                            return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedColor = color;
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(24),
                                    child: Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                            color: color,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: isSelected
                                                    ? Colors.white
                                                    : Colors.transparent,
                                                width: 3),
                                            boxShadow: isSelected
                                                ? [
                                                    BoxShadow(
                                                        color: color
                                                            .withAlpha(128),
                                                        blurRadius: 8,
                                                        spreadRadius: 2)
                                                  ]
                                                : []))));
                          })),
                ])),
                actions: [
                  TextButton(
                      child: Text('Отмена'),
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      }),
                  ElevatedButton(
                      child: Text('Добавить'),
                      onPressed: () async {
                        if (newCategoryName.trim().isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Введите название категории",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor:
                                  AppTheme.lightTheme.colorScheme.error);
                          return;
                        }

                        Navigator.of(dialogContext).pop();

                        // Показываем индикатор загрузки
                        setState(() {
                          isLoading = true;
                        });

                        try {
                          // Добавляем новую категорию в БД
                          Map<String, dynamic> newCategory =
                              await _categoryService.addCustomCategory(
                                  newCategoryName.trim(),
                                  selectedIcon,
                                  selectedColor);

                          // Добавляем категорию в список и обновляем UI
                          setState(() {
                            categories.add(newCategory);
                            isLoading = false;
                          });

                          Fluttertoast.showToast(
                              msg: "Категория добавлена",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor:
                                  AppTheme.lightTheme.colorScheme.primary,
                              textColor: Colors.white);
                        } catch (e) {
                          setState(() {
                            isLoading = false;
                          });
                          Fluttertoast.showToast(
                              msg: "Ошибка при добавлении категории",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor:
                                  AppTheme.lightTheme.colorScheme.error,
                              textColor: Colors.white);
                        }
                      }),
                ]);
          });
        });
  }

  // Диалог добавления новой подкатегории
  Future<void> _showAddSubcategoryDialog(
      String categoryId, Color categoryColor) async {
    String newSubcategoryName = '';

    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
              title: Text('Добавить подкатегорию',
                  style: AppTheme.lightTheme.textTheme.titleLarge),
              content: TextField(
                  decoration: InputDecoration(
                      labelText: 'Название подкатегории',
                      border: OutlineInputBorder()),
                  onChanged: (value) {
                    newSubcategoryName = value;
                  }),
              actions: [
                TextButton(
                    child: Text('Отмена'),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    }),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: categoryColor),
                    child: Text('Добавить'),
                    onPressed: () async {
                      if (newSubcategoryName.trim().isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Введите название подкатегории",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor:
                                AppTheme.lightTheme.colorScheme.error);
                        return;
                      }

                      Navigator.of(dialogContext).pop();

                      // Показываем индикатор загрузки
                      setState(() {
                        isLoading = true;
                      });

                      try {
                        // Добавляем новую подкатегорию в БД
                        Map<String, dynamic> newSubcategory =
                            await _categoryService.addCustomSubcategory(
                                categoryId, newSubcategoryName.trim());

                        // Находим нужную категорию и добавляем в неё подкатегорию
                        setState(() {
                          for (int i = 0; i < categories.length; i++) {
                            if (categories[i]['id'] == categoryId) {
                              List<Map<String, dynamic>> subcategories =
                                  List<Map<String, dynamic>>.from(
                                      categories[i]['subcategories']);
                              subcategories.add(newSubcategory);
                              categories[i]['subcategories'] = subcategories;
                              break;
                            }
                          }
                          isLoading = false;
                        });

                        Fluttertoast.showToast(
                            msg: "Подкатегория добавлена",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor:
                                AppTheme.lightTheme.colorScheme.primary,
                            textColor: Colors.white);
                      } catch (e) {
                        setState(() {
                          isLoading = false;
                        });
                        Fluttertoast.showToast(
                            msg: "Ошибка при добавлении подкатегории",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor:
                                AppTheme.lightTheme.colorScheme.error,
                            textColor: Colors.white);
                      }
                    }),
              ]);
        });
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
                    size: 24)),
            title: Text('Выберите категорию',
                style: AppTheme.lightTheme.appBarTheme.titleTextStyle),
            centerTitle: true),
        body: Column(children: [
          // Sticky expense amount header
          ExpenseAmountHeaderWidget(amount: selectedAmount),

          // Categories list
          Expanded(
              child: isLoading || isLoadingCategories
                  ? Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          CircularProgressIndicator(
                              color: AppTheme.lightTheme.colorScheme.primary),
                          SizedBox(height: 16),
                          Text(
                              isLoading
                                  ? 'Сохранение расхода...'
                                  : 'Загрузка категорий...',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant)),
                        ]))
                  : ListView.builder(
                      padding: EdgeInsets.all(16),
                      // +1 для пункта "Добавить категорию"
                      itemCount: categories.length + 1,
                      itemBuilder: (context, index) {
                        // Пункт "Добавить категорию" в начале списка
                        if (index == 0) {
                          return Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                      onTap: _showAddCategoryDialog,
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                          padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                              color: AppTheme.lightTheme
                                                  .colorScheme.primaryContainer,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                  color: AppTheme.lightTheme
                                                      .colorScheme.primary
                                                      .withValues(alpha: 0.3))),
                                          child: Row(children: [
                                            Container(
                                                width: 48,
                                                height: 48,
                                                decoration: BoxDecoration(
                                                    color: AppTheme.lightTheme
                                                        .colorScheme.primary
                                                        .withValues(alpha: 0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                                child: Center(
                                                    child: CustomIconWidget(
                                                        iconName: 'add',
                                                        color: AppTheme
                                                            .lightTheme
                                                            .colorScheme
                                                            .primary,
                                                        size: 24))),
                                            SizedBox(width: 16),
                                            Text('Добавить категорию',
                                                style: AppTheme.lightTheme
                                                    .textTheme.titleMedium
                                                    ?.copyWith(
                                                        color: AppTheme
                                                            .lightTheme
                                                            .colorScheme
                                                            .primary,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                          ])))));
                        }

                        // Обычные категории
                        final category = categories[index - 1];
                        final isExpanded = expandedCategoryId == category['id'];
                        final categoryColor = category['color'] as Color;

                        return Column(children: [
                          CategoryCardWidget(
                              category: category,
                              isExpanded: isExpanded,
                              onTap: () => _toggleCategory(category['id'])),

                          // Animated subcategory list
                          AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              height: isExpanded
                                  ? ((category['subcategories'] as List)
                                                  .length +
                                              1) * // +1 для пункта "Добавить подкатегорию"
                                          56.0 +
                                      16
                                  : 0,
                              child: isExpanded
                                  ? FadeTransition(
                                      opacity: _fadeAnimation,
                                      child: Column(children: [
                                        // Кнопка "Добавить подкатегорию"
                                        Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                                onTap: () =>
                                                    _showAddSubcategoryDialog(
                                                        category['id'],
                                                        categoryColor),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Container(
                                                    margin: EdgeInsets.only(
                                                        top: 8,
                                                        left: 8,
                                                        right: 8),
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 12),
                                                    decoration: BoxDecoration(
                                                        color: categoryColor
                                                            .withValues(
                                                                alpha: 0.1),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                8),
                                                        border: Border.all(
                                                            color: categoryColor
                                                                .withValues(
                                                                    alpha: 0.3))),
                                                    child: Row(children: [
                                                      CustomIconWidget(
                                                          iconName: 'add',
                                                          color: categoryColor,
                                                          size: 20),
                                                      SizedBox(width: 12),
                                                      Text(
                                                          'Добавить подкатегорию',
                                                          style: AppTheme
                                                              .lightTheme
                                                              .textTheme
                                                              .bodyMedium
                                                              ?.copyWith(
                                                                  color:
                                                                      categoryColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                    ])))),
                                        // Список существующих подкатегорий
                                        SubcategoryListWidget(
                                            subcategories: category[
                                                    'subcategories']
                                                as List<Map<String, dynamic>>,
                                            categoryColor: categoryColor,
                                            onSubcategorySelected:
                                                (subcategoryId,
                                                    subcategoryName) {
                                              _selectSubcategory(
                                                  category['id'],
                                                  subcategoryId,
                                                  subcategoryName);
                                            }),
                                      ]))
                                  : const SizedBox.shrink()),

                          SizedBox(height: 8),
                        ]);
                      })),
        ]));
  }
}
