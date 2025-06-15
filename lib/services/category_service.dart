import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import './database_service.dart';

// lib/services/category_service.dart

class CategoryService {
  final DatabaseService _databaseService = DatabaseService();
  final uuid = Uuid();

  // Получение всех категорий с подкатегориями
  Future<List<Map<String, dynamic>>> getAllCategoriesWithSubcategories() async {
    // Получаем все категории
    List<Map<String, dynamic>> categories =
        await _databaseService.getCategories();

    // Для каждой категории загружаем подкатегории
    for (int i = 0; i < categories.length; i++) {
      String categoryId = categories[i]['id'];
      List<Map<String, dynamic>> subcategories =
          await _databaseService.getSubcategories(categoryId);
      categories[i]['subcategories'] = subcategories;
      categories[i]['color'] = Color(categories[i]['color']);
    }

    return categories;
  }

  // Добавление пользовательской категории
  Future<Map<String, dynamic>> addCustomCategory(
      String name, String icon, Color color) async {
    // Создаем уникальный идентификатор для категории
    String id = 'custom_${uuid.v4()}';

    Map<String, dynamic> newCategory = {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color.value,
      'is_custom': 1
    };

    // Добавляем категорию в базу данных
    await _databaseService.insertCategory(newCategory);

    // Возвращаем новую категорию
    newCategory['color'] =
        color; // Заменяем int на Color для использования в UI
    newCategory['subcategories'] = []; // Пустой список подкатегорий

    return newCategory;
  }

  // Добавление пользовательской подкатегории
  Future<Map<String, dynamic>> addCustomSubcategory(
      String categoryId, String name) async {
    // Создаем уникальный идентификатор для подкатегории
    String id = 'custom_sub_${uuid.v4()}';

    Map<String, dynamic> newSubcategory = {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'is_custom': 1
    };

    // Добавляем подкатегорию в базу данных
    await _databaseService.insertSubcategory(newSubcategory);

    return newSubcategory;
  }

  // Обновление категории
  Future<int> updateCategory(Map<String, dynamic> category) async {
    // Если цвет передан как Color, преобразуем его в int
    if (category['color'] is Color) {
      category['color'] = (category['color'] as Color).value;
    }
    return await _databaseService.updateCategory(category);
  }

  // Обновление подкатегории
  Future<int> updateSubcategory(Map<String, dynamic> subcategory) async {
    return await _databaseService.updateSubcategory(subcategory);
  }

  // Удаление категории
  Future<int> deleteCategory(String id) async {
    return await _databaseService.deleteCategory(id);
  }

  // Удаление подкатегории
  Future<int> deleteSubcategory(String id) async {
    return await _databaseService.deleteSubcategory(id);
  }
}
