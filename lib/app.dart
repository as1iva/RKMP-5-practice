import 'package:flutter/material.dart';
import 'package:fadeev_practice_5/shared/app_theme.dart';
import 'package:fadeev_practice_5/features/movies/state/movie_container.dart';
import 'package:fadeev_practice_5/features/movies/screens/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Фильмотека',
      theme: AppTheme.lightTheme,
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
          return HomeScreen(
            movies: movies,
            onAddMovie: onAddMovie,
            onDeleteMovie: onDeleteMovie,
            onToggleWatched: onToggleWatched,
            onRateMovie: onRateMovie,
            onUpdateMovie: onUpdateMovie,
          );
        },
      ),
    );
  }
}
