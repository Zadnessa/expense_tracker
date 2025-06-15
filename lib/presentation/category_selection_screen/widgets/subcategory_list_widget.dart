import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class SubcategoryListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> subcategories;
  final Color categoryColor;
  final Function(String, String) onSubcategorySelected;

  const SubcategoryListWidget({
    super.key,
    required this.subcategories,
    required this.categoryColor,
    required this.onSubcategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: categoryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: subcategories.map((subcategory) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onSubcategorySelected(
                subcategory['id'],
                subcategory['name'],
              ),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                margin: EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    // Subcategory indicator dot
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: categoryColor,
                        shape: BoxShape.circle,
                      ),
                    ),

                    SizedBox(width: 12),

                    // Subcategory name
                    Expanded(
                      child: Text(
                        subcategory['name'],
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
                    ),

                    // Selection arrow
                    CustomIconWidget(
                      iconName: 'chevron_right',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
