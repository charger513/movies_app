import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movies_app/core/enums/movie_status.dart';
import 'package:movies_app/movies/domain/entities/movie.dart';
import 'package:movies_app/movies/domain/usecases/get_upcoming.dart';
import 'package:rxdart/rxdart.dart';

part 'upcoming_event.dart';
part 'upcoming_state.dart';

class UpcomingBloc extends Bloc<UpcomingEvent, UpcomingState> {
  final GetUpcoming getUpcoming;
  UpcomingBloc({required this.getUpcoming}) : super(UpcomingEmpty()) {
    on<UpcomingMoviesFetched>(
      _onUpcomingMoviesFetched,
      transformer: throttleTime(const Duration(milliseconds: 300)),
    );
  }

  // @override
  // Stream<Transition<UpcomingEvent, UpcomingState>> transformEvents(
  //   Stream<UpcomingEvent> events,
  //   TransitionFunction<UpcomingEvent, UpcomingState> transitionFn,
  // ) {
  //   return super.transformEvents(
  //     events.throttleTime(const Duration(milliseconds: 500)),
  //     transitionFn,
  //   );
  // }

  EventTransformer<T> throttleTime<T>(Duration duration) {
    return (events, mapper) => events.throttleTime(duration).flatMap(mapper);
  }

  Future<void> _onUpcomingMoviesFetched(
      UpcomingMoviesFetched event, Emitter<UpcomingState> emit) async {
    if (state is UpcomingEmpty) {
      emit(UpcomingLoading());
      final failureOrMovieCollection = await getUpcoming();
      failureOrMovieCollection.fold(
        (failure) {
          emit(const UpcomingError('Error'));
        },
        (movieCollection) {
          emit(UpcomingLoaded(
            status: MovieStatus.success,
            movies: movieCollection.movies,
            hasReachedMax: false,
            page: movieCollection.page,
            totalPages: movieCollection.totalPages,
          ));
        },
      );
    } else if (state is UpcomingLoaded) {
      final _state = state as UpcomingLoaded;
      if (_state.hasReachedMax) {
        emit(state);
      } else {
        final nextPage = _state.page + 1;
        if (nextPage > _state.totalPages) {
          emit(_state.copyWith(hasReachedMax: true));
        } else {
          final failureOrMovieCollection = await getUpcoming(page: nextPage);
          failureOrMovieCollection.fold(
            (failure) {
              emit(_state.copyWith(status: MovieStatus.failure));
            },
            (movieCollection) {
              emit(_state.copyWith(
                status: MovieStatus.success,
                movies: List.of(_state.movies)..addAll(movieCollection.movies),
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
  // Stream<UpcomingState> mapEventToState(
  //   UpcomingEvent event,
  // ) async* {
  //   if (event is UpcomingMoviesFetched) {
  //     if (state is UpcomingEmpty) {
  //       yield UpcomingLoading();
  //       final failureOrMovieCollection = await getUpcoming();
  //       yield* failureOrMovieCollection.fold(
  //         (failure) async* {
  //           yield const UpcomingError('Error');
  //         },
  //         (movieCollection) async* {
  //           yield UpcomingLoaded(
  //             status: MovieStatus.success,
  //             movies: movieCollection.movies,
  //             hasReachedMax: false,
  //             page: movieCollection.page,
  //             totalPages: movieCollection.totalPages,
  //           );
  //         },
  //       );
  //     } else if (state is UpcomingLoaded) {
  //       final _state = state as UpcomingLoaded;
  //       if (_state.hasReachedMax) {
  //         yield state;
  //       } else {
  //         final nextPage = _state.page + 1;
  //         if (nextPage > _state.totalPages) {
  //           yield _state.copyWith(hasReachedMax: true);
  //         } else {
  //           final failureOrMovieCollection = await getUpcoming(page: nextPage);
  //           yield* failureOrMovieCollection.fold(
  //             (failure) async* {
  //               yield _state.copyWith(status: MovieStatus.failure);
  //             },
  //             (movieCollection) async* {
  //               yield _state.copyWith(
  //                 status: MovieStatus.success,
  //                 movies: List.of(_state.movies)
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
