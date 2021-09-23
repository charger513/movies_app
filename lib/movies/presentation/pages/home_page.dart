import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/movies/presentation/bloc/playing_now/playing_now_bloc.dart';
import 'package:movies_app/movies/presentation/widgets/categories_dummy_list.dart';
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  const Text(
                    'Movies',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 400, child: UpcomingViewPage()),
            const SizedBox(height: 20),
            const CategoriesDummyList(),
            const SizedBox(height: 20),
            const SizedBox(height: 250, child: PlayingNowList()),
            const SizedBox(height: 250, child: PopularList()),
          ],
        ),
      ),
    );
  }
}
