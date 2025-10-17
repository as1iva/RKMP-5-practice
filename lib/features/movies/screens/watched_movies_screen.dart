import 'package:flutter/material.dart';
import 'package:fadeev_practice_5/features/movies/models/movie.dart';
import 'package:fadeev_practice_5/features/movies/widgets/movie_tile.dart';
import 'package:fadeev_practice_5/shared/widgets/empty_state.dart';

class WatchedMoviesScreen extends StatelessWidget {
  final List<Movie> movies;
  final Function(String) onDeleteMovie;
  final Function(String, bool) onToggleWatched;
  final Function(String, int) onRateMovie;
  final Function(Movie) onUpdateMovie;

  const WatchedMoviesScreen({
    super.key,
    required this.movies,
    required this.onDeleteMovie,
    required this.onToggleWatched,
    required this.onRateMovie,
    required this.onUpdateMovie,
  });

  @override
  Widget build(BuildContext context) {
    final sortedMovies = movies.toList()
      ..sort((a, b) {
        if (a.dateWatched == null && b.dateWatched == null) return 0;
        if (a.dateWatched == null) return 1;
        if (b.dateWatched == null) return -1;
        return b.dateWatched!.compareTo(a.dateWatched!);
      });

    return movies.isEmpty
        ? const EmptyState(
      icon: Icons.check_circle_outline,
      title: 'Нет просмотренных фильмов',
      subtitle: 'Отметьте фильмы как просмотренные',
    )
        : ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: sortedMovies.length,
      itemBuilder: (context, index) {
        final movie = sortedMovies[index];
        return MovieTile(
          key: ValueKey(movie.id),
          movie: movie,
          onDelete: () => onDeleteMovie(movie.id),
          onToggleWatched: (isWatched) =>
              onToggleWatched(movie.id, isWatched),
          onRate: (rating) => onRateMovie(movie.id, rating),
          onUpdate: onUpdateMovie,
        );
      },
    );
  }
}
