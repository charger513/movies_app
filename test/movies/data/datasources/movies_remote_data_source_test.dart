import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies_app/core/error/exceptions.dart';
import 'package:movies_app/movies/data/datasources/movies_remote_data_source.dart';
import 'package:movies_app/movies/data/models/movie_collection_model.dart';

import '../../../fixtures/fixture_reader.dart';
import 'movies_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockClient;
  late MoviesRemoteDataSource datasource;

  setUp(() {
    mockClient = MockClient();
    datasource = MoviesRemoteDataSource(mockClient);
  });

  void setUpMockClientSuccess200(MockClient mockClient) {
    when(mockClient.get(any, headers: anyNamed("headers")))
        .thenAnswer((_) async => http.Response(fixture('movies.json'), 200));
  }

  void setUpMockClientFailure401(MockClient mockClient) {
    when(mockClient.get(any, headers: anyNamed("headers")))
        .thenAnswer((_) async => http.Response('Something went wrong', 401));
  }

  void setUpMockClientFailure404(MockClient mockClient) {
    when(mockClient.get(any, headers: anyNamed("headers")))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  void setUpMockClientFailure500(MockClient mockClient) {
    when(mockClient.get(any, headers: anyNamed("headers")))
        .thenAnswer((_) async => http.Response('Something went wrong', 500));
  }

  final tMovieCollectionModel =
      MovieCollectionModel.fromJson(json.decode(fixture('movies.json')));

  group("getPlayingNow", () {
    test(
      "should perform a GET request on a URL with number being the endpoint and with application/json header",
      () {
        // arrange
        setUpMockClientSuccess200(mockClient);
        // act
        datasource.getPlayingNow();
        // assert
        final uri = Uri.parse(
            'https://api.themoviedb.org/3/movie/now_playing?api_key=${datasource.token}&language=${datasource.lang}&page=1');
        verify(mockClient.get(
          uri,
          headers: {'Content-Type': 'application/json'},
        ));
      },
    );

    test(
      "should return MovieCollectionModel when de response code is 200 (success)",
      () async {
        // arrange
        setUpMockClientSuccess200(mockClient);
        // act
        final result = await datasource.getPlayingNow();
        // assert
        expect(result, tMovieCollectionModel);
      },
    );

    test(
      "should throw UnauthenticatedException when response code is 401",
      () async {
        // arrange
        setUpMockClientFailure401(mockClient);
        // act
        final call = datasource.getPlayingNow;
        // assert
        expect(() => call(), throwsA(isA<UnauthenticatedException>()));
      },
    );

    test(
      "should throw NotFoundException when response code is 404",
      () async {
        // arrange
        setUpMockClientFailure404(mockClient);
        // act
        final call = datasource.getPlayingNow;
        // assert
        expect(() => call(), throwsA(isA<NotFoundException>()));
      },
    );

    test(
      "should throw ServerException when response code is 500",
      () async {
        // arrange
        setUpMockClientFailure500(mockClient);
        // act
        final call = datasource.getPlayingNow;
        // assert
        expect(() => call(), throwsA(isA<ServerException>()));
      },
    );
  });

  group("getPopular", () {
    test(
      "should perform a GET request on a URL with number being the endpoint and with application/json header",
      () {
        // arrange
        setUpMockClientSuccess200(mockClient);
        // act
        datasource.getPopular();
        // assert
        final uri = Uri.parse(
            'https://api.themoviedb.org/3/movie/popular?api_key=${datasource.token}&language=${datasource.lang}&page=1');
        verify(mockClient.get(
          uri,
          headers: {'Content-Type': 'application/json'},
        ));
      },
    );

    test(
      "should return MovieCollectionModel when de response code is 200 (success)",
      () async {
        // arrange
        setUpMockClientSuccess200(mockClient);
        // act
        final result = await datasource.getPopular();
        // assert
        expect(result, tMovieCollectionModel);
      },
    );

    test(
      "should throw UnauthenticatedException when response code is 401",
      () async {
        // arrange
        setUpMockClientFailure401(mockClient);
        // act
        final call = datasource.getPopular;
        // assert
        expect(() => call(), throwsA(isA<UnauthenticatedException>()));
      },
    );

    test(
      "should throw NotFoundException when response code is 404",
      () async {
        // arrange
        setUpMockClientFailure404(mockClient);
        // act
        final call = datasource.getPopular;
        // assert
        expect(() => call(), throwsA(isA<NotFoundException>()));
      },
    );

    test(
      "should throw ServerException when response code is 500",
      () async {
        // arrange
        setUpMockClientFailure500(mockClient);
        // act
        final call = datasource.getPopular;
        // assert
        expect(() => call(), throwsA(isA<ServerException>()));
      },
    );
  });
}
