import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:movies_app/core/error/exceptions.dart';
import 'package:movies_app/movies/data/models/movie_collection_model.dart';

abstract class MoviesRemoteDataSourceInterface {
  /// Calls the https://api.themoviedb.org/3/movie/now_playing endpoint.
  ///
  /// Throws a [UnauthenticatedException] for error code 401.
  /// Throws a [NotFoundException] for error code 404.
  /// Throws a [ServerException] for error code 500.
  /// Throws a [UnknownException] for other error codes.
  Future<MovieCollectionModel> getPlayingNow({int page = 1});

  /// Calls the https://api.themoviedb.org/3/movie/popular endpoint.
  ///
  /// Throws a [UnauthenticatedException] for error code 401
  /// Throws a [NotFoundException] for error code 404.
  /// Throws a [ServerException] for error code 500.
  /// Throws a [UnknownException] for other error codes.
  Future<MovieCollectionModel> getPopular({int page = 1});

  /// Calls the https://api.themoviedb.org/3/movie/upcoming endpoint.
  ///
  /// Throws a [UnauthenticatedException] for error code 401
  /// Throws a [NotFoundException] for error code 404.
  /// Throws a [ServerException] for error code 500.
  /// Throws a [UnknownException] for other error codes.
  Future<MovieCollectionModel> getUpcoming({int page = 1});
}

class MoviesRemoteDataSource implements MoviesRemoteDataSourceInterface {
  final http.Client client;
  final token = '0087e2ee52ae1bc30ababdd80751dd3b';
  final lang = 'en-US';
  final region = '';

  MoviesRemoteDataSource(this.client);

  @override
  Future<MovieCollectionModel> getPlayingNow({int page = 1}) async {
    final uri = Uri.parse(
        'https://api.themoviedb.org/3/movie/now_playing?api_key=$token&language=$lang&region=$region&page=$page');
    final headers = {'Content-Type': 'application/json'};

    final response = await client.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return MovieCollectionModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw UnauthenticatedException("Unauthenticated Exception");
    } else if (response.statusCode == 404) {
      throw NotFoundException("Not Found Exception");
    } else if (response.statusCode >= 500) {
      throw ServerException();
    } else {
      throw UnknownException();
    }
  }

  @override
  Future<MovieCollectionModel> getPopular({int page = 1}) async {
    log(page.toString());
    final uri = Uri.parse(
        'https://api.themoviedb.org/3/movie/popular?api_key=$token&language=$lang&region=$region&page=$page');
    final headers = {'Content-Type': 'application/json'};

    final response = await client.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return MovieCollectionModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw UnauthenticatedException("Unauthenticated Exception");
    } else if (response.statusCode == 404) {
      throw NotFoundException("Not Found Exception");
    } else if (response.statusCode >= 500) {
      throw ServerException();
    } else {
      throw UnknownException();
    }
  }

  @override
  Future<MovieCollectionModel> getUpcoming({int page = 1}) async {
    final uri = Uri.parse(
        'https://api.themoviedb.org/3/movie/upcoming?api_key=$token&language=$lang&region=$region&page=$page');
    final headers = {'Content-Type': 'application/json'};

    final response = await client.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return MovieCollectionModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw UnauthenticatedException("Unauthenticated Exception");
    } else if (response.statusCode == 404) {
      throw NotFoundException("Not Found Exception");
    } else if (response.statusCode >= 500) {
      throw ServerException();
    } else {
      throw UnknownException();
    }
  }
}
