import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:movies_app/movies/domain/entities/movie.dart';

class MovieDetails extends StatelessWidget {
  const MovieDetails({
    Key? key,
    required this.movie,
    required this.heroTag,
  }) : super(key: key);

  final Movie movie;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 300,
                  child: Stack(
                    children: [
                      ShaderMask(
                        shaderCallback: (rect) {
                          return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black, Colors.transparent],
                          ).createShader(
                            Rect.fromLTRB(
                              0,
                              0,
                              rect.width,
                              rect.height,
                            ),
                          );
                        },
                        blendMode: BlendMode.dstIn,
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://image.tmdb.org/t/p/w500/${movie.backdropPath}',
                          errorWidget: (context, url, error) =>
                              const Center(child: Text('No image')),
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 10,
                        right: 10,
                        child: SizedBox(
                          width: double.infinity,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Container(
                                  height: 150,
                                  width: 100,
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  child: movie.posterPath != null
                                      ? Hero(
                                          tag: Key(heroTag),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                            placeholder: (context, url) =>
                                                const Center(
                                              child:
                                                  CircularProgressIndicator(),
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
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        movie.title,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(movie.originalTitle),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(movie.overview),
                ),
                RowText(title: 'Title: ', body: movie.title),
                RowText(title: 'Original title: ', body: movie.originalTitle),
                RowText(
                  title: 'Original language: ',
                  body: movie.originalLanguage.toUpperCase(),
                ),
                RowText(
                  title: 'Popularity: ',
                  body: movie.popularity.toStringAsFixed(2),
                ),
                RowText(
                  title: 'Rating: ',
                  body: movie.voteAverage.toString(),
                ),
                RowText(
                  title: 'Release date: ',
                  body: movie.releaseDate ?? '',
                ),
              ],
            ),
          ),
          SafeArea(
            child: Row(children: [
              IconButton(
                icon: const BackButtonIcon(),
                onPressed: () {
                  Navigator.maybePop(context);
                },
              )
            ]),
          ),
        ],
      ),
    );
  }
}

class RowText extends StatelessWidget {
  const RowText({
    Key? key,
    required this.title,
    required this.body,
  }) : super(key: key);

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: SizedBox(
              width: 100,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Text(body),
          ),
        ],
      ),
    );
  }
}
