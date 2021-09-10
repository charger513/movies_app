import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/movies/domain/entities/movie.dart';
import 'package:movies_app/movies/domain/entities/movie_collection.dart';
import 'package:movies_app/movies/domain/usecases/get_now_playing.dart';
import 'package:movies_app/movies/presentation/bloc/playing_now/playing_now_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

import 'playing_now_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlaying])
void main() {
  late MockGetNowPlaying mockGetNowPlaying;
  late PlayingNowBloc bloc;

  setUp(() {
    mockGetNowPlaying = MockGetNowPlaying();
    bloc = PlayingNowBloc(getNowPlaying: mockGetNowPlaying);
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

  group("PlayingNowBloc", () {
    test("should PlayingNowState the initial state", () {
      expect(bloc.state, const PlayingNowState());
    });

    blocTest(
      "emits nothing when movies has reached maximum amount",
      build: () => bloc,
      seed: () => const PlayingNowState(hasReachedMax: true),
      act: (_) => bloc.add(PlayingNowMoviesFetched()),
      expect: () => [],
      verify: (_) {
        verifyNever(mockGetNowPlaying());
      },
    );

    blocTest(
      "emits successful status when usecase fetches initial movies",
      build: () {
        when(mockGetNowPlaying(page: anyNamed('page')))
            .thenAnswer((_) async => const Right(tMovieCollection));

        return bloc;
      },
      act: (_) => bloc.add(PlayingNowMoviesFetched()),
      expect: () => [
        PlayingNowState(
          status: MovieStatus.success,
          movies: tMovieCollection.movies,
          hasReachedMax: false,
          page: 1,
          totalPages: 1,
        ),
      ],
      verify: (_) {
        verify(mockGetNowPlaying(page: 1));
      },
    );

    blocTest(
      "emits failure status when usecase returns failure",
      build: () {
        when(mockGetNowPlaying(page: anyNamed('page')))
            .thenAnswer((_) async => Left(ServerFailure()));

        return bloc;
      },
      act: (_) => bloc.add(PlayingNowMoviesFetched()),
      expect: () => [
        const PlayingNowState(
          status: MovieStatus.failure,
          hasReachedMax: false,
          page: 1,
          totalPages: 1,
        ),
      ],
      verify: (_) {
        verify(mockGetNowPlaying(page: 1));
      },
    );

    blocTest(
      "emits successful status and reaches max movies when 0 additional movies are fetched",
      build: () {
        when(mockGetNowPlaying(page: anyNamed('page')))
            .thenAnswer((_) async => const Right(tMovieCollectionEmpty));
        return bloc;
      },
      seed: () => PlayingNowState(
        status: MovieStatus.success,
        movies: tMovieCollection.movies,
        page: 1,
        totalPages: 1,
      ),
      act: (_) => bloc.add(PlayingNowMoviesFetched()),
      expect: () => [
        PlayingNowState(
          status: MovieStatus.success,
          movies: tMovieCollection.movies,
          hasReachedMax: true,
        ),
      ],
      verify: (_) {
        verifyNever(mockGetNowPlaying());
      },
    );

    blocTest(
      "emits successful status and doesn't reach max movies when additional movies are fetched",
      build: () {
        when(mockGetNowPlaying(page: anyNamed('page')))
            .thenAnswer((_) async => const Right(tMovieCollectionPage2));
        return bloc;
      },
      seed: () => PlayingNowState(
        status: MovieStatus.success,
        movies: tMovieCollection.movies,
        page: 1,
        totalPages: 2,
      ),
      act: (_) => bloc.add(PlayingNowMoviesFetched()),
      expect: () => [
        PlayingNowState(
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
