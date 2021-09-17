import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/movies/presentation/bloc/playing_now/playing_now_bloc.dart';
import 'package:movies_app/movies/presentation/widgets/playing_now_list.dart';
import 'package:movies_app/movies/presentation/widgets/popular_list.dart';
import 'package:movies_app/movies/presentation/widgets/upcoming_view_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PlayingNowBloc>(context).add(PlayingNowMoviesFetched());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            SizedBox(height: 400, child: UpcomingViewPage()),
            SizedBox(height: 20),
            SizedBox(height: 250, child: PlayingNowList()),
            SizedBox(height: 250, child: PopularList()),
          ],
        ),
      ),
    );
  }
}
