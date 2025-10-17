import 'package:flutter/material.dart';
import 'package:fadeev_practice_5/features/movies/models/movie.dart';
import 'package:fadeev_practice_5/features/movies/widgets/statistics_card.dart';
import 'package:fadeev_practice_5/features/movies/widgets/movie_tile.dart';
import 'package:fadeev_practice_5/features/movies/screens/movie_form_screen.dart';
import 'package:fadeev_practice_5/features/movies/screens/all_movies_screen.dart';
import 'package:fadeev_practice_5/features/movies/screens/watched_movies_screen.dart';
import 'package:fadeev_practice_5/features/movies/screens/to_watch_screen.dart';

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
  int _selectedIndex = 0;

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

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

  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return AllMoviesScreen(
          movies: widget.movies,
          onDeleteMovie: widget.onDeleteMovie,
          onToggleWatched: widget.onToggleWatched,
          onRateMovie: widget.onRateMovie,
          onUpdateMovie: widget.onUpdateMovie,
        );
      case 2:
        return WatchedMoviesScreen(
          movies: widget.movies.where((m) => m.isWatched).toList(),
          onDeleteMovie: widget.onDeleteMovie,
          onToggleWatched: widget.onToggleWatched,
          onRateMovie: widget.onRateMovie,
          onUpdateMovie: widget.onUpdateMovie,
        );
      case 3:
        return ToWatchScreen(
          movies: widget.movies.where((m) => !m.isWatched).toList(),
          onDeleteMovie: widget.onDeleteMovie,
          onToggleWatched: widget.onToggleWatched,
          onRateMovie: widget.onRateMovie,
          onUpdateMovie: widget.onUpdateMovie,
        );
      default:
        return _buildHomeTab();
    }
  }

  Widget _buildHomeTab() {
    final totalMovies = widget.movies.length;
    final watchedMovies = widget.movies.where((m) => m.isWatched).length;
    final toWatch = totalMovies - watchedMovies;
    final averageRating = widget.movies.where((m) => m.rating != null).isEmpty
        ? 0.0
        : widget.movies
        .where((m) => m.rating != null)
        .map((m) => m.rating!)
        .reduce((a, b) => a + b) /
        widget.movies.where((m) => m.rating != null).length;

    final recentMovies = widget.movies.isEmpty
        ? <Movie>[]
        : (widget.movies.toList()
      ..sort((a, b) => b.dateAdded.compareTo(a.dateAdded)))
        .take(5)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Статистика',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              StatisticsCard(
                title: 'Всего фильмов',
                value: totalMovies.toString(),
                icon: Icons.movie_creation,
                color: Colors.indigo,
              ),
              StatisticsCard(
                title: 'Просмотрено',
                value: watchedMovies.toString(),
                icon: Icons.check_circle,
                color: Colors.green,
              ),
              StatisticsCard(
                title: 'Хочу посмотреть',
                value: toWatch.toString(),
                icon: Icons.schedule,
                color: Colors.orange,
              ),
              StatisticsCard(
                title: 'Средняя оценка',
                value: averageRating.toStringAsFixed(1),
                icon: Icons.star,
                color: Colors.amber,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Недавно добавленные',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (recentMovies.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'Фильмов пока нет\nДобавьте первый фильм',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
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
                  onRate: (rating) =>
                      widget.onRateMovie(movie.id, rating),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Фильмотека'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _getSelectedScreen(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Главная',
          ),
          NavigationDestination(
            icon: Icon(Icons.movie_outlined),
            selectedIcon: Icon(Icons.movie),
            label: 'Все фильмы',
          ),
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline),
            selectedIcon: Icon(Icons.check_circle),
            label: 'Просмотрено',
          ),
          NavigationDestination(
            icon: Icon(Icons.schedule_outlined),
            selectedIcon: Icon(Icons.schedule),
            label: 'Хочу посмотреть',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMovieDialog,
        tooltip: 'Добавить фильм',
        child: const Icon(Icons.add),
      ),
    );
  }
}
