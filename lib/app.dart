import 'package:flutter/material.dart';
import 'package:fadeev_practice_5/shared/app_theme.dart';
import 'package:fadeev_practice_5/features/movies/state/movie_container.dart';
import 'package:fadeev_practice_5/features/movies/screens/home_screen.dart';
import 'package:fadeev_practice_5/features/auth/screens/login_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Фильмотека',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/home':
            return MaterialPageRoute(
              builder: (_) => MoviesContainer(
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
        return null;
      },
    );
  }
}
