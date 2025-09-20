import 'package:hive_flutter/hive_flutter.dart';
import '../error/exceptions.dart';

class HiveService {
  static HiveService? _instance;
  HiveService._internal();

  static HiveService get instance {
    _instance ??= HiveService._internal();
    return _instance!;
  }

  // Initialize Hive
  static Future<void> init() async {
    try {
      await Hive.initFlutter();
      
      // Register adapters here when we create them
      // Hive.registerAdapter(ExpenseModelAdapter());
      // Hive.registerAdapter(CurrencyRateModelAdapter());
      
    } catch (e) {
      throw CacheException(message: 'Failed to initialize Hive: $e');
    }
  }

  // Open a box
  Future<Box<T>> openBox<T>(String boxName) async {
    try {
      if (Hive.isBoxOpen(boxName)) {
        return Hive.box<T>(boxName);
      }
      return await Hive.openBox<T>(boxName);
    } catch (e) {
      throw CacheException(message: 'Failed to open box $boxName: $e');
    }
  }

  // Close a box
  Future<void> closeBox(String boxName) async {
    try {
      if (Hive.isBoxOpen(boxName)) {
        await Hive.box(boxName).close();
      }
    } catch (e) {
      throw CacheException(message: 'Failed to close box $boxName: $e');
    }
  }

  // Clear all data from a box
  Future<void> clearBox(String boxName) async {
    try {
      final box = await openBox(boxName);
      await box.clear();
    } catch (e) {
      throw CacheException(message: 'Failed to clear box $boxName: $e');
    }
  }

  // Delete a box
  Future<void> deleteBox(String boxName) async {
    try {
      await Hive.deleteBoxFromDisk(boxName);
    } catch (e) {
      throw CacheException(message: 'Failed to delete box $boxName: $e');
    }
  }

  // Generic methods for CRUD operations
  Future<void> put<T>(String boxName, String key, T value) async {
    try {
      final box = await openBox<T>(boxName);
      await box.put(key, value);
    } catch (e) {
      throw CacheException(message: 'Failed to put data in $boxName: $e');
    }
  }

  Future<T?> get<T>(String boxName, String key) async {
    try {
      final box = await openBox<T>(boxName);
      return box.get(key);
    } catch (e) {
      throw CacheException(message: 'Failed to get data from $boxName: $e');
    }
  }

  Future<void> delete(String boxName, String key) async {
    try {
      final box = await openBox(boxName);
      await box.delete(key);
    } catch (e) {
      throw CacheException(message: 'Failed to delete data from $boxName: $e');
    }
  }

  Future<List<T>> getAll<T>(String boxName) async {
    try {
      final box = await openBox<T>(boxName);
      return box.values.toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get all data from $boxName: $e');
    }
  }

  Future<void> putAll<T>(String boxName, Map<String, T> entries) async {
    try {
      final box = await openBox<T>(boxName);
      await box.putAll(entries);
    } catch (e) {
      throw CacheException(message: 'Failed to put all data in $boxName: $e');
    }
  }

  Future<bool> containsKey(String boxName, String key) async {
    try {
      final box = await openBox(boxName);
      return box.containsKey(key);
    } catch (e) {
      throw CacheException(message: 'Failed to check key in $boxName: $e');
    }
  }

  Future<int> getLength(String boxName) async {
    try {
      final box = await openBox(boxName);
      return box.length;
    } catch (e) {
      throw CacheException(message: 'Failed to get length of $boxName: $e');
    }
  }

  // Close all boxes
  static Future<void> closeAll() async {
    try {
      await Hive.close();
    } catch (e) {
      throw CacheException(message: 'Failed to close all boxes: $e');
    }
  }
}
