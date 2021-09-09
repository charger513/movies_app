import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies_app/core/error/exceptions.dart';
import 'package:movies_app/movies/data/models/movie_collection_model.dart';

abstract class MoviesRemoteDataSourceInterface {
  /// Calls the https://api.themoviedb.org/3/movie/now_playing endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<MovieCollectionModel> getPlayingNow({int page = 1});
}

class MoviesRemoteDataSource implements MoviesRemoteDataSourceInterface {
  final http.Client client;
  final token = '0087e2ee52ae1bc30ababdd80751dd3b';
  final lang = 'en_US';

  MoviesRemoteDataSource(this.client);

  @override
  Future<MovieCollectionModel> getPlayingNow({int page = 1}) async {
    final uri = Uri.parse(
        'https://api.themoviedb.org/3/movie/now_playing?api_key=$token&language=$lang&page=1');
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
