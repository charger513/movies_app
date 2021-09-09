import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/movies/data/models/movie_model.dart';
import 'package:movies_app/movies/domain/entities/movie.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  const tMovieModel = MovieModel(
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
  );

  test(
    'should be a subclass of Movie entity',
    () async {
      // arrange

      // act

      // assert
      expect(tMovieModel, isA<Movie>());
    },
  );

  group("fromJson", () {
    test('should return a valid model', () {
      // arrange
      final Map<String, dynamic> jsonMap = jsonDecode(fixture('movie.json'));

      // act
      final result = MovieModel.fromJson(jsonMap);

      // assert
      expect(result, tMovieModel);
    });
  });

  group("toJson", () {
    test('should return a JSON map containing the proper data', () {
      // arrange

      // act
      final result = tMovieModel.toJson();

      // assert
      final expectedMap = {
        "poster_path": "/poster1.jpg",
        "adult": false,
        "overview": "Overview1",
        "release_date": "2016-08-03",
        "genre_ids": [14, 28, 80],
        "id": 297761,
        "original_title": "Original Title 1",
        "original_language": "en",
        "title": "Title 1",
        "backdrop_path": "/backdrop1.jpg",
        "popularity": 48.261451,
        "vote_count": 1466,
        "video": false,
        "vote_average": 5.91
      };

      expect(result, expectedMap);
    });
  });
}
