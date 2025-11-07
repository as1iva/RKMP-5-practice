import 'package:flutter/material.dart';
import 'package:fadeev_practice_5/features/movies/models/movie.dart';
import 'package:fadeev_practice_5/features/service/image_service.dart';
import 'package:fadeev_practice_5/shared/app_theme.dart';

class AppStateInheritedWidget extends InheritedWidget {
  final List<Movie> movies;
  final Function(Movie) onAddMovie;
  final Function(String) onDeleteMovie;
  final Function(String, bool) onToggleWatched;
  final Function(String, int) onRateMovie;
  final Function(Movie) onUpdateMovie;
  final ImageService imageService;
  final AppTheme appTheme;

  const AppStateInheritedWidget({
    super.key,
    required this.movies,
    required this.onAddMovie,
    required this.onDeleteMovie,
    required this.onToggleWatched,
    required this.onRateMovie,
    required this.onUpdateMovie,
    required this.imageService,
    required this.appTheme,
    required super.child,
  });

  static AppStateInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppStateInheritedWidget>();
  }

  static AppStateInheritedWidget? read(BuildContext context) {
    return context.getInheritedWidgetOfExactType<AppStateInheritedWidget>();
  }

  @override
  bool updateShouldNotify(AppStateInheritedWidget oldWidget) {
    return movies != oldWidget.movies ||
        imageService != oldWidget.imageService ||
        appTheme != oldWidget.appTheme;
  }

  int get totalMovies => movies.length;

  int get watchedMovies => movies.where((movie) => movie.isWatched).length;

  int get toWatchMovies => totalMovies - watchedMovies;

  double get averageRating {
    final ratedMovies = movies.where((m) => m.rating != null);
    if (ratedMovies.isEmpty) return 0.0;

    final sum = ratedMovies.map((m) => m.rating!).reduce((a, b) => a + b);
    return sum / ratedMovies.length;
  }

  List<Movie> get recentMovies {
    if (movies.isEmpty) return [];

    final sorted = movies.toList()
      ..sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
    return sorted.take(5).toList();
  }
}
