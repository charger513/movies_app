import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/movies/presentation/bloc/upcoming/upcoming_bloc.dart';
import 'package:movies_app/movies/presentation/widgets/movie_details.dart';

class UpcomingViewPage extends StatefulWidget {
  const UpcomingViewPage({Key? key}) : super(key: key);

  @override
  _UpcomingViewPageState createState() => _UpcomingViewPageState();
}

class _UpcomingViewPageState extends State<UpcomingViewPage> {
  final _pageController = PageController(viewportFraction: 0.7);
  double currentPage = 0;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<UpcomingBloc>(context).add(UpcomingMoviesFetched());
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpcomingBloc, UpcomingState>(
      builder: (context, state) {
        if (state is UpcomingEmpty) {
          return const Center(
            child: Text('No movies'),
          );
        } else if (state is UpcomingLoaded) {
          return PageView.builder(
            controller: _pageController,
            itemCount: state.movies.length,
            itemBuilder: (_, index) {
              final movie = state.movies[index];
              final scaleFactor =
                  1 - ((currentPage - index).abs() * 0.1).clamp(0.0, 1.0);
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Transform.scale(
                  scale: scaleFactor,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        movie.posterPath != null
                            ? Hero(
                                tag: Key('${movie.id}-upcoming'),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                                  height: double.infinity,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Center(
                                child: Icon(Icons.error),
                              ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => MovieDetails(
                                    movie: movie,
                                    heroTag: '${movie.id}-upcoming',
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
              );
            },
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
