import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movies_app/movies/domain/entities/movie.dart';
import 'package:movies_app/movies/domain/usecases/get_now_playing.dart';

part 'playing_now_event.dart';
part 'playing_now_state.dart';

class PlayingNowBloc extends Bloc<PlayingNowEvent, PlayingNowState> {
  final GetNowPlaying getNowPlaying;

  PlayingNowBloc({
    required this.getNowPlaying,
  }) : super(const PlayingNowState());

  @override
  Stream<PlayingNowState> mapEventToState(
    PlayingNowEvent event,
  ) async* {
    if (event is PlayingNowMoviesFetched) {
      if (state.hasReachedMax) {
        yield state;
      } else {
        if (state.status == MovieStatus.initial) {
          final failureOrMovieCollection = await getNowPlaying();
          yield* failureOrMovieCollection.fold(
            (failure) async* {
              yield state.copyWith(status: MovieStatus.failure);
            },
            (movieCollection) async* {
              yield state.copyWith(
                status: MovieStatus.success,
                movies: movieCollection.movies,
                hasReachedMax: false,
                page: movieCollection.page,
                totalPages: movieCollection.totalPages,
              );
            },
          );
        } else {
          final nextPage = state.page + 1;
          if (nextPage > state.totalPages) {
            yield state.copyWith(hasReachedMax: true);
          } else {
            final failureOrMovieCollection =
                await getNowPlaying(page: nextPage);
            yield* failureOrMovieCollection.fold(
              (failure) async* {
                yield state.copyWith(status: MovieStatus.failure);
              },
              (movieCollection) async* {
                yield state.copyWith(
                  status: MovieStatus.success,
                  movies: List.of(state.movies)..addAll(movieCollection.movies),
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
