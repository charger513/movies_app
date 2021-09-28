import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/injection_container.dart' as di;
import 'package:movies_app/movies/presentation/bloc/playing_now/playing_now_bloc.dart';
import 'package:movies_app/movies/presentation/bloc/popular/popular_bloc.dart';
import 'package:movies_app/movies/presentation/bloc/upcoming/upcoming_bloc.dart';
import 'package:movies_app/movies/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    // systemNavigationBarColor: Colors.blue, // navigation bar color
    // statusBarColor: Colors.pink, // status bar color
    statusBarBrightness: Brightness.dark, //status bar brigtness IOS
    statusBarIconBrightness:
        Brightness.light, //status barIcon Brightness ANDROID
    // systemNavigationBarDividerColor: Colors.greenAccent,//Navigation bar divider color
    // systemNavigationBarIconBrightness: Brightness.light, //navigation bar icon
  ));
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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Movies App',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF141A31),
        ),
        home: const HomePage(),
      ),
    );
  }
}
