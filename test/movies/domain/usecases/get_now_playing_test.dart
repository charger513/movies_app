import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies_app/movies/domain/entities/movie.dart';
import 'package:movies_app/movies/domain/entities/movie_collection.dart';
import 'package:movies_app/movies/domain/repositories/movies_repository_interface.dart';
import 'package:movies_app/movies/domain/usecases/get_now_playing.dart';

import 'get_now_playing_test.mocks.dart';

@GenerateMocks([MoviesRepositoryInterface])
void main() {
  late MockMoviesRepositoryInterface mockMoviesRepository;
  late GetNowPlaying getNowPlaying;

  setUp(() {
    mockMoviesRepository = MockMoviesRepositoryInterface();
    getNowPlaying = GetNowPlaying(mockMoviesRepository);
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

  test("should get MovieCollection from the repository", () async {
    when(mockMoviesRepository.getNowPlaying(page: anyNamed('page')))
        .thenAnswer((_) async => const Right(tMovieCollection));

    final result = await getNowPlaying();

    expect(result, const Right(tMovieCollection));
    verify(mockMoviesRepository.getNowPlaying(page: 1));
    verifyNoMoreInteractions(mockMoviesRepository);
  });
}
