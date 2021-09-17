part of 'upcoming_bloc.dart';

abstract class UpcomingState extends Equatable {
  const UpcomingState();

  @override
  List<Object> get props => [];
}

class UpcomingEmpty extends UpcomingState {}

class UpcomingLoading extends UpcomingState {}

class UpcomingLoaded extends UpcomingState {
  final MovieStatus status;
  final List<Movie> movies;
  final bool hasReachedMax;
  final int page;
  final int totalPages;

  const UpcomingLoaded({
    this.status = MovieStatus.initial,
    this.movies = const <Movie>[],
    this.hasReachedMax = false,
    this.page = 1,
    this.totalPages = 1,
  });

  UpcomingLoaded copyWith({
    MovieStatus? status,
    List<Movie>? movies,
    bool? hasReachedMax,
    int? page,
    int? totalPages,
  }) =>
      UpcomingLoaded(
        status: status ?? this.status,
        movies: movies ?? this.movies,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        page: page ?? this.page,
        totalPages: totalPages ?? this.totalPages,
      );

  @override
  List<Object> get props => [status, movies, hasReachedMax, page, totalPages];
}

class UpcomingError extends UpcomingState {
  final String message;

  const UpcomingError(this.message);
}
