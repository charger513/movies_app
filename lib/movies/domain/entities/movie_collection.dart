import 'package:equatable/equatable.dart';
import 'package:movies_app/movies/domain/entities/movie.dart';

class MovieCollection extends Equatable {
  final int page;
  final List<Movie> movies;
  final int totalPages;
  final int totalResults;

  const MovieCollection({
    required this.page,
    required this.movies,
    required this.totalPages,
    required this.totalResults,
  });

  @override
  List<Object?> get props => [page, movies, totalPages, totalResults];
}
