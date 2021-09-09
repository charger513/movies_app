import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/movies/data/models/movie_collection_model.dart';
import 'package:movies_app/movies/data/models/movie_model.dart';
import 'package:movies_app/movies/domain/entities/movie_collection.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
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

  test(
    'should be a subclass of MovieCollection entity',
    () async {
      // arrange

      // act

      // assert
      expect(tMovieCollectionModel, isA<MovieCollection>());
    },
  );

  group("fromJson", () {
    test('should return a valid model', () {
      // arrange
      final Map<String, dynamic> jsonMap = jsonDecode(fixture('movies.json'));

      // act
      final result = MovieCollectionModel.fromJson(jsonMap);

      // assert
      expect(result, tMovieCollectionModel);
    });
  });

  group("toJson", () {
    test('should return a JSON map containing the proper data', () {
      // arrange

      // act
      final result = tMovieCollectionModel.toJson();

      // assert
      final expectedMap = {
        "page": 1,
        "results": [
          {
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
          },
          {
            "poster_path": "/poster2.jpg",
            "adult": false,
            "overview": "Overview2",
            "release_date": "2016-08-03",
            "genre_ids": [14, 28, 80],
            "id": 297761,
            "original_title": "Original Title 2",
            "original_language": "en",
            "title": "Title 2",
            "backdrop_path": "/backdrop2.jpg",
            "popularity": 48.261451,
            "vote_count": 1466,
            "video": false,
            "vote_average": 5.91
          }
        ],
        "total_pages": 33,
        "total_results": 649
      };

      expect(result, expectedMap);
    });
  });
}
