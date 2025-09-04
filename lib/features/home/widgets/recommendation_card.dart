import 'package:flutter/material.dart';

class RecommendationCard extends StatefulWidget {
  final String icon;
  final String name;
  final double price;
  final VoidCallback onTap;

  const RecommendationCard({
    Key? key,
    required this.icon,
    required this.name,
    required this.price,
    required this.onTap,
  }) : super(key: key);

  @override
  State<RecommendationCard> createState() => _RecommendationCardState();
}

class _RecommendationCardState extends State<RecommendationCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: _isHovered
              ? (Matrix4.identity()..translate(0.0, -2.0))
              : Matrix4.identity(),
          width: 140,
          margin: const EdgeInsets.only(right: 15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: _isHovered ? const Color(0xFF667eea) : Colors.transparent,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? const Color(0xFF667eea).withValues(alpha: 0.15)
                    : Colors.black.withValues(alpha: 0.08),
                blurRadius: _isHovered ? 20 : 10,
                spreadRadius: _isHovered ? 5 : 2,
                offset: Offset(0, _isHovered ? 2 : 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    widget.icon,
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Text(
                'From ৳${widget.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF667eea),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
