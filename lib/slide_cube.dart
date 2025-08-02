
import 'dart:math';

import 'package:cube_slide/image_model.dart';
import 'package:flutter/material.dart';


class CarouselPage extends StatefulWidget {
  const CarouselPage({super.key});

  @override
  _CarouselPageState createState() => _CarouselPageState();
}

class _CarouselPageState extends State<CarouselPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<CarouselItem> items = [
    CarouselItem(
      position: 1,
      imagePath: 'asset/images/image1.png',
    ),
    CarouselItem(
      position: 2,
      imagePath: 'asset/images/image2.jpeg',
    ),
    CarouselItem(
      position: 3,
      imagePath: 'asset/images/image3.jpeg',
    ),
    CarouselItem(
      position: 4,
      imagePath: 'asset/images/image4.jpeg',
    ),
    CarouselItem(
      position: 5,
      imagePath: 'asset/images/image5.jpeg',
    ),
    CarouselItem(
      position: 6,
      imagePath: 'asset/images/image6.jpeg',
    ),
    CarouselItem(
      position: 7,
      imagePath: 'asset/images/image7.jpeg',
    ),
    CarouselItem(
      position: 8,
      imagePath: 'asset/images/image8.png',
    ),
    CarouselItem(
      position: 9,
      imagePath: 'asset/images/image9.png',
    ),
    CarouselItem(
      position: 10,
      imagePath: 'asset/images/image10.jpeg',
    ),
  ];


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 100), // As per your change
    )..addListener(() {
        // Log cycle completion
        if (_controller.value >= 0.999) {
          print('Cycle completed: ${_controller.value}');
        }
      })..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final rotation = (_controller.value * 2 * pi) % (2 * pi);
    // Responsive carousel sizing
    double sliderWidth = 200;
    double sliderHeight = 350;
    double translateZ = 415;
    if (screenWidth <= 1023) {
      sliderWidth = 160;
      sliderHeight = 200;
      translateZ = 300;
    }
    if (screenWidth <= 767) {
      sliderWidth = 100;
      sliderHeight = 150;
      translateZ = 180;
    }

      // Dynamic quantity based on the number of items
    final int quantity = items.length;
    return Scaffold(
      body: Stack(
        children: [
          // Carousel (centered)
          Positioned(
            top: (screenHeight - sliderHeight) / 3,
            left: (screenWidth - sliderWidth) / 2,
            child: SizedBox(
              width: sliderWidth,
              height: sliderHeight,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {

                  final rotation = (_controller.value * 2 * pi) % (2 * pi);
                  // Create a list of items with their Z positions
                  final sortedItems = items.map((item) {
                    final angle = (item.position - 1) * (360 / quantity) * pi / 180;
                    // Adjust zPosition to account for rotateX tilt
                    final zPosition = translateZ * cos(angle + rotation) * cos(15 * pi / 180) + (item.position * 0.1);
                    return {
                      'item': item,
                      'zPosition': zPosition,
                      'angle': angle,
                    };
                  }).toList();

                  // Log item details
                  // print('Frame: t=${_controller.value.toStringAsFixed(3)}');
                  for (var i = 0; i < sortedItems.length; i++) {
                    final item = sortedItems[i]['item'] as CarouselItem;
                    final zPosition = sortedItems[i]['zPosition'] as double;
                    // print('Item ${item.position}: zPosition=${zPosition.toStringAsFixed(3)}, ');
                  }

                  // Sort items by zPosition (descending)
                  sortedItems.sort((a, b) {
                    final zA = a['zPosition'] as double;
                    final zB = b['zPosition'] as double;
                    // Prioritize item closest to 0° (front) when zPositions are close
                    if ((zA - zB).abs() < 0.1) {
                      final angleA = ((a['angle'] as double) + rotation) % (2 * pi);
                      final angleB = ((b['angle'] as double) + rotation) % (2 * pi);
                      // Normalize angles to [-π, π]
                      final normAngleA = angleA > pi ? angleA - 2 * pi : angleA;
                      final normAngleB = angleB > pi ? angleB - 2 * pi : angleB;
                      return normAngleB.abs().compareTo(normAngleA.abs());
                    }
                    return zB.compareTo(zA);
                  });

                  // Log sorted order
                  // print('Sorted order: ${sortedItems.map((e) => (e['item'] as CarouselItem).position).toList()}');
                  return Stack(
                    children: sortedItems.map((sortedItem) {
                      final item = sortedItem['item'] as CarouselItem;
                      final angle = sortedItem['angle'] as double;
                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(pi)
                          ..setEntry(3, 2, 0.001) // Perspective effect
                          ..rotateX(15 * pi / 180) // Matches CSS rotateX(-15deg)
                          ..rotateY(angle + rotation)
                          ..translate(0.0, 0.0, translateZ),
                        child: Stack(
                          children: [

                            Container(
                              width: sliderWidth,
                              height: sliderHeight,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Image.asset(
                                item.imagePath,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
