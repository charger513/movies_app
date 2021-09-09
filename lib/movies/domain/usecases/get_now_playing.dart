import 'package:dartz/dartz.dart';
import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/movies/domain/entities/movie_collection.dart';
import 'package:movies_app/movies/domain/repositories/movies_repository_interface.dart';

class GetNowPlaying {
  final MoviesRepositoryInterface moviesRepository;

  GetNowPlaying(this.moviesRepository);

  Future<Either<Failure, MovieCollection>> call({int page = 1}) async {
    return await moviesRepository.getNowPlaying(page: page);
  }
}
