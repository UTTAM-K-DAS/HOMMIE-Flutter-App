import 'package:flutter/material.dart';

class PromotionSection extends StatelessWidget {
  const PromotionSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4CAF50),
            Color(0xFF2E7D32),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '20% OFF',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'On your first booking',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to booking screen or show services
                    Navigator.pushNamed(context, '/view-all', arguments: {
                      'category': 'all',
                      'title': 'Book a Service',
                      'promotion': true,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF4CAF50),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Try to load image, fallback to icon if not available
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: _buildPromotionImage(),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: Image.asset(
        'https://via.placeholder.com/300x150/FF5722/FFFFFF?text=20%25+OFF',
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to icon if image fails to load
          return Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.local_offer_rounded,
              size: 40,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
