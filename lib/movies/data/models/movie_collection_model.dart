import 'package:movies_app/movies/data/models/movie_model.dart';
import 'package:movies_app/movies/domain/entities/movie_collection.dart';

class MovieCollectionModel extends MovieCollection {
  const MovieCollectionModel({
    required int page,
    required List<MovieModel> movies,
    required int totalPages,
    required int totalResults,
  }) : super(
          page: page,
          movies: movies,
          totalPages: totalPages,
          totalResults: totalResults,
        );

  factory MovieCollectionModel.fromJson(Map<String, dynamic> json) =>
      MovieCollectionModel(
        page: json["page"],
        movies: List<MovieModel>.from(
            json["results"].map((x) => MovieModel.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "results": List<dynamic>.from(
            (movies as List<MovieModel>).map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
      };
}
