import 'package:flutter/material.dart';
import 'package:hotelbooking/features/screen/hoteldetail/hotel_detail_screen.dart';
import 'package:hotelbooking/features/widgets/commonappbar/custom_app_bar.dart';
import 'package:hotelbooking/features/widgets/commoncityscreen/common_city_screen.dart';

class JaipurScreen extends StatefulWidget {
  const JaipurScreen({super.key});

  @override
  State<JaipurScreen> createState() => _JaipurScreenState();
}

class _JaipurScreenState extends State<JaipurScreen>
    with CityScreenFilterMixin {
  @override
  void initState() {
    super.initState();
    _initializeJaipurData();
    initializeFilters();
  }

  void _initializeJaipurData() {
    selectedPriceRange = '₹1800 - ₹2200';
    priceRanges = ['₹1800 - ₹2200', '₹2200 - ₹2800', '₹2800 - ₹3500'];
    localities = [
      "Pink City",
      "Malviya Nagar",
      "C-Scheme",
      "Vaishali Nagar",
      "Mansarovar",
    ];
    allHotels = [
      {
        'name': 'Paradise Mint',
        'image': 'assets/images/room1.png',
        'location': 'Jaipur, Rajasthan',
        'locality': 'Pink City',
        'price': 1800,
        'rating': 4.3,
        'reviews': 89,
        'popularity': 88,
      },
      {
        'name': 'Royal Palace Hotel',
        'image': 'assets/images/room2.png',
        'location': 'Jaipur, Rajasthan',
        'locality': 'C-Scheme',
        'price': 2200,
        'rating': 4.6,
        'reviews': 134,
        'popularity': 94,
      },
      {
        'name': 'Heritage Haveli',
        'image': 'assets/images/room3.png',
        'location': 'Jaipur, Rajasthan',
        'locality': 'Pink City',
        'price': 2800,
        'rating': 4.7,
        'reviews': 156,
        'popularity': 96,
      },
      {
        'name': 'Rajputana Palace',
        'image': 'assets/images/room1.png',
        'location': 'Jaipur, Rajasthan',
        'locality': 'Malviya Nagar',
        'price': 3200,
        'rating': 4.8,
        'reviews': 178,
        'popularity': 98,
      },
      {
        'name': 'Pink City Suites',
        'image': 'assets/images/room3.png',
        'location': 'Jaipur, Rajasthan',
        'locality': 'Vaishali Nagar',
        'price': 1950,
        'rating': 4.2,
        'reviews': 76,
        'popularity': 85,
      },
      {
        'name': 'Maharaja Hotel',
        'image': 'assets/images/room2.png',
        'location': 'Jaipur, Rajasthan',
        'locality': 'Mansarovar',
        'price': 2500,
        'rating': 4.4,
        'reviews': 102,
        'popularity': 90,
      },
      {
        'name': 'Golden Triangle Resort',
        'image': 'assets/images/room1.png',
        'location': 'Jaipur, Rajasthan',
        'locality': 'C-Scheme',
        'price': 3400,
        'rating': 4.9,
        'reviews': 195,
        'popularity': 99,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        mainTitle: 'Jaipur',
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
