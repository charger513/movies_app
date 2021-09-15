part of 'popular_bloc.dart';

abstract class PopularState extends Equatable {
  const PopularState();

  @override
  List<Object> get props => [];
}

class PopularEmpty extends PopularState {}

class PopularLoading extends PopularState {}

class PopularLoaded extends PopularState {
  final MovieStatus status;
  final List<Movie> movies;
  final bool hasReachedMax;
  final int page;
  final int totalPages;

  const PopularLoaded({
    this.status = MovieStatus.initial,
    this.movies = const <Movie>[],
    this.hasReachedMax = false,
    this.page = 1,
    this.totalPages = 1,
  });

  PopularLoaded copyWith({
    MovieStatus? status,
    List<Movie>? movies,
    bool? hasReachedMax,
    int? page,
    int? totalPages,
  }) =>
      PopularLoaded(
        status: status ?? this.status,
        movies: movies ?? this.movies,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        page: page ?? this.page,
        totalPages: totalPages ?? this.totalPages,
      );

  @override
  List<Object> get props => [status, movies, hasReachedMax, page, totalPages];
}

class PopularError extends PopularState {
  final String message;

  const PopularError(this.message);
}
