// lib/services/database_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'expense_tracker.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    // Создаем таблицу категорий
    await db.execute('''
      CREATE TABLE categories(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        icon TEXT NOT NULL,
        color INTEGER NOT NULL,
        is_custom INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Создаем таблицу подкатегорий
    await db.execute('''
      CREATE TABLE subcategories(
        id TEXT PRIMARY KEY,
        category_id TEXT NOT NULL,
        name TEXT NOT NULL,
        is_custom INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE CASCADE
      )
    ''');

    // Добавляем предустановленные категории
    await _insertDefaultCategories(db);
  }

  Future<void> _insertDefaultCategories(Database db) async {
    // Предустановленные категории
    List<Map<String, dynamic>> categories = [
      {
        "id": "food",
        "name": "Продукты",
        "icon": "shopping_cart",
        "color": 0xFF4CAF50,
        "is_custom": 0
      },
      {
        "id": "dining",
        "name": "Питание вне дома",
        "icon": "restaurant",
        "color": 0xFFFF9800,
        "is_custom": 0
      },
      {
        "id": "transport",
        "name": "Транспорт",
        "icon": "directions_car",
        "color": 0xFF2196F3,
        "is_custom": 0
      },
      {
        "id": "health",
        "name": "Здоровье",
        "icon": "local_hospital",
        "color": 0xFFF44336,
        "is_custom": 0
      },
      {
        "id": "entertainment",
        "name": "Развлечения",
        "icon": "movie",
        "color": 0xFF9C27B0,
        "is_custom": 0
      },
      {
        "id": "clothing",
        "name": "Одежда",
        "icon": "checkroom",
        "color": 0xFFE91E63,
        "is_custom": 0
      },
      {
        "id": "children",
        "name": "Дети",
        "icon": "child_care",
        "color": 0xFF03A9F4,
        "is_custom": 0
      },
      {
        "id": "communication",
        "name": "Связь",
        "icon": "phone",
        "color": 0xFF607D8B,
        "is_custom": 0
      },
      {
        "id": "tobacco",
        "name": "Табак",
        "icon": "smoking_rooms",
        "color": 0xFF795548,
        "is_custom": 0
      },
      {
        "id": "other",
        "name": "Прочее",
        "icon": "more_horiz",
        "color": 0xFF424242,
        "is_custom": 0
      },
    ];

    // Предустановленные подкатегории
    List<Map<String, dynamic>> subcategories = [
      {
        "id": "food_1",
        "category_id": "food",
        "name": "Мясо и птица",
        "is_custom": 0
      },
      {
        "id": "food_2",
        "category_id": "food",
        "name": "Рыба и морепродукты",
        "is_custom": 0
      },
      {
        "id": "food_3",
        "category_id": "food",
        "name": "Молочные продукты",
        "is_custom": 0
      },
      {
        "id": "food_4",
        "category_id": "food",
        "name": "Хлеб и выпечка",
        "is_custom": 0
      },
      {
        "id": "food_5",
        "category_id": "food",
        "name": "Овощи и фрукты",
        "is_custom": 0
      },
      {
        "id": "dining_1",
        "category_id": "dining",
        "name": "Рестораны",
        "is_custom": 0
      },
      {
        "id": "dining_2",
        "category_id": "dining",
        "name": "Кафе",
        "is_custom": 0
      },
      {
        "id": "dining_3",
        "category_id": "dining",
        "name": "Фастфуд",
        "is_custom": 0
      },
      {
        "id": "dining_4",
        "category_id": "dining",
        "name": "Доставка еды",
        "is_custom": 0
      },
      {
        "id": "transport_1",
        "category_id": "transport",
        "name": "Общественный транспорт",
        "is_custom": 0
      },
      {
        "id": "transport_2",
        "category_id": "transport",
        "name": "Такси",
        "is_custom": 0
      },
      {
        "id": "transport_3",
        "category_id": "transport",
        "name": "Бензин",
        "is_custom": 0
      },
      {
        "id": "transport_4",
        "category_id": "transport",
        "name": "Парковка",
        "is_custom": 0
      },
      {
        "id": "transport_5",
        "category_id": "transport",
        "name": "Ремонт авто",
        "is_custom": 0
      },
      {
        "id": "health_1",
        "category_id": "health",
        "name": "Лекарства",
        "is_custom": 0
      },
      {
        "id": "health_2",
        "category_id": "health",
        "name": "Врачи",
        "is_custom": 0
      },
      {
        "id": "health_3",
        "category_id": "health",
        "name": "Анализы",
        "is_custom": 0
      },
      {
        "id": "health_4",
        "category_id": "health",
        "name": "Стоматология",
        "is_custom": 0
      },
      {
        "id": "entertainment_1",
        "category_id": "entertainment",
        "name": "Кино",
        "is_custom": 0
      },
      {
        "id": "entertainment_2",
        "category_id": "entertainment",
        "name": "Театр",
        "is_custom": 0
      },
      {
        "id": "entertainment_3",
        "category_id": "entertainment",
        "name": "Концерты",
        "is_custom": 0
      },
      {
        "id": "entertainment_4",
        "category_id": "entertainment",
        "name": "Игры",
        "is_custom": 0
      },
      {
        "id": "clothing_1",
        "category_id": "clothing",
        "name": "Верхняя одежда",
        "is_custom": 0
      },
      {
        "id": "clothing_2",
        "category_id": "clothing",
        "name": "Обувь",
        "is_custom": 0
      },
      {
        "id": "clothing_3",
        "category_id": "clothing",
        "name": "Аксессуары",
        "is_custom": 0
      },
      {
        "id": "clothing_4",
        "category_id": "clothing",
        "name": "Белье",
        "is_custom": 0
      },
      {
        "id": "children_1",
        "category_id": "children",
        "name": "Игрушки",
        "is_custom": 0
      },
      {
        "id": "children_2",
        "category_id": "children",
        "name": "Детская одежда",
        "is_custom": 0
      },
      {
        "id": "children_3",
        "category_id": "children",
        "name": "Образование",
        "is_custom": 0
      },
      {
        "id": "children_4",
        "category_id": "children",
        "name": "Детское питание",
        "is_custom": 0
      },
      {
        "id": "communication_1",
        "category_id": "communication",
        "name": "Мобильная связь",
        "is_custom": 0
      },
      {
        "id": "communication_2",
        "category_id": "communication",
        "name": "Интернет",
        "is_custom": 0
      },
      {
        "id": "communication_3",
        "category_id": "communication",
        "name": "Телевидение",
        "is_custom": 0
      },
      {
        "id": "tobacco_1",
        "category_id": "tobacco",
        "name": "Сигареты",
        "is_custom": 0
      },
      {
        "id": "tobacco_2",
        "category_id": "tobacco",
        "name": "Электронные сигареты",
        "is_custom": 0
      },
      {
        "id": "other_1",
        "category_id": "other",
        "name": "Подарки",
        "is_custom": 0
      },
      {
        "id": "other_2",
        "category_id": "other",
        "name": "Благотворительность",
        "is_custom": 0
      },
      {
        "id": "other_3",
        "category_id": "other",
        "name": "Штрафы",
        "is_custom": 0
      },
      {
        "id": "other_4",
        "category_id": "other",
        "name": "Прочие расходы",
        "is_custom": 0
      },
    ];

    // Добавляем категории
    Batch batch = db.batch();
    for (var category in categories) {
      batch.insert('categories', category);
    }

    // Добавляем подкатегории
    for (var subcategory in subcategories) {
      batch.insert('subcategories', subcategory);
    }

    await batch.commit(noResult: true);
  }

  // CRUD операции для категорий

  Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await database;
    final result = await db.query('categories', orderBy: 'name');
    return List<Map<String, dynamic>>.from(result.map((item) => Map<String, dynamic>.from(item)));
  }

  Future<Map<String, dynamic>?> getCategory(String id) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query('categories',
        where: 'id = ?', whereArgs: [id], limit: 1);
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<int> insertCategory(Map<String, dynamic> category) async {
    final db = await database;
    return await db.insert('categories', category);
  }

  Future<int> updateCategory(Map<String, dynamic> category) async {
    final db = await database;
    return await db.update(
      'categories',
      category,
      where: 'id = ?',
      whereArgs: [category['id']],
    );
  }

  Future<int> deleteCategory(String id) async {
    final db = await database;
    return await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CRUD операции для подкатегорий

  Future<List<Map<String, dynamic>>> getSubcategories(String categoryId) async {
    final db = await database;
    return await db.query(
      'subcategories',
      where: 'category_id = ?',
      whereArgs: [categoryId],
      orderBy: 'name',
    );
  }

  Future<Map<String, dynamic>?> getSubcategory(String id) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'subcategories',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<int> insertSubcategory(Map<String, dynamic> subcategory) async {
    final db = await database;
    return await db.insert('subcategories', subcategory);
  }

  Future<int> updateSubcategory(Map<String, dynamic> subcategory) async {
    final db = await database;
    return await db.update(
      'subcategories',
      subcategory,
      where: 'id = ?',
      whereArgs: [subcategory['id']],
    );
  }

  Future<int> deleteSubcategory(String id) async {
    final db = await database;
    return await db.delete(
      'subcategories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
