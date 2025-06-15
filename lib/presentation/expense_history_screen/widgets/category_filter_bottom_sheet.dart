import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CategoryFilterBottomSheet extends StatefulWidget {
  final List<String> selectedCategories;
  final ValueChanged<List<String>> onCategoriesChanged;

  const CategoryFilterBottomSheet({
    super.key,
    required this.selectedCategories,
    required this.onCategoriesChanged,
  });

  @override
  State<CategoryFilterBottomSheet> createState() =>
      _CategoryFilterBottomSheetState();
}

class _CategoryFilterBottomSheetState extends State<CategoryFilterBottomSheet> {
  late List<String> _selectedCategories;

  static final List <Map<String, dynamic>> _categories = [
    {'name': 'Продукты', 'color': Color(0xFF4CAF50)},
    {'name': 'Питание вне дома', 'color': Color(0xFFFF9800)},
    {'name': 'Транспорт', 'color': Color(0xFF2196F3)},
    {'name': 'Здоровье', 'color': Color(0xFFF44336)},
    {'name': 'Развлечения', 'color': Color(0xFF9C27B0)},
    {'name': 'Одежда', 'color': Color(0xFFE91E63)},
    {'name': 'Дети', 'color': Color(0xFF03A9F4)},
    {'name': 'Связь', 'color': Color(0xFF607D8B)},
    {'name': 'Табак', 'color': Color(0xFF795548)},
    {'name': 'Прочее', 'color': Color(0xFF424242)},
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategories = List.from(widget.selectedCategories);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.bottomSheetTheme.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          _buildCategoryList(),
          _buildActionButtons(),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Фильтр по категориям',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedCategories.clear();
              });
            },
            child: const Text('Очистить'),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return Container(
      constraints: BoxConstraints(maxHeight: 50.h),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final categoryName = category['name'] as String;
          final categoryColor = category['color'] as Color;
          final isSelected = _selectedCategories.contains(categoryName);

          return CheckboxListTile(
            value: isSelected,
            onChanged: (value) {
              setState(() {
                if (value == true) {
                  _selectedCategories.add(categoryName);
                } else {
                  _selectedCategories.remove(categoryName);
                }
              });
            },
            title: Row(
              children: [
                Container(
                  width: 4,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: categoryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(width: 3.w),
                Text(
                  categoryName,
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                ),
              ],
            ),
            controlAffinity: ListTileControlAffinity.trailing,
            contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
          );
        },
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                widget.onCategoriesChanged(_selectedCategories);
                Navigator.of(context).pop();
              },
              child: Text(
                'Применить${_selectedCategories.isNotEmpty ? ' (${_selectedCategories.length})' : ''}',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
