import 'package:flutter/material.dart';
import 'package:hotelbooking/features/widgets/commonbottomsheet/Common_BottomSheet.dart';
import 'dart:math';

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

class FilterButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const FilterButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
}

class HotelCard extends StatelessWidget {
  final String image;
  final String name;
  final String location;
  final int price;
  final double rating;
  final int reviews;
  final VoidCallback onTap;

  const HotelCard({
    super.key,
    required this.image,
    required this.name,
    required this.location,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                      " ₹$price",
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
}

// Common Sort Option Widget
class SortOption extends StatelessWidget {
  final BuildContext context;
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final VoidCallback onTap;

  const SortOption({
    super.key,
    required this.context,
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
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
                child: const Icon(Icons.check, color: Colors.blue, size: 20),
              ),
          ],
        ),
      ),
    );
  }
}

// Common Filter Mixin
mixin CityScreenFilterMixin<T extends StatefulWidget> on State<T> {
  int selectedOption = -1;
  String selectedPriceRange = '';
  List<String> priceRanges = [];
  List<String> localities = [];
  List<bool> localitySelections = [];
  List<Map<String, dynamic>> allHotels = [];
  List<Map<String, dynamic>> filteredHotels = [];

  void initializeFilters() {
    filteredHotels = List.from(allHotels);
    localitySelections = List.filled(localities.length, false);
  }

  void applyFilters() {
    setState(() {
      filteredHotels = List.from(allHotels);

      // Apply locality filter
      if (localitySelections.contains(true)) {
        List<String> selectedLocalities = [];
        for (int i = 0; i < localities.length; i++) {
          if (localitySelections[i]) {
            selectedLocalities.add(localities[i]);
          }
        }

        if (selectedLocalities.isNotEmpty) {
          filteredHotels =
              filteredHotels
                  .where(
                    (hotel) => selectedLocalities.contains(hotel['locality']),
                  )
                  .toList();
        }
      }

      // Apply price filter
      int minPrice = 0;
      int maxPrice = 5000;

      if (priceRanges.isNotEmpty && selectedPriceRange.isNotEmpty) {
        final priceRange = selectedPriceRange.replaceAll('₹', '').split(' - ');
        if (priceRange.length == 2) {
          minPrice = int.tryParse(priceRange[0]) ?? 0;
          maxPrice = int.tryParse(priceRange[1]) ?? 5000;
        }
      }

      filteredHotels =
          filteredHotels
              .where(
                (hotel) =>
                    hotel['price'] >= minPrice && hotel['price'] <= maxPrice,
              )
              .toList();

      // Apply sorting
      if (selectedOption == 0) {
        filteredHotels.sort(
          (a, b) => b['popularity'].compareTo(a['popularity']),
        );
      } else if (selectedOption == 2) {
        filteredHotels.sort((a, b) => b['rating'].compareTo(a['rating']));
      } else if (selectedOption == 3) {
        filteredHotels.sort((a, b) => a['price'].compareTo(b['price']));
      } else if (selectedOption == 4) {
        filteredHotels.sort((a, b) => b['price'].compareTo(a['price']));
      }
    });
  }

  Widget buildFilterOptionsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          FilterButton(
            label: "Sort",
            icon: Icons.sort,
            onTap: () => showSortOptions(context),
          ),
          FilterButton(
            label: "Locality",
            icon: Icons.arrow_drop_down,
            onTap: () => showLocalityFilter(context),
          ),
          FilterButton(
            label: "Price",
            icon: Icons.arrow_drop_down,
            onTap: () => showPriceFilter(context),
          ),
          FilterButton(
            label: "Categories",
            icon: Icons.arrow_drop_down,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  void showSortOptions(BuildContext context) {
    showCommonBottomSheet(
      context: context,
      child: StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sort by',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SortOption(
                  context: context,
                  icon: Icons.trending_up_outlined,
                  label: 'Popularity',
                  index: 0,
                  currentIndex: selectedOption,
                  onTap: () {
                    setState(() => selectedOption = 0);
                    applyFilters();
                  },
                ),
                SortOption(
                  context: context,
                  icon: Icons.location_on_outlined,
                  label: 'Near by location',
                  index: 1,
                  currentIndex: selectedOption,
                  onTap: () {
                    setState(() => selectedOption = 1);
                    applyFilters();
                  },
                ),
                SortOption(
                  context: context,
                  icon: Icons.star_border,
                  label: 'Guest rating',
                  index: 2,
                  currentIndex: selectedOption,
                  onTap: () {
                    setState(() => selectedOption = 2);
                    applyFilters();
                  },
                ),
                SortOption(
                  context: context,
                  icon: Icons.attach_money,
                  label: 'Price - low to high',
                  index: 3,
                  currentIndex: selectedOption,
                  onTap: () {
                    setState(() => selectedOption = 3);
                    applyFilters();
                  },
                ),
                SortOption(
                  context: context,
                  icon: Icons.attach_money,
                  label: 'Price - high to low',
                  index: 4,
                  currentIndex: selectedOption,
                  onTap: () {
                    setState(() => selectedOption = 4);
                    applyFilters();
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }

  void showLocalityFilter(BuildContext context) {
    showCommonBottomSheet(
      context: context,
      child: StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Locality",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: ListView.builder(
                    shrinkWrap: true,
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
                            applyFilters();
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
      ),
    );
  }

  void showPriceFilter(BuildContext context) {
    showCommonBottomSheet(
      context: context,
      child: StatefulBuilder(
        builder: (context, setState) {
          final priceDistribution = [100, 85, 70]; // Default distribution
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Price Range',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...priceRanges.asMap().entries.map((entry) {
                  final range = entry.value;
                  return ListTile(
                    title: Text(range, style: const TextStyle(fontSize: 20)),
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
                              index < priceDistribution.length
                                  ? priceDistribution[index] /
                                      priceDistribution.reduce(max)
                                  : 0.5;
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
                const SizedBox(height: 20),
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
                          setState(
                            () =>
                                selectedPriceRange =
                                    priceRanges.isNotEmpty
                                        ? priceRanges[0]
                                        : '',
                          );
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
                        onPressed: () {
                          applyFilters();
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
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
