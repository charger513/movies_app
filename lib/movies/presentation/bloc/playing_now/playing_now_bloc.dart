import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movies_app/core/enums/movie_status.dart';
import 'package:movies_app/movies/domain/entities/movie.dart';
import 'package:movies_app/movies/domain/usecases/get_now_playing.dart';
import 'package:rxdart/rxdart.dart';

part 'playing_now_event.dart';
part 'playing_now_state.dart';

class PlayingNowBloc extends Bloc<PlayingNowEvent, PlayingNowState> {
  final GetNowPlaying getNowPlaying;

  PlayingNowBloc({
    required this.getNowPlaying,
  }) : super(const PlayingNowState()) {
    on<PlayingNowMoviesFetched>(
      _onPlayingNowMoviesFetched,
      transformer: throttleTime(const Duration(
        milliseconds: 300,
      )),
    );
  }

  // @override
  // Stream<Transition<PlayingNowEvent, PlayingNowState>> transformEvents(
  //   Stream<PlayingNowEvent> events,
  //   TransitionFunction<PlayingNowEvent, PlayingNowState> transitionFn,
  // ) {
  //   return super.transformEvents(
  //     events.throttleTime(const Duration(milliseconds: 500)),
  //     transitionFn,
  //   );
  // }

  EventTransformer<T> throttleTime<T>(Duration duration) {
    return (events, mapper) => events.throttleTime(duration).flatMap(mapper);
  }

  Future<void> _onPlayingNowMoviesFetched(
    PlayingNowMoviesFetched event,
    Emitter<PlayingNowState> emit,
  ) async {
    if (state.hasReachedMax) {
      emit(state);
    } else {
      if (state.status == MovieStatus.initial) {
        final failureOrMovieCollection = await getNowPlaying();
        failureOrMovieCollection.fold(
          (failure) {
            emit(state.copyWith(status: MovieStatus.failure));
          },
          (movieCollection) {
            emit(state.copyWith(
              status: MovieStatus.success,
              movies: movieCollection.movies,
              hasReachedMax: false,
              page: movieCollection.page,
              totalPages: movieCollection.totalPages,
            ));
          },
        );
      } else {
        final nextPage = state.page + 1;
        if (nextPage > state.totalPages) {
          emit(state.copyWith(hasReachedMax: true));
        } else {
          final failureOrMovieCollection = await getNowPlaying(page: nextPage);
          failureOrMovieCollection.fold(
            (failure) {
              emit(state.copyWith(status: MovieStatus.failure));
            },
            (movieCollection) {
              emit(state.copyWith(
                status: MovieStatus.success,
                movies: List.of(state.movies)..addAll(movieCollection.movies),
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
}
