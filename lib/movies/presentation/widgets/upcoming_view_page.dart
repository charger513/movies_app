import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/movies/presentation/bloc/upcoming/upcoming_bloc.dart';

class UpcomingViewPage extends StatefulWidget {
  const UpcomingViewPage({Key? key}) : super(key: key);

  @override
  _UpcomingViewPageState createState() => _UpcomingViewPageState();
}

class _UpcomingViewPageState extends State<UpcomingViewPage> {
  final _pageController = PageController(viewportFraction: 0.7);
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<UpcomingBloc>(context).add(UpcomingMoviesFetched());
    _pageController.addListener(() {
      log(_pageController.page.toString());
      int pos = _pageController.page?.round() ?? 0;
      if (currentPage != pos) {
        setState(() {
          currentPage = pos;
        });
      }
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
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: EdgeInsets.only(top: index == currentPage ? 0 : 30),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: movie.posterPath != null
                        ? CachedNetworkImage(
                            imageUrl:
                                'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                            height: double.infinity,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : const Center(
                            child: Icon(Icons.error),
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
