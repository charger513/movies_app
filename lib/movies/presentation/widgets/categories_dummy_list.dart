import 'dart:math';

import 'package:flutter/material.dart';

class CategoriesDummyList extends StatelessWidget {
  const CategoriesDummyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 180,
                decoration: BoxDecoration(color: Colors.red[300]),
                child: Stack(
                  children: [
                    Positioned(
                      top: -30,
                      right: -10,
                      child: Transform.rotate(
                        angle: pi / 12,
                        child: const Icon(
                          Icons.local_movies_outlined,
                          size: 150,
                          color: Colors.white12,
                        ),
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Movie Category',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 180,
                decoration: BoxDecoration(color: Colors.blue[300]),
                child: Stack(
                  children: [
                    Positioned(
                      top: -30,
                      right: -10,
                      child: Transform.rotate(
                        angle: pi / 12,
                        child: const Icon(
                          Icons.local_movies_outlined,
                          size: 150,
                          color: Colors.white12,
                        ),
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Movie Category',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 180,
                decoration: BoxDecoration(color: Colors.yellow[700]),
                child: Stack(
                  children: [
                    Positioned(
                      top: -30,
                      right: -10,
                      child: Transform.rotate(
                        angle: pi / 12,
                        child: const Icon(
                          Icons.local_movies_outlined,
                          size: 150,
                          color: Colors.white12,
                        ),
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Movie Category',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
