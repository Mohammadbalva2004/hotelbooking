import 'package:flutter/material.dart';
import 'package:hotelbooking/features/screen/favorite/favorites_service.dart';

import 'package:hotelbooking/features/screen/hoteldetail/hotel_detail_screen.dart';
import 'package:hotelbooking/features/screen/home/home_screen.dart';
import 'package:hotelbooking/features/screen/booking/booking_screen.dart';
import 'package:hotelbooking/features/screen/profile/profile_screen.dart';
import 'package:hotelbooking/features/widgets/commonappbar/custom_app_bar.dart';
import 'package:hotelbooking/features/widgets/commonbottomnavbar/common_bottom_nav_bar.dart';
import 'package:hotelbooking/features/widgets/commonhotelcard/common_hotel_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> _favoriteHotels = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteHotels();
  }

  Future<void> _loadFavoriteHotels() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final favorites = await FavoritesService.getFavoriteHotels();
      setState(() {
        _favoriteHotels = favorites;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading favorites: $e');
    }
  }

  Future<void> _removeFromFavorites(String hotelName) async {
    final success = await FavoritesService.removeFromFavorites(hotelName);
    if (success) {
      setState(() {
        _favoriteHotels.removeWhere((hotel) => hotel['name'] == hotelName);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$hotelName removed from favorites'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Future<void> _clearAllFavorites() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Clear All Favorites',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to remove all hotels from your favorites?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await FavoritesService.clearAllFavorites();
                setState(() {
                  _favoriteHotels.clear();
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('All favorites cleared'),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToTab(BuildContext context, int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BookingScreen()),
      );
    } else if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        mainTitle: 'Favorites',
        leadingIcon: Icons.arrow_back_ios,
        onLeadingTap:
            () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            ),
        elevation: 2,
        height: 60,
        leadingIconColor: Colors.black,
        mainTitleStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        actions:
            _favoriteHotels.isNotEmpty
                ? [
                  IconButton(
                    icon: const Icon(Icons.clear_all, color: Colors.red),
                    onPressed: _clearAllFavorites,
                    tooltip: 'Clear All Favorites',
                  ),
                ]
                : null,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _favoriteHotels.isEmpty
              ? _buildEmptyState()
              : _buildFavoritesList(),
      bottomNavigationBar: CommonBottomNavBar(
        currentIndex: 1, // Favorites tab index
        onTap: (index) => _navigateToTab(context, index),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 100, color: Colors.grey[400]),
          const SizedBox(height: 20),
          Text(
            'No Favorite Hotels',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Start adding hotels to your favorites\nby tapping the heart icon',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed:
                () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Browse Hotels',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.favorite, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Text(
                '${_favoriteHotels.length} Favorite${_favoriteHotels.length > 1 ? 's' : ''}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _favoriteHotels.length,
            itemBuilder: (context, index) {
              final hotel = _favoriteHotels[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Stack(
                  children: [
                    CommonHotelCard(
                      image: hotel['image'] ?? 'assets/images/room1.png',
                      name: hotel['name'] ?? 'Unknown Hotel',
                      rating: (hotel['rating'] ?? 0.0).toDouble(),
                      reviewCount: hotel['reviews'] ?? 0,
                      location: hotel['location'] ?? 'Unknown Location',
                      price: hotel['price'] ?? 0,
                      cardType: CardType.horizontal,
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => HotelDetailScreen(hotelData: hotel),
                            ),
                          ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () => _removeFromFavorites(hotel['name']),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
