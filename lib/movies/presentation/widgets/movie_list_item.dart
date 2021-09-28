import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/movies/domain/entities/movie.dart';
import 'package:movies_app/movies/presentation/widgets/movie_details.dart';

class MovieListItem extends StatelessWidget {
  const MovieListItem({
    Key? key,
    required this.movie,
    required this.category,
  }) : super(key: key);

  final Movie movie;
  final String category;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Card(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: movie.posterPath != null
                            ? Hero(
                                tag: Key('${movie.id}-$category'),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                                  // imageBuilder: (context, imageProvider) {
                                  //   return Material(
                                  //     child: Ink.image(
                                  //       image: imageProvider,
                                  //       fit: BoxFit.cover,
                                  //       child: InkWell(onTap: () {}),
                                  //     ),
                                  //   );
                                  // },
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                  width: double.infinity,
                                ),
                              )
                            : const Center(
                                child: Icon(Icons.error),
                              ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => MovieDetails(
                                  movie: movie,
                                  heroTag: '${movie.id}-$category',
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
              width: 100,
              child: Text(
                movie.title,
                overflow: TextOverflow.ellipsis,
              )),
          Row(
            children: [
              const Icon(
                Icons.star,
                size: 15,
                color: Colors.yellow,
              ),
              Text(movie.voteAverage.toString(),
                  style: const TextStyle(color: Colors.yellow)),
            ],
          ),
        ],
      ),
    );
  }
}
