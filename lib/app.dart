import 'package:flutter/material.dart';
import 'package:fadeev_practice_5/shared/app_theme.dart';
import 'package:fadeev_practice_5/features/movies/state/movie_container.dart';
import 'package:fadeev_practice_5/features/service/image_service.dart';
import 'package:fadeev_practice_5/features/movies/widgets/app_state_inherited_widget.dart';
import 'package:fadeev_practice_5/features/movies/screens/home_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final imageService = ImageService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Фильмотека',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: MoviesContainer(
        builder: (
            context,
            movies,
            onAddMovie,
            onDeleteMovie,
            onToggleWatched,
            onRateMovie,
            onUpdateMovie,
            ) {
          return AppStateInheritedWidget(
            movies: movies,
            onAddMovie: onAddMovie,
            onDeleteMovie: onDeleteMovie,
            onToggleWatched: onToggleWatched,
            onRateMovie: onRateMovie,
            onUpdateMovie: onUpdateMovie,
            imageService: imageService,
            appTheme: AppTheme(),
            child: HomeScreen(),
          );
        },
      ),
    );
  }
}
