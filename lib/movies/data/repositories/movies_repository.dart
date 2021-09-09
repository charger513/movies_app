import 'package:movies_app/core/error/exceptions.dart';
import 'package:movies_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:movies_app/core/network/network_info.dart';
import 'package:movies_app/movies/data/datasources/movies_remote_data_source.dart';
import 'package:movies_app/movies/domain/entities/movie_collection.dart';
import 'package:movies_app/movies/domain/repositories/movies_repository_interface.dart';

class MoviesRepository implements MoviesRepositoryInterface {
  final MoviesRemoteDataSourceInterface moviesRemoteDataSourceInterface;
  final NetworkInfoInterface networkInfo;

  MoviesRepository({
    required this.moviesRemoteDataSourceInterface,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, MovieCollection>> getNowPlaying({int page = 1}) async {
    if (await networkInfo.isConnected) {
      try {
        final movies =
            await moviesRemoteDataSourceInterface.getPlayingNow(page: page);
        return Right(movies);
      } on UnauthenticatedException {
        return Left(UnauthenticatedFailure());
      } on NotFoundException {
        return Left(NotFoundFailure());
      } on ServerException {
        return Left(ServerFailure());
      } catch (e) {
        return Left(UnknownFailure());
      }
    }

    return Left(NoInternetFailure());
  }
}
