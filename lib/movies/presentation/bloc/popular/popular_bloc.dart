import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movies_app/core/enums/movie_status.dart';
import 'package:movies_app/movies/domain/entities/movie.dart';
import 'package:movies_app/movies/domain/usecases/get_popular.dart';
import 'package:rxdart/rxdart.dart';

part 'popular_event.dart';
part 'popular_state.dart';

class PopularBloc extends Bloc<PopularEvent, PopularState> {
  final GetPopular getPopular;
  PopularBloc({required this.getPopular}) : super(PopularEmpty()) {
    on<PopularMoviesFetched>(
      _onPopularMoviesFetched,
      transformer: throttleTime(const Duration(milliseconds: 500)),
    );
  }

  // @override
  // Stream<Transition<PopularEvent, PopularState>> transformEvents(
  //   Stream<PopularEvent> events,
  //   TransitionFunction<PopularEvent, PopularState> transitionFn,
  // ) {
  //   return super.transformEvents(
  //     events.throttleTime(const Duration(milliseconds: 500)),
  //     transitionFn,
  //   );
  // }

  EventTransformer<T> throttleTime<T>(Duration duration) {
    return (events, mapper) => events.throttleTime(duration).flatMap(mapper);
  }

  Future<void> _onPopularMoviesFetched(
    PopularMoviesFetched event,
    Emitter<PopularState> emit,
  ) async {
    if (state is PopularEmpty) {
      emit(PopularLoading());
      final failureOrMovieCollection = await getPopular();
      failureOrMovieCollection.fold(
        (failure) {
          emit(const PopularError('Error'));
        },
        (movieCollection) {
          emit(PopularLoaded(
            status: MovieStatus.success,
            movies: movieCollection.movies,
            hasReachedMax: false,
            page: movieCollection.page,
            totalPages: movieCollection.totalPages,
          ));
        },
      );
    } else if (state is PopularLoaded) {
      final popularState = state as PopularLoaded;
      if (popularState.hasReachedMax) {
        emit(state);
      } else {
        final nextPage = popularState.page + 1;
        if (nextPage > popularState.totalPages) {
          emit(popularState.copyWith(hasReachedMax: true));
        } else {
          final failureOrMovieCollection = await getPopular(page: nextPage);
          failureOrMovieCollection.fold(
            (failure) {
              emit(popularState.copyWith(status: MovieStatus.failure));
            },
            (movieCollection) {
              emit(popularState.copyWith(
                status: MovieStatus.success,
                movies: List.of(popularState.movies)
                  ..addAll(movieCollection.movies),
                hasReachedMax: false,
                page: movieCollection.page,
                totalPages: movieCollection.totalPages,
              ));
            },
          );
        }
      }
    }
  }

  // @override
  // Stream<PopularState> mapEventToState(
  //   PopularEvent event,
  // ) async* {
  //   if (event is PopularMoviesFetched) {
  //     if (state is PopularEmpty) {
  //       yield PopularLoading();
  //       final failureOrMovieCollection = await getPopular();
  //       yield* failureOrMovieCollection.fold(
  //         (failure) async* {
  //           yield const PopularError('Error');
  //         },
  //         (movieCollection) async* {
  //           yield PopularLoaded(
  //             status: MovieStatus.success,
  //             movies: movieCollection.movies,
  //             hasReachedMax: false,
  //             page: movieCollection.page,
  //             totalPages: movieCollection.totalPages,
  //           );
  //         },
  //       );
  //     } else if (state is PopularLoaded) {
  //       final popularState = state as PopularLoaded;
  //       if (popularState.hasReachedMax) {
  //         yield state;
  //       } else {
  //         final nextPage = popularState.page + 1;
  //         // log(popularState.toString());
  //         if (nextPage > popularState.totalPages) {
  //           yield popularState.copyWith(hasReachedMax: true);
  //         } else {
  //           final failureOrMovieCollection = await getPopular(page: nextPage);
  //           yield* failureOrMovieCollection.fold(
  //             (failure) async* {
  //               log(failure.toString());
  //               yield popularState.copyWith(status: MovieStatus.failure);
  //             },
  //             (movieCollection) async* {
  //               yield popularState.copyWith(
  //                 status: MovieStatus.success,
  //                 movies: List.of(popularState.movies)
  //                   ..addAll(movieCollection.movies),
  //                 hasReachedMax: false,
  //                 page: movieCollection.page,
  //                 totalPages: movieCollection.totalPages,
  //               );
  //             },
  //           );
  //         }
  //       }
  //     }
  //   }
  // }
}
