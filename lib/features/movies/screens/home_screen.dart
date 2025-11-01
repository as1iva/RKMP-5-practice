import 'package:flutter/material.dart';
import 'package:fadeev_practice_5/features/movies/models/movie.dart';
import 'package:fadeev_practice_5/features/movies/widgets/statistics_card.dart';
import 'package:fadeev_practice_5/features/movies/widgets/movie_tile.dart';
import 'package:fadeev_practice_5/features/movies/screens/movie_form_screen.dart';
import 'package:fadeev_practice_5/shared/widgets/top_nav_actions.dart';

class HomeScreen extends StatefulWidget {
  final List<Movie> movies;
  final Function(Movie) onAddMovie;
  final Function(String) onDeleteMovie;
  final Function(String, bool) onToggleWatched;
  final Function(String, int) onRateMovie;
  final Function(Movie) onUpdateMovie;

  const HomeScreen({
    super.key,
    required this.movies,
    required this.onAddMovie,
    required this.onDeleteMovie,
    required this.onToggleWatched,
    required this.onRateMovie,
    required this.onUpdateMovie,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _showAddMovieDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieFormScreen(
          onSave: (movie) {
            widget.onAddMovie(movie);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    final totalMovies = widget.movies.length;
    final watchedMovies = widget.movies.where((m) => m.isWatched).length;
    final toWatch = totalMovies - watchedMovies;
    final rated = widget.movies.where((m) => m.rating != null).toList();
    final averageRating =
    rated.isEmpty ? 0.0 : rated.map((m) => m.rating!).reduce((a, b) => a + b) / rated.length;

    final recentMovies = widget.movies.isEmpty
        ? <Movie>[]
        : (widget.movies.toList()
      ..sort((a, b) => b.dateAdded.compareTo(a.dateAdded)))
        .take(5)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Плитки статистики — строго столбиком сверху вниз
          StatisticsCard(
            title: 'Всего фильмов',
            value: '$totalMovies',
            icon: Icons.movie_filter_outlined,
            color: Colors.blue,
          ),
          const SizedBox(height: 12),
          StatisticsCard(
            title: 'Просмотренных',
            value: '$watchedMovies',
            icon: Icons.check_circle_outline,
            color: Colors.green,
          ),
          const SizedBox(height: 12),
          StatisticsCard(
            title: 'В планах',
            value: '$toWatch',
            icon: Icons.schedule_outlined,
            color: Colors.orange,
          ),
          const SizedBox(height: 12),
          StatisticsCard(
            title: 'Средняя оценка',
            value: averageRating.toStringAsFixed(1),
            icon: Icons.star,
            color: Colors.amber,
          ),
          const SizedBox(height: 24),
          Text(
            'Недавние добавления',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          if (recentMovies.isEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Пока пусто — добавьте первый фильм',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentMovies.length,
              itemBuilder: (context, index) {
                final movie = recentMovies[index];
                return MovieTile(
                  key: ValueKey(movie.id),
                  movie: movie,
                  onDelete: () => widget.onDeleteMovie(movie.id),
                  onToggleWatched: (isWatched) =>
                      widget.onToggleWatched(movie.id, isWatched),
                  onRate: (rating) => widget.onRateMovie(movie.id, rating),
                  onUpdate: widget.onUpdateMovie,
                );
              },
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Фильмотека'),
        backgroundColor: cs.inversePrimary,
        actions: [
          TopNavActions(
            current: 'home',
            movies: widget.movies,
            onAddMovie: widget.onAddMovie,
            onDeleteMovie: widget.onDeleteMovie,
            onToggleWatched: widget.onToggleWatched,
            onRateMovie: widget.onRateMovie,
            onUpdateMovie: widget.onUpdateMovie,
          ),
        ],
      ),
      body: _buildHomeTab(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMovieDialog,
        tooltip: 'Добавить фильм',
        child: const Icon(Icons.add),
      ),
    );
  }
}
