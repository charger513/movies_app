import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies_app/core/error/exceptions.dart';
import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/core/network/network_info.dart';
import 'package:movies_app/movies/data/datasources/movies_remote_data_source.dart';
import 'package:movies_app/movies/data/models/movie_collection_model.dart';
import 'package:movies_app/movies/data/models/movie_model.dart';
import 'package:movies_app/movies/data/repositories/movies_repository.dart';

import 'movies_repository_test.mocks.dart';

@GenerateMocks([MoviesRemoteDataSourceInterface, NetworkInfoInterface])
void main() {
  late MoviesRepository moviesRepository;
  late MockMoviesRemoteDataSourceInterface mockMoviesRemoteDataSourceInterface;
  late MockNetworkInfoInterface mockNetworkInfo;

  setUp(() {
    mockMoviesRemoteDataSourceInterface = MockMoviesRemoteDataSourceInterface();
    mockNetworkInfo = MockNetworkInfoInterface();
    moviesRepository = MoviesRepository(
      moviesRemoteDataSourceInterface: mockMoviesRemoteDataSourceInterface,
      networkInfo: mockNetworkInfo,
    );
  });

  const tMovieCollectionModel = MovieCollectionModel(
    page: 1,
    movies: [
      MovieModel(
        posterPath: "/poster1.jpg",
        adult: false,
        overview: "Overview1",
        releaseDate: "2016-08-03",
        genreIds: [14, 28, 80],
        id: 297761,
        originalTitle: "Original Title 1",
        originalLanguage: "en",
        title: "Title 1",
        backdropPath: "/backdrop1.jpg",
        popularity: 48.261451,
        voteCount: 1466,
        video: false,
        voteAverage: 5.91,
      ),
      MovieModel(
        posterPath: "/poster2.jpg",
        adult: false,
        overview: "Overview2",
        releaseDate: "2016-08-03",
        genreIds: [14, 28, 80],
        id: 297761,
        originalTitle: "Original Title 2",
        originalLanguage: "en",
        title: "Title 2",
        backdropPath: "/backdrop2.jpg",
        popularity: 48.261451,
        voteCount: 1466,
        video: false,
        voteAverage: 5.91,
      ),
    ],
    totalPages: 33,
    totalResults: 649,
  );

  void runTestOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group("GetPlayingNow", () {
    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockMoviesRemoteDataSourceInterface.getPlayingNow(
                page: anyNamed("page")))
            .thenAnswer((_) async => tMovieCollectionModel);
        // act
        moviesRepository.getNowPlaying();
        //assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestOnline(() {
      test(
        'should return remote data when the call to remote data source is sucessful',
        () async {
          // arrange
          when(mockMoviesRemoteDataSourceInterface.getPlayingNow(
                  page: anyNamed('page')))
              .thenAnswer((_) async => tMovieCollectionModel);
          // act
          final result = await moviesRepository.getNowPlaying();
          // assert
          verify(mockMoviesRemoteDataSourceInterface.getPlayingNow(page: 1));
          expect(result, const Right(tMovieCollectionModel));
        },
      );

      test(
        'should return unauthenticated failure when the call to remote data source is unsucessful',
        () async {
          // arrange
          when(mockMoviesRemoteDataSourceInterface.getPlayingNow(
                  page: anyNamed('page')))
              .thenThrow(UnauthenticatedException(''));
          // act
          final result = await moviesRepository.getNowPlaying();
          // assert
          verify(mockMoviesRemoteDataSourceInterface.getPlayingNow(page: 1));
          verifyNoMoreInteractions(mockMoviesRemoteDataSourceInterface);
          expect(result, Left(UnauthenticatedFailure()));
        },
      );

      test(
        'should return not found failure when the call to remote data source is unsucessful',
        () async {
          // arrange
          when(mockMoviesRemoteDataSourceInterface.getPlayingNow(
                  page: anyNamed('page')))
              .thenThrow(NotFoundException(''));
          // act
          final result = await moviesRepository.getNowPlaying();
          // assert
          verify(mockMoviesRemoteDataSourceInterface.getPlayingNow(page: 1));
          verifyNoMoreInteractions(mockMoviesRemoteDataSourceInterface);
          expect(result, Left(NotFoundFailure()));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsucessful',
        () async {
          // arrange
          when(mockMoviesRemoteDataSourceInterface.getPlayingNow(
                  page: anyNamed('page')))
              .thenThrow(ServerException());
          // act
          final result = await moviesRepository.getNowPlaying();
          // assert
          verify(mockMoviesRemoteDataSourceInterface.getPlayingNow(page: 1));
          verifyNoMoreInteractions(mockMoviesRemoteDataSourceInterface);
          expect(result, Left(ServerFailure()));
        },
      );

      test(
        'should return unknown failure when the call to remote data source is unsucessful',
        () async {
          // arrange
          when(mockMoviesRemoteDataSourceInterface.getPlayingNow(
                  page: anyNamed('page')))
              .thenThrow(UnknownException());
          // act
          final result = await moviesRepository.getNowPlaying();
          // assert
          verify(mockMoviesRemoteDataSourceInterface.getPlayingNow(page: 1));
          verifyNoMoreInteractions(mockMoviesRemoteDataSourceInterface);
          expect(result, Left(UnknownFailure()));
        },
      );
    });

    runTestOffline(() {
      test(
          "should return no internet failure when there is not internet connection",
          () async {
        final result = await moviesRepository.getNowPlaying();
        verifyNever(mockMoviesRemoteDataSourceInterface.getPlayingNow(page: 1));
        verifyNoMoreInteractions(mockMoviesRemoteDataSourceInterface);
        expect(result, Left(NoInternetFailure()));
      });
    });
  });
}
