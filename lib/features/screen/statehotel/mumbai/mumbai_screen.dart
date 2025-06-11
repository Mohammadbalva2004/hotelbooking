import 'package:flutter/material.dart';
import 'package:hotelbooking/features/screen/hoteldetail/hotel_detail_screen.dart';
import 'package:hotelbooking/features/widgets/commonappbar/custom_app_bar.dart';
import 'package:hotelbooking/features/widgets/commoncityscreen/common_city_screen.dart';

class MumbaiScreen extends StatefulWidget {
  const MumbaiScreen({super.key});

  @override
  State<MumbaiScreen> createState() => _MumbaiScreenState();
}

class _MumbaiScreenState extends State<MumbaiScreen>
    with CityScreenFilterMixin {
  @override
  void initState() {
    super.initState();
    _initializeMumbaiData();
    initializeFilters();
  }

  void _initializeMumbaiData() {
    selectedPriceRange = '₹1000 - ₹1200';
    priceRanges = ['₹1000 - ₹1200', '₹1200 - ₹1500', '₹1500 - ₹2500'];
    localities = ["Andheri East", "Thane", "Bandra", "Dadar", "Navi Mumbai"];
    allHotels = [
      {
        'name': 'Malon Greens',
        'image': 'assets/images/room1.png',
        'location': 'Mumbai, Maharashtra',
        'locality': 'Andheri East',
        'price': 1200,
        'rating': 5.0,
        'reviews': 120,
        'popularity': 95,
      },
      {
        'name': 'Sabro Prime',
        'image': 'assets/images/room2.png',
        'location': 'Mumbai, Maharashtra',
        'locality': 'Bandra',
        'price': 1000,
        'rating': 4.8,
        'reviews': 110,
        'popularity': 88,
      },
      {
        'name': 'Royal Orchid',
        'image': 'assets/images/room3.png',
        'location': 'Mumbai, Maharashtra',
        'locality': 'Thane',
        'price': 1500,
        'rating': 4.6,
        'reviews': 95,
        'popularity': 92,
      },
      {
        'name': 'Sunset Bay',
        'image': 'assets/images/room1.png',
        'location': 'Mumbai, Maharashtra',
        'locality': 'Dadar',
        'price': 2000,
        'rating': 4.9,
        'reviews': 150,
        'popularity': 97,
      },
      {
        'name': 'Green Valley',
        'image': 'assets/images/room3.png',
        'location': 'Mumbai, Maharashtra',
        'locality': 'Navi Mumbai',
        'price': 1150,
        'rating': 4.3,
        'reviews': 78,
        'popularity': 82,
      },
      {
        'name': 'Metro Heights',
        'image': 'assets/images/room2.png',
        'location': 'Mumbai, Maharashtra',
        'locality': 'Andheri East',
        'price': 1100,
        'rating': 4.5,
        'reviews': 92,
        'popularity': 89,
      },
      {
        'name': 'Luxury Palace',
        'image': 'assets/images/room1.png',
        'location': 'Mumbai, Maharashtra',
        'locality': 'Bandra',
        'price': 2500,
        'rating': 4.7,
        'reviews': 130,
        'popularity': 94,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        mainTitle: 'Mumbai',
        leadingIcon: Icons.arrow_back_ios,
        onLeadingTap: () => Navigator.pop(context),
        elevation: 2,
        height: 60,
        leadingIconColor: Colors.black,
        mainTitleStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          buildFilterOptionsRow(),
          Expanded(
            child:
                filteredHotels.isEmpty
                    ? const Center(
                      child: Text(
                        "No hotels match your filters",
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                    : ListView.builder(
                      itemCount: filteredHotels.length,
                      itemBuilder: (context, index) {
                        final hotel = filteredHotels[index];
                        return HotelCard(
                          image: hotel['image']!,
                          name: hotel['name']!,
                          location: hotel['location']!,
                          price: hotel['price']!,
                          rating: hotel['rating']!,
                          reviews: hotel['reviews']!,
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          HotelDetailScreen(hotelData: hotel),
                                ),
                              ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
