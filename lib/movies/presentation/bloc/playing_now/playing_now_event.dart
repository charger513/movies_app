part of 'playing_now_bloc.dart';

abstract class PlayingNowEvent extends Equatable {
  const PlayingNowEvent();

  @override
  List<Object> get props => [];
}

class PlayingNowMoviesFetched extends PlayingNowEvent {}
