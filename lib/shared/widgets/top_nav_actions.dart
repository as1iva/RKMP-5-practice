import 'package:flutter/material.dart';
import 'package:fadeev_practice_5/features/movies/models/movie.dart';
import 'package:fadeev_practice_5/features/movies/screens/home_screen.dart';
import 'package:fadeev_practice_5/features/movies/screens/all_movies_screen.dart';
import 'package:fadeev_practice_5/features/movies/screens/watched_movies_screen.dart';
import 'package:fadeev_practice_5/features/movies/screens/to_watch_screen.dart';
import 'package:fadeev_practice_5/features/profile/screens/profile_screen.dart';

class TopNavActions extends StatelessWidget {
  final String current; // 'home' | 'all' | 'watched' | 'toWatch' | 'profile'
  final List<Movie> movies;
  final Function(Movie) onAddMovie;
  final Function(String) onDeleteMovie;
  final Function(String, bool) onToggleWatched;
  final Function(String, int) onRateMovie;
  final Function(Movie) onUpdateMovie;

  const TopNavActions({
    super.key,
    required this.current,
    required this.movies,
    required this.onAddMovie,
    required this.onDeleteMovie,
    required this.onToggleWatched,
    required this.onRateMovie,
    required this.onUpdateMovie,
  });

  @override
  Widget build(BuildContext context) {
    final List<_NavItem> items = [
      _NavItem(
        id: 'home',
        icon: Icons.home_outlined,
        selected: Icons.home,
        tooltip: 'Главная',
        build: () => HomeScreen(
          movies: movies,
          onAddMovie: onAddMovie,
          onDeleteMovie: onDeleteMovie,
          onToggleWatched: onToggleWatched,
          onRateMovie: onRateMovie,
          onUpdateMovie: onUpdateMovie,
        ),
      ),
      _NavItem(
        id: 'all',
        icon: Icons.movie_outlined,
        selected: Icons.movie,
        tooltip: 'Все фильмы',
        build: () => AllMoviesScreen(
          movies: movies,
          onAddMovie: onAddMovie,
          onDeleteMovie: onDeleteMovie,
          onToggleWatched: onToggleWatched,
          onRateMovie: onRateMovie,
          onUpdateMovie: onUpdateMovie,
        ),
      ),
      _NavItem(
        id: 'watched',
        icon: Icons.check_circle_outline,
        selected: Icons.check_circle,
        tooltip: 'Просмотрено',
        build: () => WatchedMoviesScreen(
          movies: movies,
          onAddMovie: onAddMovie,
          onDeleteMovie: onDeleteMovie,
          onToggleWatched: onToggleWatched,
          onRateMovie: onRateMovie,
          onUpdateMovie: onUpdateMovie,
        ),
      ),
      _NavItem(
        id: 'toWatch',
        icon: Icons.schedule_outlined,
        selected: Icons.schedule,
        tooltip: 'Хочу посмотреть',
        build: () => ToWatchScreen(
          movies: movies,
          onAddMovie: onAddMovie,
          onDeleteMovie: onDeleteMovie,
          onToggleWatched: onToggleWatched,
          onRateMovie: onRateMovie,
          onUpdateMovie: onUpdateMovie,
        ),
      ),
      _NavItem(
        id: 'profile',
        icon: Icons.person_outline,
        selected: Icons.person,
        tooltip: 'Профиль',
        build: () => ProfileScreen(
          movies: movies,
          onAddMovie: onAddMovie,
          onDeleteMovie: onDeleteMovie,
          onToggleWatched: onToggleWatched,
          onRateMovie: onRateMovie,
          onUpdateMovie: onUpdateMovie,
        ),
      ),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: items
          .where((i) => i.id != current)
          .map((i) => IconButton(
        tooltip: i.tooltip,
        icon: Icon(i.icon),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => i.build()),
          );
        },
      ))
          .toList(),
    );
  }
}

class _NavItem {
  final String id;
  final IconData icon;
  final IconData selected;
  final String tooltip;
  final Widget Function() build;

  _NavItem({
    required this.id,
    required this.icon,
    required this.selected,
    required this.tooltip,
    required this.build,
  });
}
