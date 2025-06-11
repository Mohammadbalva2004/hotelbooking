import 'package:flutter/material.dart';
import 'package:hotelbooking/features/screen/hoteldetail/hotel_detail_screen.dart';
import 'package:hotelbooking/features/widgets/commonappbar/custom_app_bar.dart';
import 'package:hotelbooking/features/widgets/commoncityscreen/common_city_screen.dart';

class PuneScreen extends StatefulWidget {
  const PuneScreen({super.key});

  @override
  State<PuneScreen> createState() => _PuneScreenState();
}

class _PuneScreenState extends State<PuneScreen> with CityScreenFilterMixin {
  @override
  void initState() {
    super.initState();
    _initializePuneData();
    initializeFilters();
  }

  void _initializePuneData() {
    selectedPriceRange = '₹1100 - ₹1400';
    priceRanges = ['₹1100 - ₹1400', '₹1400 - ₹1800', '₹1800 - ₹2500'];
    localities = ["Hinjewadi", "Koregaon Park", "Baner", "Wakad", "Kharadi"];
    allHotels = [
      {
        'name': 'Tech Hub Hotel',
        'image': 'assets/images/room1.png',
        'location': 'Pune, Maharashtra',
        'locality': 'Hinjewadi',
        'price': 1400,
        'rating': 4.1,
        'reviews': 67,
        'popularity': 82,
      },
      {
        'name': 'IT Park Residency',
        'image': 'assets/images/room2.png',
        'location': 'Pune, Maharashtra',
        'locality': 'Wakad',
        'price': 1100,
        'rating': 4.0,
        'reviews': 45,
        'popularity': 78,
      },
      {
        'name': 'Koregaon Suites',
        'image': 'assets/images/room3.png',
        'location': 'Pune, Maharashtra',
        'locality': 'Koregaon Park',
        'price': 1800,
        'rating': 4.4,
        'reviews': 89,
        'popularity': 88,
      },
      {
        'name': 'Baner Business Hotel',
        'image': 'assets/images/room1.png',
        'location': 'Pune, Maharashtra',
        'locality': 'Baner',
        'price': 1600,
        'rating': 4.2,
        'reviews': 72,
        'popularity': 85,
      },
      {
        'name': 'Kharadi Corporate Stay',
        'image': 'assets/images/room3.png',
        'location': 'Pune, Maharashtra',
        'locality': 'Kharadi',
        'price': 2200,
        'rating': 4.5,
        'reviews': 95,
        'popularity': 90,
      },
      {
        'name': 'Pune Central Hotel',
        'image': 'assets/images/room2.png',
        'location': 'Pune, Maharashtra',
        'locality': 'Koregaon Park',
        'price': 1350,
        'rating': 4.1,
        'reviews': 58,
        'popularity': 80,
      },
      {
        'name': 'Executive Towers',
        'image': 'assets/images/room1.png',
        'location': 'Pune, Maharashtra',
        'locality': 'Hinjewadi',
        'price': 2400,
        'rating': 4.6,
        'reviews': 112,
        'popularity': 92,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        mainTitle: 'Pune',
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
