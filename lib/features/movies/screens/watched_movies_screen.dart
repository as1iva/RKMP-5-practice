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
  final Function(Movie) onAddMovie;

  const WatchedMoviesScreen({
    super.key,
    required this.movies,
    required this.onDeleteMovie,
    required this.onToggleWatched,
    required this.onRateMovie,
    required this.onUpdateMovie,
    required this.onAddMovie,
  });

  @override
  Widget build(BuildContext context) {
    final watchedMovies = movies.where((m) => m.isWatched).toList()
      ..sort((a, b) => (b.dateWatched ?? b.dateAdded)
          .compareTo(a.dateWatched ?? a.dateAdded));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Просмотрено'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: watchedMovies.isEmpty
          ? const EmptyState(
        icon: Icons.check_circle_outline,
        title: 'Пока ничего не посмотрели',
        subtitle: 'Отмечайте фильмы как просмотренные',
      )
          : ListView.builder(
        itemCount: watchedMovies.length,
        itemBuilder: (context, index) {
          final movie = watchedMovies[index];
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
      ),
    );
  }
}
