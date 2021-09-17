import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/injection_container.dart' as di;
import 'package:movies_app/movies/presentation/bloc/playing_now/playing_now_bloc.dart';
import 'package:movies_app/movies/presentation/bloc/popular/popular_bloc.dart';
import 'package:movies_app/movies/presentation/bloc/upcoming/upcoming_bloc.dart';
import 'package:movies_app/movies/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<PlayingNowBloc>()),
        BlocProvider(create: (_) => di.sl<PopularBloc>()),
        BlocProvider(create: (_) => di.sl<UpcomingBloc>()),
      ],
      child: const MaterialApp(
        title: 'Movies App',
        home: HomePage(),
      ),
    );
  }
}
