import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:fadeev_practice_5/shared/app_theme.dart';
import 'package:fadeev_practice_5/features/auth/screens/login_screen.dart';
import 'package:fadeev_practice_5/features/movies/state/movie_container.dart';
import 'package:fadeev_practice_5/features/movies/models/movie.dart';

import 'package:fadeev_practice_5/features/movies/screens/home_screen.dart';
import 'package:fadeev_practice_5/features/movies/screens/all_movies_screen.dart';
import 'package:fadeev_practice_5/features/movies/screens/watched_movies_screen.dart';
import 'package:fadeev_practice_5/features/movies/screens/to_watch_screen.dart';
import 'package:fadeev_practice_5/features/profile/screens/profile_screen.dart';
import 'package:fadeev_practice_5/features/movies/screens/movie_form_screen.dart';
import 'package:fadeev_practice_5/features/movies/screens/movie_detail_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Актуальные данные и колбэки из MoviesContainer (обновляются на каждом билде).
  List<Movie> _movies = [];
  void Function(Movie) _onAddMovie = (_) {};
  void Function(String) _onDeleteMovie = (_) {};
  void Function(String, bool) _onToggleWatched = (_, __) {};
  void Function(String, int) _onRateMovie = (_, __) {};
  void Function(Movie) _onUpdateMovie = (_) {};

  late final GoRouter _router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => HomeScreen(
          movies: _movies,
          onAddMovie: _onAddMovie,
          onDeleteMovie: _onDeleteMovie,
          onToggleWatched: _onToggleWatched,
          onRateMovie: _onRateMovie,
          onUpdateMovie: _onUpdateMovie,
        ),
        routes: [
          GoRoute(
            path: 'all',
            name: 'all',
            builder: (context, state) => AllMoviesScreen(
              movies: _movies,
              onAddMovie: _onAddMovie,
              onDeleteMovie: _onDeleteMovie,
              onToggleWatched: _onToggleWatched,
              onRateMovie: _onRateMovie,
              onUpdateMovie: _onUpdateMovie,
            ),
          ),
          GoRoute(
            path: 'watched',
            name: 'watched',
            builder: (context, state) => WatchedMoviesScreen(
              movies: _movies,
              onAddMovie: _onAddMovie,
              onDeleteMovie: _onDeleteMovie,
              onToggleWatched: _onToggleWatched,
              onRateMovie: _onRateMovie,
              onUpdateMovie: _onUpdateMovie,
            ),
          ),
          GoRoute(
            path: 'to-watch',
            name: 'toWatch',
            builder: (context, state) => ToWatchScreen(
              movies: _movies,
              onAddMovie: _onAddMovie,
              onDeleteMovie: _onDeleteMovie,
              onToggleWatched: _onToggleWatched,
              onRateMovie: _onRateMovie,
              onUpdateMovie: _onUpdateMovie,
            ),
          ),
          GoRoute(
            path: 'profile',
            name: 'profile',
            builder: (context, state) => ProfileScreen(
              movies: _movies,
              onAddMovie: _onAddMovie,
              onDeleteMovie: _onDeleteMovie,
              onToggleWatched: _onToggleWatched,
              onRateMovie: _onRateMovie,
              onUpdateMovie: _onUpdateMovie,
            ),
          ),
          GoRoute(
            path: 'movie/new',
            name: 'movieNew',
            builder: (context, state) => MovieFormScreen(
              onSave: (movie) {
                _onAddMovie(movie);
                Navigator.of(context).pop();
              },
            ),
          ),
          GoRoute(
            path: 'movie/:id',
            name: 'movieDetail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              final movie = _movies.firstWhere(
                    (m) => m.id == id,
                orElse: () => Movie(
                  id: id,
                  title: 'Не найдено',
                  director: '—',
                  genre: '—',
                  description: 'Фильм не найден',
                  durationMinutes: null,
                  isWatched: false,
                  rating: null,
                  dateAdded: DateTime.now(),
                  dateWatched: null,
                  imageUrl: null,
                ),
              );
              return MovieDetailScreen(
                movie: movie,
                onDelete: _onDeleteMovie,
                onToggleWatched: _onToggleWatched,
                onRate: _onRateMovie,
                onUpdate: _onUpdateMovie,
              );
            },
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MoviesContainer(
      builder: (
          context,
          movies,
          onAddMovie,
          onDeleteMovie,
          onToggleWatched,
          onRateMovie,
          onUpdateMovie,
          ) {
        _movies = movies;
        _onAddMovie = onAddMovie;
        _onDeleteMovie = onDeleteMovie;
        _onToggleWatched = onToggleWatched;
        _onRateMovie = onRateMovie;
        _onUpdateMovie = onUpdateMovie;

        return MaterialApp.router(
          title: 'Фильмотека',
          theme: AppTheme.darkTheme,
          debugShowCheckedModeBanner: false,
          routerConfig: _router,
        );
      },
    );
  }
}
