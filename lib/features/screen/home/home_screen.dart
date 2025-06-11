import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:hotelbooking/features/screen/booking/booking_screen.dart';
import 'package:hotelbooking/features/screen/hoteldetail/hotel_detail_screen.dart';
import 'package:hotelbooking/features/screen/profile/profile_screen.dart';
import 'package:hotelbooking/features/screen/statehotel/chennai/chennai_screen.dart';
import 'package:hotelbooking/features/screen/statehotel/goa/goa_screen.dart';
import 'package:hotelbooking/features/screen/statehotel/jaipur/jaipur_screen.dart';
import 'package:hotelbooking/features/screen/statehotel/mumbai/mumbai_screen.dart';
import 'package:hotelbooking/features/screen/statehotel/pune/pune_screen.dart';
import 'package:hotelbooking/features/widgets/commonbottomnavbar/common_bottom_nav_bar.dart';
import 'package:hotelbooking/features/widgets/commonhotelcard/common_hotel_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _bestHotelsScrollController = ScrollController();
  final GlobalKey _bestHotelsKey = GlobalKey();
  final GlobalKey _nearbyHotelsKey = GlobalKey();

  // Search functionality
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;
  List<Map<String, dynamic>> _allHotels = [];
  List<Map<String, dynamic>> _filteredHotels = [];

  @override
  void initState() {
    super.initState();
    _initializeFirebaseAndData();
    _loadAllHotels();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initializeFirebaseAndData() async {
    try {
      await Firebase.initializeApp();
      await _checkAndUploadHotelsToFirestore();
    } catch (e) {
      print("Error initializing Firebase: $e");
    }
  }

  Future<void> _checkAndUploadHotelsToFirestore() async {
    try {
      final QuerySnapshot existingHotels =
          await FirebaseFirestore.instance
              .collection('hotels')
              .where('type', isEqualTo: 'best')
              .limit(1)
              .get();

      if (existingHotels.docs.isEmpty) {
        await _uploadBestHotelsToFirestore();
      } else {
        print("Hotels already exist in Firestore. Skipping upload.");
      }
    } catch (e) {
      print("Error checking/uploading hotels: $e");
    }
  }

  Future<void> _uploadBestHotelsToFirestore() async {
    final hotels = [
      {
        'id': 'malon_greens',
        'name': 'Malon Greens',
        'image': 'assets/images/room1.png',
        'location': 'Mumbai, Maharashtra',
        'price': 1200,
        'rating': 4.5,
        'reviews': 120,
      },
      {
        'id': 'paradise_mint',
        'name': 'Paradise Mint',
        'image': 'assets/images/room2.png',
        'location': 'Jaipur, Rajasthan',
        'price': 1800,
        'rating': 4.5,
        'reviews': 120,
      },
      {
        'id': 'sabro_prime',
        'name': 'Sabro Prime',
        'image': 'assets/images/room3.png',
        'location': 'Goa, Maharashtra',
        'price': 1500,
        'rating': 4.5,
        'reviews': 120,
      },
      {
        'name': '7 twalve',
        'image': 'assets/images/room4.png',
        'location': 'Pune, Maharashtra',
        'price': 1500,
        'rating': 4.5,
        'reviews': 120,
      },
      {
        'name': 'Savor Delight',
        'image': 'assets/images/photo5.jpeg',
        'location': 'Chennai, Tamil Nadu',
        'price': 1500,
        'rating': 4.5,
        'reviews': 120,
      },
    ];

    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (var hotel in hotels) {
        DocumentReference docRef = FirebaseFirestore.instance
            .collection('hotels')
            .doc(hotel['id'] as String);

        batch.set(docRef, hotel);
      }

      await batch.commit();
      print("Best hotels uploaded to Firestore successfully.");
    } catch (e) {
      print("Error uploading hotels to Firestore: $e");
    }
  }

  // Load all hotels for search functionality
  void _loadAllHotels() {
    _allHotels = [
      {
        'name': 'Malon Greens',
        'image': 'assets/images/room1.png',
        'location': 'Mumbai, Maharashtra',
        'price': 1200,
        'rating': 4.5,
        'reviews': 120,
      },
      {
        'name': 'Paradise Mint',
        'image': 'assets/images/room2.png',
        'location': 'Jaipur, Rajasthan',
        'price': 1800,
        'rating': 4.5,
        'reviews': 120,
      },
      {
        'name': 'Sabro Prime',
        'image': 'assets/images/room3.png',
        'location': 'Goa, Maharashtra',
        'price': 1500,
        'rating': 4.5,
        'reviews': 120,
      },
      {
        'name': '7 twalve',
        'image': 'assets/images/room4.png',
        'location': 'Pune, Maharashtra',
        'price': 1500,
        'rating': 4.5,
        'reviews': 120,
      },
      {
        'name': 'Savor Delight',
        'image': 'assets/images/photo5.jpeg',
        'location': 'Chennai, Tamil Nadu',
        'price': 1500,
        'rating': 4.5,
        'reviews': 120,
      },
      {
        'name': 'Royal Orchid',
        'image': 'assets/images/room3.png',
        'location': 'Mumbai, Maharashtra',
        'price': 1800,
        'rating': 4.6,
        'reviews': 95,
      },
      {
        'name': 'Ocean View Resort',
        'image': 'assets/images/room1.png',
        'location': 'Goa, India',
        'price': 2500,
        'rating': 4.7,
        'reviews': 156,
      },
      {
        'name': 'Marina Bay Hotel',
        'image': 'assets/images/room2.png',
        'location': 'Chennai, Tamil Nadu',
        'price': 1600,
        'rating': 4.2,
        'reviews': 75,
      },
      {
        'name': 'Tech Hub Hotel',
        'image': 'assets/images/room4.png',
        'location': 'Pune, Maharashtra',
        'price': 1400,
        'rating': 4.1,
        'reviews': 67,
      },
    ];
  }

  // Search hotels by name
  void _searchHotels(String query) {
    print("Searching for: $query"); // Debug print

    setState(() {
      _searchQuery = query;

      if (query.isEmpty) {
        _isSearching = false;
        _filteredHotels = [];
      } else {
        _isSearching = true;
        _filteredHotels =
            _allHotels
                .where(
                  (hotel) => hotel['name'].toString().toLowerCase().contains(
                    query.toLowerCase(),
                  ),
                )
                .toList();

        print("Found ${_filteredHotels.length} hotels"); // Debug print
      }
    });
  }

  void _navigateToTab(BuildContext context, int index) {
    if (index == 2) {
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(160),
        child: _buildCustomAppBar(),
      ),
      body:
          _isSearching
              ? _buildSearchResults()
              : SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    _buildCityList(),
                    const SizedBox(height: 10),
                    KeyedSubtree(
                      key: _bestHotelsKey,
                      child: Column(
                        children: [
                          _buildSectionHeader(
                            title: "Best Hotels",
                            onSeeAll: _scrollToBestHotels,
                          ),
                          _buildBestHotelsList(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    KeyedSubtree(
                      key: _nearbyHotelsKey,
                      child: Column(
                        children: [
                          _buildSectionHeader(
                            title: "Nearby your location",
                            onSeeAll: _scrollToNearbyHotels,
                          ),
                          _buildNearbyHotelsList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      bottomNavigationBar: CommonBottomNavBar(
        currentIndex: 0,
        onTap: (index) => _navigateToTab(context, index),
      ),
    );
  }

  // Build search results
  Widget _buildSearchResults() {
    if (_filteredHotels.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No hotels found for "$_searchQuery"',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredHotels.length,
      itemBuilder: (context, index) {
        final hotel = _filteredHotels[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: CommonHotelCard(
            image: hotel['image'] ?? 'assets/images/default.png',
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
                    builder: (_) => HotelDetailScreen(hotelData: hotel),
                  ),
                ),
          ),
        );
      },
    );
  }

  void _scrollToBestHotels() {
    _bestHotelsScrollController.animateTo(
      _bestHotelsScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToNearbyHotels() {
    _scrollToKey(_nearbyHotelsKey);
  }

  void _scrollToKey(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildCustomAppBar() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/icon/menu-button.png",
                    width: 30,
                    height: 30,
                    color: Colors.white,
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 130.0),
                    child: Image.asset(
                      "assets/images/splash.png",
                      width: 100,
                      height: 80,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildSearchBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            onChanged: _searchHotels,
            decoration: InputDecoration(
              hintText: "Search hotels by name",
              hintStyle: const TextStyle(color: Colors.white),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              prefixIcon: const Icon(Icons.search, color: Colors.white),
              suffixIcon:
                  _searchQuery.isNotEmpty
                      ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white),
                        onPressed: () {
                          _searchController.clear();
                          _searchHotels('');
                        },
                      )
                      : null,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(
              "assets/icon/settings-sliders.png",
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCityList() {
    final cities = [
      {'name': 'Mumbai', 'image': 'assets/images/Mumbai.jpg'},
      {'name': 'Goa', 'image': 'assets/images/goa.jpg'},
      {'name': 'Chennai', 'image': 'assets/images/chennai.jpg'},
      {'name': 'Jaipur', 'image': 'assets/images/jaipur.jpg'},
      {'name': 'Pune', 'image': 'assets/images/pune.jpg'},
    ];

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:
              cities.map((city) => _buildCityItem(context, city)).toList(),
        ),
      ),
    );
  }

  Widget _buildCityItem(BuildContext context, Map<String, String> city) {
    return GestureDetector(
      onTap: () {
        Widget? destination;

        switch (city['name']) {
          case 'Mumbai':
            destination = const MumbaiScreen();
            break;
          case 'Goa':
            destination = const GoaScreen();
            break;
          case 'Chennai':
            destination = const ChennaiScreen();
            break;
          case 'Jaipur':
            destination = const JaipurScreen();
            break;
          case 'Pune':
            destination = const PuneScreen();
            break;
        }

        if (destination != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination!),
          );
        }
      },
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                city['image'] ?? 'assets/images/default.png',
                fit: BoxFit.cover,
                width: 80,
                height: 80,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            city['name'] ?? 'Unknown',
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required VoidCallback onSeeAll,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
          GestureDetector(
            onTap: onSeeAll,
            child: const Text(
              "See All",
              style: TextStyle(fontSize: 18, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestHotelsList() {
    final hotels = [
      {
        'name': 'Malon Greens',
        'image': 'assets/images/room1.png',
        'location': 'Mumbai, Maharashtra',
        'price': 1200,
        'rating': 4.5,
        'reviews': 120,
      },
      {
        'name': 'Paradise Mint',
        'image': 'assets/images/room2.png',
        'location': 'Jaipur, Rajasthan',
        'price': 1800,
        'rating': 4.5,
        'reviews': 120,
      },
      {
        'name': 'Sabro Prime',
        'image': 'assets/images/room3.png',
        'location': 'Goa, Maharashtra',
        'price': 1500,
        'rating': 4.5,
        'reviews': 120,
      },
      {
        'name': '7 twelve',
        'image': 'assets/images/room4.png',
        'location': 'Pune, Maharashtra',
        'price': 1500,
        'rating': 4.5,
        'reviews': 120,
      },
      {
        'name': 'Savor Delight',
        'image': 'assets/images/photo5.jpeg',
        'location': 'Chennai, Tamil Nadu',
        'price': 1500,
        'rating': 4.5,
        'reviews': 120,
      },
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _bestHotelsScrollController,
      child: Row(
        children: hotels.map((hotel) => _buildHotelCard(hotel)).toList(),
      ),
    );
  }

  Widget _buildHotelCard(Map<String, dynamic> hotel) {
    return CommonHotelCard(
      image: hotel['image'] ?? 'assets/images/default.png',
      name: hotel['name'] ?? 'Unknown Hotel',
      rating: (hotel['rating'] ?? 0.0).toDouble(),
      reviewCount: hotel['reviews'] ?? 0,
      location: hotel['location'] ?? 'Unknown Location',
      price: hotel['price'] ?? 0,
      cardType: CardType.vertical,
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => HotelDetailScreen(hotelData: hotel),
            ),
          ),
    );
  }

  Widget _buildNearbyHotelsList() {
    final nearbyHotels = [
      {
        'name': 'Malon Greens',
        'image': 'assets/images/room1.png',
        'location': 'Mumbai, Maharashtra',
        'price': 1200,
        'rating': 4.5,
        'reviews': 120,
      },
      {
        'name': 'Paradise Mint',
        'image': 'assets/images/room2.png',
        'location': 'Jaipur, Rajasthan',
        'price': 1800,
        'rating': 4.2,
        'reviews': 95,
      },
      {
        'name': 'Sabro Prime',
        'image': 'assets/images/room3.png',
        'location': 'Goa, Maharashtra',
        'price': 1500,
        'rating': 4.7,
        'reviews': 210,
      },
    ];

    return Column(
      children:
          nearbyHotels.map((hotel) => _buildNearbyHotelItem(hotel)).toList(),
    );
  }

  Widget _buildNearbyHotelItem(Map<String, dynamic> hotel) {
    return CommonHotelCard(
      image: hotel['image'] ?? 'assets/images/default.png',
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
              builder: (_) => HotelDetailScreen(hotelData: hotel),
            ),
          ),
    );
  }
}
