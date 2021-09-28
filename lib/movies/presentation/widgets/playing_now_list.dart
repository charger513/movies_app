import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/enums/movie_status.dart';
import 'package:movies_app/movies/presentation/bloc/playing_now/playing_now_bloc.dart';
import 'package:movies_app/movies/presentation/widgets/movie_list_item.dart';

class PlayingNowList extends StatefulWidget {
  const PlayingNowList({
    Key? key,
  }) : super(key: key);

  @override
  _PlayingNowListState createState() => _PlayingNowListState();
}

class _PlayingNowListState extends State<PlayingNowList> {
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isEnd) {
      BlocProvider.of<PlayingNowBloc>(context).add(PlayingNowMoviesFetched());
    }
  }

  bool get _isEnd {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayingNowBloc, PlayingNowState>(
      builder: (context, state) {
        switch (state.status) {
          case MovieStatus.failure:
            return const Center(child: Text('failed to fetch movies'));
          case MovieStatus.success:
            if (state.movies.isEmpty) {
              return const Center(child: Text('no movies'));
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    'Playing now',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: state.hasReachedMax
                        ? state.movies.length
                        : state.movies.length + 1,
                    itemBuilder: (context, index) {
                      return index >= state.movies.length
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : MovieListItem(
                              movie: state.movies[index],
                              category: 'PlayingNow',
                            );
                    },
                  ),
                ),
              ],
            );
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
