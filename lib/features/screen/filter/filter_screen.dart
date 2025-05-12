import 'package:flutter/material.dart';
import 'package:hotelbooking/features/screen/hoteldetail/hotel_detail_screen.dart';
import 'dart:math';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  int _selectedOption = -1;
  String selectedPriceRange = '\$10 - \$100';
  final List<String> priceRanges = [
    '\$10 - \$100',
    '\$100 - \$500',
    '\$500 - \$2500',
  ];
  final List<String> localities = [
    "Andheri East",
    "Thane",
    "Bandra",
    "Dadar",
    "Navi Mumbai",
  ];
  List<bool> localitySelections = List.filled(5, false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          const SizedBox(height: 10),
          _buildFilterOptionsRow(),
          Expanded(
            child: ListView(
              children: [
                _buildHotelCard(
                  image: "assets/images/room1.png",
                  name: "Malon Greens",
                  location: "Mumbai, Maharashtra",
                  price: 120,
                  rating: 5.0,
                  reviews: 120,
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HotelDetailScreen(),
                        ),
                      ),
                ),
                _buildHotelCard(
                  image: "assets/images/room2.png",
                  name: "Sabro Prime",
                  location: "Mumbai, Maharashtra",
                  price: 90,
                  rating: 5.0,
                  reviews: 120,
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HotelDetailScreen(),
                        ),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        "Mumbai",
        style: TextStyle(color: Colors.black, fontSize: 20),
      ),
    );
  }

  Widget _buildFilterOptionsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterButton(
            label: "Sort",
            icon: Icons.sort,
            onTap: _showSortOptions,
          ),
          _buildFilterButton(
            label: "Locality",
            icon: Icons.arrow_drop_down,
            onTap: _showLocalityFilter,
          ),
          _buildFilterButton(
            label: "Price",
            icon: Icons.arrow_drop_down,
            onTap: _showPriceFilter,
          ),
          _buildFilterButton(
            label: "Categories",
            icon: Icons.arrow_drop_down,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          width:
              label == "Locality"
                  ? 120
                  : label == "Categories"
                  ? 150
                  : 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                ),
                Icon(icon, color: Colors.black, size: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHotelCard({
    required String image,
    required String name,
    required String location,
    required int price,
    required double rating,
    required int reviews,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 300,
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        image,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
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
                child: StarRating(rating: rating, reviewCount: reviews),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 4,
                ),
                child: Text(
                  name,
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
                      location,
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
                      "\$ $price",
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
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 350,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sort by',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  _buildSortOption(
                    icon: Icons.trending_up_outlined,
                    label: 'Popularity',
                    index: 0,
                    currentIndex: _selectedOption,
                    onTap: () => setState(() => _selectedOption = 0),
                  ),
                  _buildSortOption(
                    icon: Icons.location_on_outlined,
                    label: 'Near by location',
                    index: 1,
                    currentIndex: _selectedOption,
                    onTap: () => setState(() => _selectedOption = 1),
                  ),
                  _buildSortOption(
                    icon: Icons.star_border,
                    label: 'Guest rating',
                    index: 2,
                    currentIndex: _selectedOption,
                    onTap: () => setState(() => _selectedOption = 2),
                  ),
                  _buildSortOption(
                    icon: Icons.attach_money,
                    label: 'Price - low to high',
                    index: 3,
                    currentIndex: _selectedOption,
                    onTap: () => setState(() => _selectedOption = 3),
                  ),
                  _buildSortOption(
                    icon: Icons.attach_money,
                    label: 'Price - high to low',
                    index: 4,
                    currentIndex: _selectedOption,
                    onTap: () => setState(() => _selectedOption = 4),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSortOption({
    required IconData icon,
    required String label,
    required int index,
    required int currentIndex,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        onTap();
        Navigator.pop(context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.black, size: 30.0),
              const SizedBox(width: 10),
              Text(label, style: const TextStyle(fontSize: 20)),
            ],
          ),
          if (currentIndex == index)
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue, width: 2.0),
              ),
              child: const Icon(Icons.check, color: Colors.blue),
            ),
        ],
      ),
    );
  }

  void _showLocalityFilter() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 400,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Locality",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: localities.length,
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                          value: localitySelections[index],
                          onChanged: (bool? value) {
                            setState(() => localitySelections[index] = value!);
                          },
                          title: Text(
                            localities[index],
                            style: const TextStyle(fontSize: 20),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                localitySelections = List.filled(
                                  localities.length,
                                  false,
                                );
                              });
                            },
                            child: const Text(
                              "Clear All",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              backgroundColor: const Color(0xFF1190F8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Apply",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showPriceFilter() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final priceDistribution = [120, 80, 40]; // Sample data for chart
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Price Range',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...priceRanges.asMap().entries.map((entry) {
                    final index = entry.key;
                    final range = entry.value;
                    return ListTile(
                      title: Text(range, style: const TextStyle(fontSize: 20)),
                      subtitle: Text(
                        '${priceDistribution[index]} options',
                        style: const TextStyle(fontSize: 14),
                      ),
                      leading: Radio<String>(
                        value: range,
                        groupValue: selectedPriceRange,
                        onChanged: (String? value) {
                          setState(() => selectedPriceRange = value!);
                        },
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                  const Text(
                    'Price Distribution',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 150,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:
                          priceRanges.asMap().entries.map((entry) {
                            final index = entry.key;
                            final range = entry.value;
                            final heightFactor =
                                priceDistribution[index] /
                                priceDistribution.reduce(max);
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: 40,
                                  height: 105 * heightFactor,
                                  decoration: BoxDecoration(
                                    color:
                                        selectedPriceRange == range
                                            ? Colors.blue
                                            : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(range.split(' - ')[0]),
                              ],
                            );
                          }).toList(),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            setState(() => selectedPriceRange = priceRanges[0]);
                          },
                          child: const Text(
                            "Reset",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            backgroundColor: const Color(0xFF1190F8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Apply",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
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
