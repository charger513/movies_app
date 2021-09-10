// Mocks generated by Mockito 5.0.15 from annotations
// in movies_app/test/movies/presentation/bloc/playing_now/playing_now_bloc_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i5;

import 'package:dartz/dartz.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:movies_app/core/error/failures.dart' as _i6;
import 'package:movies_app/movies/domain/entities/movie_collection.dart' as _i7;
import 'package:movies_app/movies/domain/repositories/movies_repository_interface.dart'
    as _i2;
import 'package:movies_app/movies/domain/usecases/get_now_playing.dart' as _i4;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeMoviesRepositoryInterface_0 extends _i1.Fake
    implements _i2.MoviesRepositoryInterface {}

class _FakeEither_1<L, R> extends _i1.Fake implements _i3.Either<L, R> {}

/// A class which mocks [GetNowPlaying].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetNowPlaying extends _i1.Mock implements _i4.GetNowPlaying {
  MockGetNowPlaying() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.MoviesRepositoryInterface get moviesRepository =>
      (super.noSuchMethod(Invocation.getter(#moviesRepository),
              returnValue: _FakeMoviesRepositoryInterface_0())
          as _i2.MoviesRepositoryInterface);
  @override
  _i5.Future<_i3.Either<_i6.Failure, _i7.MovieCollection>> call(
          {int? page = 1}) =>
      (super.noSuchMethod(Invocation.method(#call, [], {#page: page}),
              returnValue:
                  Future<_i3.Either<_i6.Failure, _i7.MovieCollection>>.value(
                      _FakeEither_1<_i6.Failure, _i7.MovieCollection>()))
          as _i5.Future<_i3.Either<_i6.Failure, _i7.MovieCollection>>);
  @override
  String toString() => super.toString();
}
