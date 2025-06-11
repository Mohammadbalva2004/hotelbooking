import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoritesService {
  static const String _favoritesKey = 'favorite_hotels';
  
  // Get all favorite hotels
  static Future<List<Map<String, dynamic>>> getFavoriteHotels() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];
      
      return favoritesJson.map((hotelJson) {
        return Map<String, dynamic>.from(json.decode(hotelJson));
      }).toList();
    } catch (e) {
      print('Error getting favorite hotels: $e');
      return [];
    }
  }
  
  // Add hotel to favorites
  static Future<bool> addToFavorites(Map<String, dynamic> hotel) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = await getFavoriteHotels();
      
      // Check if hotel is already in favorites
      final isAlreadyFavorite = favorites.any((fav) => fav['name'] == hotel['name']);
      if (isAlreadyFavorite) {
        return false;
      }
      
      // Add unique ID if not present
      if (!hotel.containsKey('id')) {
        hotel['id'] = hotel['name'].toString().toLowerCase().replaceAll(' ', '_');
      }
      
      favorites.add(hotel);
      
      final favoritesJson = favorites.map((hotel) => json.encode(hotel)).toList();
      await prefs.setStringList(_favoritesKey, favoritesJson);
      
      return true;
    } catch (e) {
      print('Error adding to favorites: $e');
      return false;
    }
  }
  
  // Remove hotel from favorites
  static Future<bool> removeFromFavorites(String hotelName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = await getFavoriteHotels();
      
      favorites.removeWhere((hotel) => hotel['name'] == hotelName);
      
      final favoritesJson = favorites.map((hotel) => json.encode(hotel)).toList();
      await prefs.setStringList(_favoritesKey, favoritesJson);
      
      return true;
    } catch (e) {
      print('Error removing from favorites: $e');
      return false;
    }
  }
  
  // Check if hotel is favorite
  static Future<bool> isFavorite(String hotelName) async {
    try {
      final favorites = await getFavoriteHotels();
      return favorites.any((hotel) => hotel['name'] == hotelName);
    } catch (e) {
      print('Error checking if favorite: $e');
      return false;
    }
  }
  
  // Clear all favorites
  static Future<void> clearAllFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_favoritesKey);
    } catch (e) {
      print('Error clearing favorites: $e');
    }
  }
}