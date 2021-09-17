import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies_app/core/enums/movie_status.dart';
import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/movies/domain/entities/movie.dart';
import 'package:movies_app/movies/domain/entities/movie_collection.dart';
import 'package:movies_app/movies/domain/usecases/get_upcoming.dart';
import 'package:movies_app/movies/presentation/bloc/upcoming/upcoming_bloc.dart';

import 'upcoming_bloc_test.mocks.dart';

@GenerateMocks([GetUpcoming])
void main() {
  late MockGetUpcoming mockGetUpcoming;
  late UpcomingBloc bloc;

  setUp(() {
    mockGetUpcoming = MockGetUpcoming();
    bloc = UpcomingBloc(getUpcoming: mockGetUpcoming);
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

  group("GetUpcomingBloc", () {
    test("should UpcomingEmpty the initial state", () {
      expect(bloc.state, UpcomingEmpty());
    });

    blocTest<UpcomingBloc, UpcomingState>(
      "emits nothing when movies has reached maximum amount",
      build: () => bloc,
      seed: () => const UpcomingLoaded(hasReachedMax: true),
      act: (_) => bloc.add(UpcomingMoviesFetched()),
      expect: () => [],
      verify: (_) {
        verifyNever(mockGetUpcoming());
      },
    );

    blocTest(
      "emits [UpcomingLoading, UpcomingLoaded] and success status when usecase fetches initial movies",
      build: () {
        when(mockGetUpcoming(page: anyNamed('page')))
            .thenAnswer((_) async => const Right(tMovieCollection));

        return bloc;
      },
      act: (_) => bloc.add(UpcomingMoviesFetched()),
      expect: () => [
        UpcomingLoading(),
        UpcomingLoaded(
          status: MovieStatus.success,
          movies: tMovieCollection.movies,
          hasReachedMax: false,
          page: 1,
          totalPages: 1,
        ),
      ],
      verify: (_) {
        verify(mockGetUpcoming(page: 1));
      },
    );

    blocTest(
      "emits [UpcomingLoading, UpcomingError] when usecase returns failure when state is [UpcomingEmpty]",
      build: () {
        when(mockGetUpcoming(page: anyNamed('page')))
            .thenAnswer((_) async => Left(ServerFailure()));

        return bloc;
      },
      act: (_) => bloc.add(UpcomingMoviesFetched()),
      expect: () => [
        UpcomingLoading(),
        const UpcomingError('Error'),
      ],
      verify: (_) {
        verify(mockGetUpcoming(page: 1));
      },
    );

    blocTest<UpcomingBloc, UpcomingState>(
      "emits status failure when usecase returns failure when state is [UpcomingLoaded]",
      build: () {
        when(mockGetUpcoming(page: anyNamed('page')))
            .thenAnswer((_) async => Left(ServerFailure()));

        return bloc;
      },
      seed: () => const UpcomingLoaded(totalPages: 2),
      act: (_) => bloc.add(UpcomingMoviesFetched()),
      expect: () => [
        const UpcomingLoaded(
          status: MovieStatus.failure,
          movies: [],
          page: 1,
          totalPages: 2,
        ),
      ],
      verify: (_) {
        verify(mockGetUpcoming(page: 2));
      },
    );

    blocTest<UpcomingBloc, UpcomingState>(
      "emits successful status and reaches max movies when 0 additional movies are fetched in [UpcomingLoaded]",
      build: () {
        when(mockGetUpcoming(page: anyNamed('page')))
            .thenAnswer((_) async => const Right(tMovieCollectionEmpty));
        return bloc;
      },
      seed: () => UpcomingLoaded(
        status: MovieStatus.success,
        movies: tMovieCollection.movies,
        page: 1,
        totalPages: 1,
      ),
      act: (_) => bloc.add(UpcomingMoviesFetched()),
      expect: () => [
        UpcomingLoaded(
          status: MovieStatus.success,
          movies: tMovieCollection.movies,
          hasReachedMax: true,
        ),
      ],
      verify: (_) {
        verifyNever(mockGetUpcoming());
      },
    );

    blocTest<UpcomingBloc, UpcomingState>(
      "emits successful status and doesn't reach max movies when additional movies are fetched in [UpcomingLoaded]",
      build: () {
        when(mockGetUpcoming(page: anyNamed('page')))
            .thenAnswer((_) async => const Right(tMovieCollectionPage2));
        return bloc;
      },
      seed: () => UpcomingLoaded(
        status: MovieStatus.success,
        movies: tMovieCollection.movies,
        page: 1,
        totalPages: 2,
      ),
      act: (_) => bloc.add(UpcomingMoviesFetched()),
      expect: () => [
        UpcomingLoaded(
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
