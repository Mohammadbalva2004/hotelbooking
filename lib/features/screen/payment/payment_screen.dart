import 'package:flutter/material.dart';
import 'package:hotelbooking/features/screen/home/home_screen.dart';
import 'package:hotelbooking/features/widgets/commonappbar/custom_app_bar.dart';
import 'package:hotelbooking/features/widgets/commonbutton/common_buttom.dart';
import 'package:hotelbooking/features/widgets/commontextfromfild/Common_Text_FormField.dart';
import 'package:hotelbooking/features/widgets/commonbottomsheet/Common_BottomSheet.dart';

void main() {
  runApp(const MaterialApp(home: PaymentScreen()));
}

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedPaymentOption = 0;

  final TextEditingController cardHolderController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        mainTitle: 'confirm & Pay',
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Card
            _buildPropertyCard(),

            // Booking Details Section
            const SectionHeader(title: "Your Booking Details"),
            EditableInfoRow(
              title: "Dates",
              value: "May 06,2023 - May 08,2023",
              onEditPressed: () => _editDates(),
            ),
            const SizedBox(height: 15),
            EditableInfoRow(
              title: "Guests",
              value: "2 adults | 1 children",
              onEditPressed: () => _editGuests(),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10),
              child: Divider(color: Colors.grey, thickness: 1),
            ),

            // Payment Options Section
            const SectionHeader(title: "Choose how to pay"),
            PaymentOptionRow(
              title: "Pay in full",
              subtitle: "Pay the total now and you're all set",
              value: 0,
              groupValue: _selectedPaymentOption,
              onChanged:
                  (value) => setState(() => _selectedPaymentOption = value!),
            ),
            PaymentOptionRow(
              title: "Pay part now, part later",
              subtitle: "Pay part now and you're all set",
              value: 1,
              groupValue: _selectedPaymentOption,
              onChanged:
                  (value) => setState(() => _selectedPaymentOption = value!),
            ),

            // Payment Methods Section
            const SectionHeader(title: "Pay with"),
            _buildPaymentMethods(),
            const Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10),
              child: Divider(color: Colors.grey, thickness: 1),
            ),

            // Price Details Section
            const SectionHeader(title: "Price Details"),
            const PriceDetailRow(label: "\$ 120 x 3 nights", value: "\$360.00"),
            const PriceDetailRow(label: "Discount", value: "\$150.00"),
            const PriceDetailRow(
              label: "Occupancy taxes and fees",
              value: "\$10.00",
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10),
              child: Divider(color: Colors.grey, thickness: 1),
            ),
            const PriceDetailRow(
              label: "Grand Total",
              value: "\$320.00",
              isTotal: true,
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomButton(
                text: "Pay Now",
                width: double.infinity,
                height: 50,
                onPressed: () {
                  showCommonBottomSheet(
                    context: context,
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return Container(
                          height: 385,
                          width: double.infinity,
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/icon/submit.jpg",
                                height: 150,
                                width: 150,
                              ),
                              const Text(
                                "Payment Received ",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                "Successfully",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Congratulation",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  Image.asset(
                                    "assets/icon/party.png",
                                    height: 30,
                                    width: 30,
                                  ),
                                ],
                              ),
                              const Text(
                                "Your booking has been confirmed",
                                style: TextStyle(fontSize: 17),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 20,
                                ),
                                child: CustomButton(
                                  text: "Back To Home",
                                  width: double.infinity,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => const HomeScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyCard() {
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
                      "assets/images/room1.png",
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
                  const StarRating(rating: 5, reviewCount: 120),
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: Text(
                      "Malon Greens",
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
                        "Mumbai,Maharashtra",
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 7.0),
                    child: Row(
                      children: [
                        Text("2 adults", style: const TextStyle(fontSize: 20)),
                        const Text(
                          " | 1 children",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 10.0, right: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Payment method",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  _buildPaymentMethodIcon("assets/icon/visa.png"),
                  const SizedBox(width: 5),
                  _buildPaymentMethodIcon("assets/icon/Mastercard_logo.png"),
                  const SizedBox(width: 5),
                  _buildPaymentMethodIcon("assets/icon/paypal.png"),
                  const SizedBox(width: 5),
                  _buildPaymentMethodIcon("assets/icon/google-pay.png"),
                ],
              ),
            ],
          ),

          GestureDetector(
            onTap: () {
              showCommonBottomSheet(
                context: context,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Container(
                      height: 385,
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Add New Card",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 0.2,
                                    blurRadius: 6,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: CommonTextFormField(
                                controller: cardNumberController,
                                labelText: 'Card Number',
                                labelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 17, 144, 248),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 0.2,
                                    blurRadius: 6,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: CommonTextFormField(
                                controller: cardHolderController,
                                labelText: 'Card Holder Name',
                                labelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 17, 144, 248),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 0.2,
                                          blurRadius: 6,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: CommonTextFormField(
                                      controller: expiryDateController,
                                      labelText: 'Expiry Date',
                                      labelStyle: const TextStyle(
                                        color: Color.fromARGB(
                                          255,
                                          17,
                                          144,
                                          248,
                                        ),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                      keyboardType: TextInputType.datetime,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 0.2,
                                          blurRadius: 6,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: CommonTextFormField(
                                      controller: cvvController,
                                      labelText: 'CVV',
                                      labelStyle: const TextStyle(
                                        color: Color.fromARGB(
                                          255,
                                          17,
                                          144,
                                          248,
                                        ),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 20,
                            ),
                            child: CustomButton(
                              text: "Add Card",
                              width: double.infinity,
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
            child: Container(
              height: 50,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 2,
                  color: const Color.fromARGB(255, 17, 144, 248),
                ),
              ),
              child: const Center(
                child: Text(
                  "Add",
                  style: TextStyle(
                    color: Color.fromARGB(255, 17, 144, 248),
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodIcon(String assetPath) {
    return Container(
      height: 40,
      width: 60,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Image.asset(assetPath, fit: BoxFit.contain),
      ),
    );
  }

  void _editDates() {
    // Implement date editing logic
  }

  void _editGuests() {
    // Implement guest editing logic
  }

  // ignore: unused_element
  void _handlePayment() {
    // Implement payment logic
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class EditableInfoRow extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onEditPressed;

  const EditableInfoRow({
    super.key,
    required this.title,
    required this.value,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 10.0, right: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ],
          ),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 2,
                color: const Color.fromARGB(255, 17, 144, 248),
              ),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.edit,
                size: 30,
                color: Color.fromARGB(255, 17, 144, 248),
              ),
              onPressed: onEditPressed,
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentOptionRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final int value;
  final int groupValue;
  final ValueChanged<int?> onChanged;

  const PaymentOptionRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 10.0, right: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 19, color: Colors.grey),
                  ),
                ],
              ),
              Radio<int>(
                value: value,
                groupValue: groupValue,
                onChanged: onChanged,
                activeColor: const Color.fromARGB(255, 17, 144, 248),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10),
          child: Divider(color: Colors.grey, thickness: 1),
        ),
      ],
    );
  }
}

class PriceDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const PriceDetailRow({
    super.key,
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 20 : 18,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 20 : 18,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
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
