import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movies_app/core/enums/movie_status.dart';
import 'package:movies_app/movies/domain/entities/movie.dart';
import 'package:movies_app/movies/domain/usecases/get_popular.dart';

part 'popular_event.dart';
part 'popular_state.dart';

class PopularBloc extends Bloc<PopularEvent, PopularState> {
  final GetPopular getPopular;
  PopularBloc({required this.getPopular}) : super(PopularEmpty());

  @override
  Stream<PopularState> mapEventToState(
    PopularEvent event,
  ) async* {
    if (event is PopularMoviesFetched) {
      if (state is PopularEmpty) {
        yield PopularLoading();
        final failureOrMovieCollection = await getPopular();
        yield* failureOrMovieCollection.fold(
          (failure) async* {
            yield const PopularError('Error');
          },
          (movieCollection) async* {
            yield PopularLoaded(
              status: MovieStatus.success,
              movies: movieCollection.movies,
              hasReachedMax: false,
              page: movieCollection.page,
              totalPages: movieCollection.totalPages,
            );
          },
        );
      } else if (state is PopularLoaded) {
        final popularState = state as PopularLoaded;
        if (popularState.hasReachedMax) {
          yield state;
        } else {
          final nextPage = popularState.page + 1;
          if (nextPage > popularState.totalPages) {
            yield popularState.copyWith(hasReachedMax: true);
          } else {
            final failureOrMovieCollection = await getPopular(page: nextPage);
            yield* failureOrMovieCollection.fold(
              (failure) async* {
                yield popularState.copyWith(status: MovieStatus.failure);
              },
              (movieCollection) async* {
                yield popularState.copyWith(
                  status: MovieStatus.success,
                  movies: List.of(popularState.movies)
                    ..addAll(movieCollection.movies),
                  hasReachedMax: false,
                  page: movieCollection.page,
                  totalPages: movieCollection.totalPages,
                );
              },
            );
          }
        }
      }
    }
  }
}
