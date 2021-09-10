part of 'playing_now_bloc.dart';

enum MovieStatus { initial, success, failure }

class PlayingNowState extends Equatable {
  final MovieStatus status;
  final List<Movie> movies;
  final bool hasReachedMax;
  final int page;
  final int totalPages;

  const PlayingNowState({
    this.status = MovieStatus.initial,
    this.movies = const <Movie>[],
    this.hasReachedMax = false,
    this.page = 1,
    this.totalPages = 1,
  });

  PlayingNowState copyWith({
    MovieStatus? status,
    List<Movie>? movies,
    bool? hasReachedMax,
    int? page,
    int? totalPages,
  }) =>
      PlayingNowState(
        status: status ?? this.status,
        movies: movies ?? this.movies,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        page: page ?? this.page,
        totalPages: totalPages ?? this.totalPages,
      );

  @override
  List<Object> get props => [status, movies, hasReachedMax, page, totalPages];
}
