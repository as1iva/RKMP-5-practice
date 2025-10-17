import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../widgets/movie_tile.dart';
import 'movie_form_screen.dart';

class MoviesListScreen extends StatelessWidget {
  final List<Movie> movies;
  final Function(Movie) onAddMovie;
  final Function(String) onDeleteMovie;
  final Function(String, bool) onToggleWatched;
  final Function(String, int) onRateMovie;
  final Function(Movie) onUpdateMovie;

  const MoviesListScreen({
    super.key,
    required this.movies,
    required this.onAddMovie,
    required this.onDeleteMovie,
    required this.onToggleWatched,
    required this.onRateMovie,
    required this.onUpdateMovie,
  });

  void _showAddMovieDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieFormScreen(
          onSave: (movie) {
            onAddMovie(movie);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Фильмотека'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: movies.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.movie_creation_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Фильмотека пуста',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Добавьте первый фильм',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: movies.length,
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          final movie = movies[index];
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMovieDialog(context),
        tooltip: 'Добавить фильм',
        child: const Icon(Icons.add),
      ),
    );
  }
}
