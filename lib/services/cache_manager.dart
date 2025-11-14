import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CachedData {
  final String key;
  final Map<String, dynamic> data;
  final DateTime cachedAt;
  final DateTime expiresAt;

  CachedData({
    required this.key,
    required this.data,
    required this.cachedAt,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isValid => !isExpired;

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'data': data,
      'cachedAt': cachedAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  factory CachedData.fromJson(Map<String, dynamic> json) {
    return CachedData(
      key: json['key'],
      data: Map<String, dynamic>.from(json['data']),
      cachedAt: DateTime.parse(json['cachedAt']),
      expiresAt: DateTime.parse(json['expiresAt']),
    );
  }
}

class CacheManager {
  static const String _cachePrefix = 'cache_';
  static const String _cacheIndexKey = 'cache_index';

  static Future<void> cacheData(
    String key,
    Map<String, dynamic> data, {
    Duration? expiry,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final expiryDuration = expiry ?? const Duration(days: 7);
      
      final cachedData = CachedData(
        key: key,
        data: data,
        cachedAt: DateTime.now(),
        expiresAt: DateTime.now().add(expiryDuration),
      );

      await prefs.setString(
        '$_cachePrefix$key',
        json.encode(cachedData.toJson()),
      );

      await _updateCacheIndex(key);
    } catch (e) {
      debugPrint('Error caching data: $e');
    }
  }

  static Future<Map<String, dynamic>?> getCachedData(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString('$_cachePrefix$key');
      
      if (cachedJson == null) return null;

      final cachedData = CachedData.fromJson(json.decode(cachedJson));
      
      if (cachedData.isExpired) {
        await clearCache(key);
        return null;
      }

      return cachedData.data;
    } catch (e) {
      debugPrint('Error getting cached data: $e');
      return null;
    }
  }

  static Future<bool> isCacheValid(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString('$_cachePrefix$key');
      
      if (cachedJson == null) return false;

      final cachedData = CachedData.fromJson(json.decode(cachedJson));
      return cachedData.isValid;
    } catch (e) {
      return false;
    }
  }

  static Future<void> clearCache(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('$_cachePrefix$key');
      await _removeFromCacheIndex(key);
    } catch (e) {
      debugPrint('Error clearing cache: $e');
    }
  }

  static Future<void> clearAllCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      
      for (final key in keys) {
        if (key.startsWith(_cachePrefix)) {
          await prefs.remove(key);
        }
      }
      
      await prefs.remove(_cacheIndexKey);
    } catch (e) {
      debugPrint('Error clearing all cache: $e');
    }
  }

  static Future<double> getCacheSize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      double totalSize = 0;
      
      for (final key in keys) {
        if (key.startsWith(_cachePrefix)) {
          final value = prefs.getString(key);
          if (value != null) {
            totalSize += value.length;
          }
        }
      }
      
      // Convert bytes to MB
      return totalSize / (1024 * 1024);
    } catch (e) {
      debugPrint('Error calculating cache size: $e');
      return 0;
    }
  }

  static Future<List<String>> getCachedKeys() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final indexJson = prefs.getString(_cacheIndexKey);
      
      if (indexJson == null) return [];
      
      final List<dynamic> decoded = json.decode(indexJson);
      return decoded.cast<String>();
    } catch (e) {
      return [];
    }
  }

  static Future<void> _updateCacheIndex(String key) async {
    try {
      final keys = await getCachedKeys();
      if (!keys.contains(key)) {
        keys.add(key);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_cacheIndexKey, json.encode(keys));
      }
    } catch (e) {
      debugPrint('Error updating cache index: $e');
    }
  }

  static Future<void> _removeFromCacheIndex(String key) async {
    try {
      final keys = await getCachedKeys();
      keys.remove(key);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheIndexKey, json.encode(keys));
    } catch (e) {
      debugPrint('Error removing from cache index: $e');
    }
  }

  static Future<void> cleanExpiredCache() async {
    try {
      final keys = await getCachedKeys();
      final prefs = await SharedPreferences.getInstance();
      
      for (final key in keys) {
        final cachedJson = prefs.getString('$_cachePrefix$key');
        if (cachedJson != null) {
          final cachedData = CachedData.fromJson(json.decode(cachedJson));
          if (cachedData.isExpired) {
            await clearCache(key);
          }
        }
      }
    } catch (e) {
      debugPrint('Error cleaning expired cache: $e');
    }
  }
}
