import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/movies/domain/entities/movie.dart';

class MovieListItem extends StatelessWidget {
  const MovieListItem({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            width: 100,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Center(
              child: movie.posterPath != null
                  ? CachedNetworkImage(
                      imageUrl:
                          'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                      height: double.infinity,
                    )
                  : const Center(
                      child: Icon(Icons.error),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
