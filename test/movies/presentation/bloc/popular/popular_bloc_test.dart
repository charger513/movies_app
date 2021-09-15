import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies_app/core/enums/movie_status.dart';
import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/movies/domain/entities/movie.dart';
import 'package:movies_app/movies/domain/entities/movie_collection.dart';
import 'package:movies_app/movies/domain/usecases/get_popular.dart';
import 'package:movies_app/movies/presentation/bloc/popular/popular_bloc.dart';

import 'popular_bloc_test.mocks.dart';

@GenerateMocks([GetPopular])
void main() {
  late MockGetPopular mockGetPopular;
  late PopularBloc bloc;

  setUp(() {
    mockGetPopular = MockGetPopular();
    bloc = PopularBloc(getPopular: mockGetPopular);
  });

  const tMovieCollection = MovieCollection(
    page: 1,
    movies: [
      Movie(
        posterPath: "posterPath",
        adult: false,
        overview: "overview",
        releaseDate: "releaseDate",
        genreIds: [
          1,
          2,
        ],
        id: 1,
        originalTitle: "originalTitle",
        originalLanguage: "originalLanguage",
        title: "title",
        backdropPath: "backdropPath",
        popularity: 10,
        voteCount: 100,
        video: true,
        voteAverage: 50,
      ),
    ],
    totalPages: 1,
    totalResults: 1,
  );

  const tMovieCollectionPage2 = MovieCollection(
    page: 2,
    movies: [
      Movie(
        posterPath: "posterPath",
        adult: false,
        overview: "overview",
        releaseDate: "releaseDate",
        genreIds: [
          1,
          2,
        ],
        id: 1,
        originalTitle: "originalTitle",
        originalLanguage: "originalLanguage",
        title: "title",
        backdropPath: "backdropPath",
        popularity: 10,
        voteCount: 100,
        video: true,
        voteAverage: 50,
      ),
    ],
    totalPages: 2,
    totalResults: 2,
  );

  const tMovieCollectionEmpty = MovieCollection(
    page: 2,
    movies: [],
    totalPages: 1,
    totalResults: 1,
  );

  group("GetPopularBloc", () {
    test("should PopularEmpty the initial state", () {
      expect(bloc.state, PopularEmpty());
    });

    blocTest<PopularBloc, PopularState>(
      "emits nothing when movies has reached maximum amount",
      build: () => bloc,
      seed: () => const PopularLoaded(hasReachedMax: true),
      act: (_) => bloc.add(PopularMoviesFetched()),
      expect: () => [],
      verify: (_) {
        verifyNever(mockGetPopular());
      },
    );

    blocTest(
      "emits [PopularLoading, PopularLoaded] and success status when usecase fetches initial movies",
      build: () {
        when(mockGetPopular(page: anyNamed('page')))
            .thenAnswer((_) async => const Right(tMovieCollection));

        return bloc;
      },
      act: (_) => bloc.add(PopularMoviesFetched()),
      expect: () => [
        PopularLoading(),
        PopularLoaded(
          status: MovieStatus.success,
          movies: tMovieCollection.movies,
          hasReachedMax: false,
          page: 1,
          totalPages: 1,
        ),
      ],
      verify: (_) {
        verify(mockGetPopular(page: 1));
      },
    );

    blocTest(
      "emits [PopularLoading, PopularError] when usecase returns failure when state is [PopularEmpty]",
      build: () {
        when(mockGetPopular(page: anyNamed('page')))
            .thenAnswer((_) async => Left(ServerFailure()));

        return bloc;
      },
      act: (_) => bloc.add(PopularMoviesFetched()),
      expect: () => [
        PopularLoading(),
        const PopularError('Error'),
      ],
      verify: (_) {
        verify(mockGetPopular(page: 1));
      },
    );

    blocTest<PopularBloc, PopularState>(
      "emits status failure when usecase returns failure when state is [PopularLoaded]",
      build: () {
        when(mockGetPopular(page: anyNamed('page')))
            .thenAnswer((_) async => Left(ServerFailure()));

        return bloc;
      },
      seed: () => const PopularLoaded(totalPages: 2),
      act: (_) => bloc.add(PopularMoviesFetched()),
      expect: () => [
        const PopularLoaded(
          status: MovieStatus.failure,
          movies: [],
          page: 1,
          totalPages: 2,
        ),
      ],
      verify: (_) {
        verify(mockGetPopular(page: 2));
      },
    );

    blocTest<PopularBloc, PopularState>(
      "emits successful status and reaches max movies when 0 additional movies are fetched in [PopularLoaded]",
      build: () {
        when(mockGetPopular(page: anyNamed('page')))
            .thenAnswer((_) async => const Right(tMovieCollectionEmpty));
        return bloc;
      },
      seed: () => PopularLoaded(
        status: MovieStatus.success,
        movies: tMovieCollection.movies,
        page: 1,
        totalPages: 1,
      ),
      act: (_) => bloc.add(PopularMoviesFetched()),
      expect: () => [
        PopularLoaded(
          status: MovieStatus.success,
          movies: tMovieCollection.movies,
          hasReachedMax: true,
        ),
      ],
      verify: (_) {
        verifyNever(mockGetPopular());
      },
    );

    blocTest<PopularBloc, PopularState>(
      "emits successful status and doesn't reach max movies when additional movies are fetched in [PopularLoaded]",
      build: () {
        when(mockGetPopular(page: anyNamed('page')))
            .thenAnswer((_) async => const Right(tMovieCollectionPage2));
        return bloc;
      },
      seed: () => PopularLoaded(
        status: MovieStatus.success,
        movies: tMovieCollection.movies,
        page: 1,
        totalPages: 2,
      ),
      act: (_) => bloc.add(PopularMoviesFetched()),
      expect: () => [
        PopularLoaded(
          status: MovieStatus.success,
          movies: [...tMovieCollection.movies, ...tMovieCollectionPage2.movies],
          hasReachedMax: false,
          page: 2,
          totalPages: 2,
        ),
      ],
    );
  });
}
