import 'package:flutter/material.dart';
import 'package:fadeev_practice_5/features/movies/models/movie.dart';
import 'package:fadeev_practice_5/features/movies/widgets/statistics_card.dart';
import 'package:fadeev_practice_5/features/movies/widgets/movie_tile.dart';
import 'package:fadeev_practice_5/features/movies/screens/movie_form_screen.dart';
import 'package:fadeev_practice_5/features/movies/screens/all_movies_screen.dart';
import 'package:fadeev_practice_5/features/movies/screens/watched_movies_screen.dart';
import 'package:fadeev_practice_5/features/movies/screens/to_watch_screen.dart';
import 'package:fadeev_practice_5/features/movies/widgets/app_state_inherited_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  void _showAddMovieDialog(BuildContext context, AppStateInheritedWidget appState) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MovieFormScreen(
          onSave: (movie) {
            appState.onAddMovie(movie);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Widget _getSelectedScreen(AppStateInheritedWidget appState) {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeTab(appState);
      case 1:
        return AllMoviesScreen();
      case 2:
        return WatchedMoviesScreen(
          movies: appState.movies.where((m) => m.isWatched).toList(),
          onDeleteMovie: appState.onDeleteMovie,
          onToggleWatched: appState.onToggleWatched,
          onRateMovie: appState.onRateMovie,
          onUpdateMovie: appState.onUpdateMovie,
        );
      case 3:
        return ToWatchScreen(
          movies: appState.movies.where((m) => !m.isWatched).toList(),
          onDeleteMovie: appState.onDeleteMovie,
          onToggleWatched: appState.onToggleWatched,
          onRateMovie: appState.onRateMovie,
          onUpdateMovie: appState.onUpdateMovie,
        );
      default:
        return _buildHomeTab(appState);
    }
  }

  Widget _buildHomeTab(AppStateInheritedWidget appState) {
    final totalMovies = appState.movies.length;
    final watchedMovies = appState.movies.where((m) => m.isWatched).length;
    final toWatch = totalMovies - watchedMovies;
    final averageRating = appState.movies.where((m) => m.rating != null).isEmpty
        ? 0.0
        : appState.movies
        .where((m) => m.rating != null)
        .map((m) => m.rating!)
        .reduce((a, b) => a + b) /
        appState.movies.where((m) => m.rating != null).length;

    final recentMovies = appState.movies.isEmpty
        ? <Movie>[]
        : (appState.movies.toList()
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StatisticsCard(
                title: 'Всего фильмов',
                value: totalMovies.toString(),
                icon: Icons.movie_creation,
                color: Colors.indigo,
              ),
              const SizedBox(height: 12),
              StatisticsCard(
                title: 'Просмотрено',
                value: watchedMovies.toString(),
                icon: Icons.check_circle,
                color: Colors.green,
              ),
              const SizedBox(height: 12),
              StatisticsCard(
                title: 'Хочу посмотреть',
                value: toWatch.toString(),
                icon: Icons.schedule,
                color: Colors.orange,
              ),
              const SizedBox(height: 12),
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
                  onDelete: () => appState.onDeleteMovie(movie.id),
                  onToggleWatched: (isWatched) =>
                      appState.onToggleWatched(movie.id, isWatched),
                  onRate: (rating) =>
                      appState.onRateMovie(movie.id, rating),
                  onUpdate: appState.onUpdateMovie,
                );
              },
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final appState = AppStateInheritedWidget.of(context);

    if (appState == null) {
      return const Scaffold(
        body: Center(child: Text('Ошибка: AppState не найден'))
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Фильмотека'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _getSelectedScreen(appState),
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
        onPressed: () {
          _showAddMovieDialog(context, appState);
        },
        tooltip: 'Добавить фильм',
        child: const Icon(Icons.add),
      ),
    );
  }
}
