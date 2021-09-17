import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:movies_app/core/network/network_info.dart';
import 'package:movies_app/movies/data/datasources/movies_remote_data_source.dart';
import 'package:movies_app/movies/data/repositories/movies_repository.dart';
import 'package:movies_app/movies/domain/repositories/movies_repository_interface.dart';
import 'package:movies_app/movies/domain/usecases/get_now_playing.dart';
import 'package:movies_app/movies/domain/usecases/get_popular.dart';
import 'package:movies_app/movies/presentation/bloc/playing_now/playing_now_bloc.dart';
import 'package:movies_app/movies/presentation/bloc/popular/popular_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Movies
  // Bloc
  sl.registerFactory(() => PlayingNowBloc(getNowPlaying: sl()));
  sl.registerFactory(() => PopularBloc(getPopular: sl()));

  // usecases
  sl.registerLazySingleton(() => GetNowPlaying(sl()));
  sl.registerLazySingleton(() => GetPopular(sl()));

  // repositories
  sl.registerLazySingleton<MoviesRepositoryInterface>(() => MoviesRepository(
        moviesRemoteDataSourceInterface: sl(),
        networkInfo: sl(),
      ));

  // datasources
  sl.registerLazySingleton<MoviesRemoteDataSourceInterface>(
      () => MoviesRemoteDataSource(sl()));

  //! Core
  sl.registerLazySingleton<NetworkInfoInterface>(() => NetworkInfo(sl()));

  //! External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
