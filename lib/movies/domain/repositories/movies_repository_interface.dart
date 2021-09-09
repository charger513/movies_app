import 'package:dartz/dartz.dart';
import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/movies/domain/entities/movie_collection.dart';

abstract class MoviesRepositoryInterface {
  Future<Either<Failure, MovieCollection>> getNowPlaying({int page});
}
