import 'package:flutter/material.dart';

enum CardType { vertical, horizontal, compact }

class CommonHotelCard extends StatelessWidget {
  final String image;
  final String name;
  final double rating;
  final int reviewCount;
  final String location;
  //final int price;
  final int? price;
  final CardType cardType;
  final VoidCallback? onTap;

  const CommonHotelCard({
    super.key,
    required this.image,
    required this.name,
    required this.rating,
    required this.reviewCount,
    required this.location,
    this.price,
    this.cardType = CardType.vertical,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    switch (cardType) {
      case CardType.vertical:
        return _buildVerticalCard(context);
      case CardType.horizontal:
        return _buildHorizontalCard(context);
      case CardType.compact:
        return _buildCompactCard(context);
    }
  }

  Widget _buildVerticalCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 300,
          width: 250,
          decoration: _boxDecoration(),
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
                    child: _favoriteIcon(size: 50),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: StarRating(rating: rating, reviewCount: reviewCount),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: Text(name, style: _titleStyle()),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: _locationRow(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 4),
                child: _priceRow(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 150,
          width: double.infinity,
          decoration: _boxDecoration(),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        image,
                        height: 130,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: _favoriteIcon(size: 30),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StarRating(rating: rating, reviewCount: reviewCount),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        child: Text(name, style: _titleStyle()),
                      ),
                      _locationRow(),
                      _priceRow(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                image,
                height: 100,
                width: 90,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StarRating(rating: rating, reviewCount: reviewCount),
                const SizedBox(height: 8),
                Text(name, style: _titleStyle()),
                const SizedBox(height: 8),
                _locationRow(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _favoriteIcon({required double size}) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withOpacity(0.2),
      ),
      child: const Icon(Icons.favorite_border, color: Colors.white),
    );
  }

  TextStyle _titleStyle() {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  Widget _locationRow() {
    return Row(
      children: [
        const Icon(Icons.location_on_outlined, color: Colors.black, size: 16),
        const SizedBox(width: 6),
        Text(
          location,
          style: const TextStyle(fontSize: 15, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _priceRow() {
    return Row(
      children: [
        Text(
          "₹$price",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Text("/night", style: TextStyle(fontSize: 20)),
      ],
    );
  }
}

class StarRating extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final double size;
  final Color color;

  const StarRating({
    super.key,
    required this.rating,
    required this.reviewCount,
    this.size = 18,
    this.color = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    return Row(
      children: [
        ...List.generate(
          fullStars,
          (_) => Icon(Icons.star, size: size, color: color),
        ),
        if (hasHalfStar) Icon(Icons.star_half, size: size, color: color),
        ...List.generate(
          emptyStars,
          (_) => Icon(Icons.star_border, size: size, color: color),
        ),
        const SizedBox(width: 5),
        Text(
          "($reviewCount)",
          style: TextStyle(fontSize: size * 0.8, color: Colors.grey),
        ),
      ],
    );
  }
}
