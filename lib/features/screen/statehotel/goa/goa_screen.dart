import 'package:flutter/material.dart';
import 'package:hotelbooking/features/screen/hoteldetail/hotel_detail_screen.dart';
import 'package:hotelbooking/features/widgets/commonappbar/custom_app_bar.dart';
import 'package:hotelbooking/features/widgets/commoncityscreen/common_city_screen.dart';

class GoaScreen extends StatefulWidget {
  const GoaScreen({super.key});

  @override
  State<GoaScreen> createState() => _GoaScreenState();
}

class _GoaScreenState extends State<GoaScreen> with CityScreenFilterMixin {
  @override
  void initState() {
    super.initState();
    _initializeGoaData();
    initializeFilters();
  }

  void _initializeGoaData() {
    selectedPriceRange = '₹2000 - ₹2500';
    priceRanges = ['₹2000 - ₹2500', '₹2500 - ₹3000', '₹3000 - ₹4000'];
    localities = ["Calangute", "Baga", "Anjuna", "Candolim", "Palolem"];
    allHotels = [
      {
        'name': 'Ocean View Resort',
        'image': 'assets/images/room1.png',
        'location': 'Goa, India',
        'locality': 'Calangute',
        'price': 2500,
        'rating': 4.7,
        'reviews': 156,
        'popularity': 95,
      },
      {
        'name': 'Beach Paradise',
        'image': 'assets/images/room2.png',
        'location': 'Goa, India',
        'locality': 'Baga',
        'price': 2200,
        'rating': 4.4,
        'reviews': 98,
        'popularity': 88,
      },
      {
        'name': 'Sunset Villa',
        'image': 'assets/images/room3.png',
        'location': 'Goa, India',
        'locality': 'Anjuna',
        'price': 3200,
        'rating': 4.8,
        'reviews': 142,
        'popularity': 92,
      },
      {
        'name': 'Coastal Retreat',
        'image': 'assets/images/room1.png',
        'location': 'Goa, India',
        'locality': 'Candolim',
        'price': 2800,
        'rating': 4.6,
        'reviews': 120,
        'popularity': 90,
      },
      {
        'name': 'Palm Beach Resort',
        'image': 'assets/images/room3.png',
        'location': 'Goa, India',
        'locality': 'Palolem',
        'price': 3500,
        'rating': 4.9,
        'reviews': 180,
        'popularity': 97,
      },
      {
        'name': 'Sea Breeze Hotel',
        'image': 'assets/images/room2.png',
        'location': 'Goa, India',
        'locality': 'Calangute',
        'price': 2100,
        'rating': 4.3,
        'reviews': 85,
        'popularity': 82,
      },
      {
        'name': 'Tropical Paradise',
        'image': 'assets/images/room1.png',
        'location': 'Goa, India',
        'locality': 'Baga',
        'price': 3800,
        'rating': 4.8,
        'reviews': 165,
        'popularity': 94,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        mainTitle: 'Goa',
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
