import 'package:flutter/material.dart';
import 'package:hotelbooking/features/screen/payment/payment_screen.dart';
import 'package:hotelbooking/features/screen/review/review_screen.dart';
import 'package:hotelbooking/features/widgets/commonbutton/common_buttom.dart';
import 'package:hotelbooking/features/widgets/commonbottomsheet/Common_BottomSheet.dart';
import 'package:intl/intl.dart';

class HotelDetailScreen extends StatefulWidget {
  final Map<String, dynamic> hotelData;

  const HotelDetailScreen({super.key, required this.hotelData});

  @override
  State<HotelDetailScreen> createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends State<HotelDetailScreen> {
  int quantity = 1;
  int adultCount = 1;
  int childrenCount = 0;
  int infantsCount = 0;
  DateTime? checkInDate;
  DateTime? checkOutDate;
  int numberOfNights = 1;
  bool isSelectingCheckIn = true;

  @override
  void initState() {
    super.initState();
    // Initialize with valid default dates
    _initializeDates();
  }

  void _initializeDates() {
    final now = DateTime.now();
    // Set check-in to today
    checkInDate = DateTime(now.year, now.month, now.day);
    // Set check-out to tomorrow
    checkOutDate = DateTime(now.year, now.month, now.day + 1);
    numberOfNights = _calculateNights(checkInDate!, checkOutDate!);
  }

  bool _isDateValid(DateTime date, {bool isCheckIn = false}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (isCheckIn) {
      // Check-in date cannot be before today
      return !date.isBefore(today);
    } else {
      // Check-out date must be after check-in date
      return checkInDate != null && date.isAfter(checkInDate!);
    }
  }

  DateTime _getMinimumDate({bool isCheckIn = false}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (isCheckIn) {
      return today;
    } else {
      // For check-out, minimum date is check-in + 1 day
      return checkInDate?.add(const Duration(days: 1)) ??
          today.add(const Duration(days: 1));
    }
  }

  DateTime _getValidInitialDate({bool isCheckIn = false}) {
    final minDate = _getMinimumDate(isCheckIn: isCheckIn);
    final maxDate = DateTime.now().add(const Duration(days: 365));

    DateTime targetDate;
    if (isCheckIn) {
      targetDate = checkInDate ?? minDate;
    } else {
      targetDate = checkOutDate ?? minDate.add(const Duration(days: 1));
    }

    // Ensure the target date is within valid range
    if (targetDate.isBefore(minDate)) {
      return minDate;
    } else if (targetDate.isAfter(maxDate)) {
      return maxDate;
    } else {
      return targetDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderImage(),
                    _buildHotelInfo(),
                    _buildOverviewSection(),
                    _buildPhotosSection(),
                    _buildHostInfo(),
                    _buildAmenitiesSection(),
                  ],
                ),
              ),
            ),
            // Fixed bottom section
            _buildFixedPriceAndBookingSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
          child: Image.asset(
            widget.hotelData['image'] ?? "assets/images/room1.png",
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          left: 25,
          top: 25,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        const Positioned(
          right: 25,
          top: 25,
          child: Icon(Icons.favorite_border, color: Colors.white, size: 30),
        ),
      ],
    );
  }

  Widget _buildHotelInfo() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReviewScreen()),
              );
            },
            child: StarRating(
              rating: widget.hotelData['rating']?.toDouble() ?? 5.0,
              reviewCount: widget.hotelData['reviews'] ?? 120,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.hotelData['name'] ?? "Hotel Name",
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: Colors.black),
              const SizedBox(width: 8),
              Text(
                widget.hotelData['location'] ?? "Location",
                style: const TextStyle(fontSize: 15, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Divider(color: Colors.grey, thickness: 1),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20.0, top: 10),
          child: Text(
            "Overview",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Text(
            widget.hotelData['description'] ??
                'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.justify,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Divider(color: Colors.grey, thickness: 1),
        ),
      ],
    );
  }

  Widget _buildPhotosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Photos",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "See All",
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 130,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(4, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "assets/images/photo${index + 1}.jpeg",
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildHostInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Room in boutique hotel hosted by ${widget.hotelData['hostName'] ?? 'Host'}",
                  style: const TextStyle(fontSize: 19),
                ),
              ),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(
                      widget.hotelData['hostImage'] ??
                          "assets/images/room1.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, bottom: 10),
          child: Text(
            widget.hotelData['roomDetails'] ??
                '\u2022 2 guests \u2022 1 bedroom \u2022 1 bed \u2022 1 bathroom',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Divider(color: Colors.grey, thickness: 1),
        ),
      ],
    );
  }

  Widget _buildAmenitiesSection() {
    return Column(
      children: [
        _buildAmenityItem(
          icon: Icons.cleaning_services_outlined,
          title: "Enhanced Clean",
          description:
              "This host committed to Airbnb's clone 5-step enhanced cleaning process",
        ),
        _buildAmenityItem(
          icon: Icons.location_on_outlined,
          title: "Great Location",
          description: "95% of recent guests give the location a 5-star rating",
        ),
        _buildAmenityItem(
          icon: Icons.key_outlined,
          title: "Great check-in experience",
          description:
              "95% of recent guests gave the check-in process 5-star rating",
        ),
        _buildAmenityItem(
          icon: Icons.calendar_today_outlined,
          title: "Free cancellation until 2:00 PM on 8 May",
          description: "",
        ),
      ],
    );
  }

  Widget _buildAmenityItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 30),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (description.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          description,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Divider(color: Colors.grey, thickness: 1),
        ),
      ],
    );
  }

  Widget _buildFixedPriceAndBookingSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "₹${widget.hotelData['price'] ?? 120}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text: "/night",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              CustomButton(
                text: "Book Now",
                onPressed: () => _showDatePicker(context),
                width: 170,
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _calculateNights(DateTime checkIn, DateTime checkOut) {
    return checkOut.difference(checkIn).inDays;
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  void _showDatePicker(BuildContext context) {
    final int price = widget.hotelData['price'] ?? 120;

    if (checkInDate == null || checkOutDate == null) {
      _initializeDates();
    }

    _validateAndCorrectDates();

    numberOfNights = _calculateNights(checkInDate!, checkOutDate!);
    final totalPrice = price * numberOfNights;

    showCommonBottomSheet(
      context: context,
      child: StatefulBuilder(
        builder: (context, setModalState) {
          // Create a key to force rebuild of CalendarDatePicker when switching modes
          final Key calendarKey = Key(
            isSelectingCheckIn ? 'check-in' : 'check-out',
          );

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Select Dates",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "₹$price",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1190F8),
                            ),
                          ),
                          const TextSpan(
                            text: "/night",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setModalState(() {
                            isSelectingCheckIn = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color:
                                isSelectingCheckIn
                                    ? const Color(0xFF1190F8)
                                    : Colors.grey[200],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "CHECK-IN",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isSelectingCheckIn
                                          ? Colors.white
                                          : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatDate(checkInDate!),
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      isSelectingCheckIn
                                          ? Colors.white
                                          : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setModalState(() {
                            isSelectingCheckIn = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color:
                                !isSelectingCheckIn
                                    ? const Color(0xFF1190F8)
                                    : Colors.grey[200],
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "CHECK-OUT",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      !isSelectingCheckIn
                                          ? Colors.white
                                          : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatDate(checkOutDate!),
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      !isSelectingCheckIn
                                          ? Colors.white
                                          : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                // Use a Builder to ensure we have the latest context
                Builder(
                  builder: (context) {
                    // Get the valid dates for the current mode
                    final DateTime initialDate = _getValidInitialDate(
                      isCheckIn: isSelectingCheckIn,
                    );
                    final DateTime firstDate = _getMinimumDate(
                      isCheckIn: isSelectingCheckIn,
                    );
                    final DateTime lastDate = DateTime.now().add(
                      const Duration(days: 365),
                    );

                    // Ensure initialDate is not before firstDate
                    if (initialDate.isBefore(firstDate)) {
                      return Text(
                        "Error: Invalid date range. Please try again.",
                        style: TextStyle(color: Colors.red),
                      );
                    }

                    return CalendarDatePicker(
                      key: calendarKey, // Force rebuild when switching modes
                      initialDate: initialDate,
                      firstDate: firstDate,
                      lastDate: lastDate,
                      onDateChanged: (date) {
                        setModalState(() {
                          if (isSelectingCheckIn) {
                            // Validate check-in date
                            if (_isDateValid(date, isCheckIn: true)) {
                              checkInDate = date;

                              // Auto-adjust check-out if it's not valid anymore
                              if (!_isDateValid(
                                checkOutDate!,
                                isCheckIn: false,
                              )) {
                                checkOutDate = checkInDate!.add(
                                  const Duration(days: 1),
                                );
                              }
                            } else {
                              // Show error or set to minimum valid date
                              checkInDate = _getMinimumDate(isCheckIn: true);
                              checkOutDate = checkInDate!.add(
                                const Duration(days: 1),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Check-in date cannot be before today',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } else {
                            if (_isDateValid(date, isCheckIn: false)) {
                              checkOutDate = date;
                            } else {
                              checkOutDate = _getMinimumDate(isCheckIn: false);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Check-out date must be after check-in date',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }

                          numberOfNights = _calculateNights(
                            checkInDate!,
                            checkOutDate!,
                          );
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Stay Duration:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "$numberOfNights ${numberOfNights > 1 ? 'Nights' : 'Night'}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1190F8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total Price:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "₹${price * numberOfNights}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1190F8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                CustomButton(
                  text: "Select Guest",
                  onPressed: () {
                    Navigator.pop(context);
                    _showGuestSelector(context);
                  },
                  width: double.infinity,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _validateAndCorrectDates() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Ensure check-in is not before today
    if (checkInDate!.isBefore(today)) {
      checkInDate = today;
    }

    // Ensure check-out is after check-in
    if (!checkOutDate!.isAfter(checkInDate!)) {
      checkOutDate = checkInDate!.add(const Duration(days: 1));
    }
  }

  void _showGuestSelector(BuildContext context) {
    final int price = widget.hotelData['price'] ?? 120;
    final totalPrice = price * numberOfNights;

    showCommonBottomSheet(
      context: context,
      child: StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Select Guest",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "₹$totalPrice",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1190F8),
                            ),
                          ),
                          const TextSpan(
                            text: " total",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF1190F8),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "${_formatDate(checkInDate!)} - ${_formatDate(checkOutDate!)} · $numberOfNights ${numberOfNights > 1 ? 'nights' : 'night'}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                _buildGuestCounter(
                  title: "Adults",
                  subtitle: "Ages 14 or above",
                  count: adultCount,
                  onIncrement: () {
                    setState(() => adultCount++);
                    setModalState(() {});
                  },
                  onDecrement: () {
                    if (adultCount > 1) {
                      setState(() => adultCount--);
                      setModalState(() {});
                    }
                  },
                ),
                const Divider(),
                _buildGuestCounter(
                  title: "Children",
                  subtitle: "Ages 2-13",
                  count: childrenCount,
                  onIncrement: () {
                    setState(() => childrenCount++);
                    setModalState(() {});
                  },
                  onDecrement: () {
                    if (childrenCount > 0) {
                      setState(() => childrenCount--);
                      setModalState(() {});
                    }
                  },
                ),
                const Divider(),
                _buildGuestCounter(
                  title: "Infants",
                  subtitle: "Under 2",
                  count: infantsCount,
                  onIncrement: () {
                    setState(() => infantsCount++);
                    setModalState(() {});
                  },
                  onDecrement: () {
                    if (infantsCount > 0) {
                      setState(() => infantsCount--);
                      setModalState(() {});
                    }
                  },
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "₹$price × $numberOfNights nights",
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            "₹$totalPrice",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "₹$totalPrice",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Next",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => PaymentScreen(
                              hotelData: widget.hotelData,
                              selectedDate: checkInDate,
                              checkOutDate: checkOutDate,
                              numberOfNights: numberOfNights,
                              adultCount: adultCount,
                              childrenCount: childrenCount,
                              infantsCount: infantsCount,
                            ),
                      ),
                    );
                  },
                  width: double.infinity,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGuestCounter({
    required String title,
    required String subtitle,
    required int count,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  offset: const Offset(2, 2),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: onDecrement,
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF1190F8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    count.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: onIncrement,
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF1190F8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
