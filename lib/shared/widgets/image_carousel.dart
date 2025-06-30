import 'package:flutter/material.dart';

import '../../features/venues/domain/entities/venue.dart';
import 'fade_in_image_with_blur.dart';

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({
    super.key,
    required this.images,
    this.indicatorBottomPadding = 16.0,
  });

  final List<ImageWithBlurHash> images;
  final double indicatorBottomPadding;

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Hero(
          tag: widget.key ?? widget.images,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) =>
                FadeInImageWithBlurHash(image: widget.images[index]),
          ),
        ),
        Positioned(
          bottom: widget.indicatorBottomPadding,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.images.length,
              (index) => AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: _currentPage == index ? 12 : 8,
                height: _currentPage == index ? 12 : 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.5),
                  border: _currentPage == index
                      ? Border.all(color: Colors.black26, width: 2)
                      : null,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
