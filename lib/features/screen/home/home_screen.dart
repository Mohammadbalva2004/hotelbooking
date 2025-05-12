import 'package:flutter/material.dart';
import 'package:hotelbooking/features/screen/filter/filter_screen.dart';

import 'package:hotelbooking/features/screen/hoteldetail/hotel_detail_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(160),
        child: _buildCustomAppBar(),
      ),
      body: SingleChildScrollView(
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.percent), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
        type: BottomNavigationBarType.fixed,
      ),
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
          padding: const EdgeInsets.only(left: 16.0, right: 16),
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
          child: TextFormField(
            decoration: InputDecoration(
              hintText: "Search",
              hintStyle: const TextStyle(color: Colors.white),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              prefixIcon: const Icon(Icons.search, color: Colors.white),
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
        if (city['name'] == 'Mumbai') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FilterScreen()),
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
                city['image']!,
                fit: BoxFit.cover,
                width: 80,
                height: 80,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            city['name']!,
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
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
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
        'location': 'Mumbai,Maharashtra',
        'price': 120,
        'rating': 4.5,
        'reviews': 120,
      },
      {
        'name': 'Paradise Mint',
        'image': 'assets/images/room2.png',
        'location': 'Jaipur,Rajasthan',
        'price': 180,
        'rating': 4.5,
        'reviews': 120,
      },
      {
        'name': 'Sabro Prime',
        'image': 'assets/images/room3.png',
        'location': 'Goa,Maharashtra',
        'price': 150,
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
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 300,
        width: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HotelDetailScreen(),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        hotel['image']!,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  top: 20,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withOpacity(0.2),
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 4,
              ),
              child: StarRating(
                rating: hotel['rating']!,
                reviewCount: hotel['reviews']!,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 4,
              ),
              child: Text(
                hotel['name']!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: Colors.black),
                  const SizedBox(width: 8),
                  Text(
                    hotel['location']!,
                    style: const TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 4),
              child: Row(
                children: [
                  Text(
                    "\$${hotel['price']}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "/night",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
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
        'price': 120,
        'rating': 4.5,
        'reviews': 120,
      },
      {
        'name': 'Paradise Mint',
        'image': 'assets/images/room2.png',
        'location': 'Jaipur, Rajasthan',
        'price': 180,
        'rating': 4.2,
        'reviews': 95,
      },
      {
        'name': 'Sabro Prime',
        'image': 'assets/images/room3.png',
        'location': 'Goa, Maharashtra',
        'price': 150,
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
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      hotel['image']!,
                      height: 130,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),

                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StarRating(
                    rating: hotel['rating']!,
                    reviewCount: hotel['reviews']!,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4,
                    ),
                    child: Text(
                      hotel['name']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        hotel['location']!,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "\$${hotel['price']}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "/night",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  final double rating;
  final int reviewCount;

  const StarRating({
    super.key,
    required this.rating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    int fullStars = rating.floor();
    bool hasHalfStar = rating - fullStars >= 0.5;

    return Row(
      children: [
        ...List.generate(
          fullStars,
          (index) => const Icon(Icons.star, color: Colors.amber, size: 20),
        ),
        if (hasHalfStar)
          const Icon(Icons.star_half, color: Colors.amber, size: 20),
        ...List.generate(
          5 - fullStars - (hasHalfStar ? 1 : 0),
          (index) =>
              const Icon(Icons.star_border, color: Colors.amber, size: 20),
        ),
        const SizedBox(width: 5),
        Text(
          "($reviewCount reviews)",
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
      ],
    );
  }
}
