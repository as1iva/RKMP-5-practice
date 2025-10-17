import 'package:flutter/material.dart';
import 'package:fadeev_practice_5/features/movies/models/movie.dart';
import 'package:fadeev_practice_5/features/movies/widgets/movie_tile.dart';
import 'package:fadeev_practice_5/shared/widgets/empty_state.dart';

class AllMoviesScreen extends StatefulWidget {
  final List<Movie> movies;
  final Function(String) onDeleteMovie;
  final Function(String, bool) onToggleWatched;
  final Function(String, int) onRateMovie;
  final Function(Movie) onUpdateMovie;

  const AllMoviesScreen({
    super.key,
    required this.movies,
    required this.onDeleteMovie,
    required this.onToggleWatched,
    required this.onRateMovie,
    required this.onUpdateMovie,
  });

  @override
  State<AllMoviesScreen> createState() => _AllMoviesScreenState();
}

class _AllMoviesScreenState extends State<AllMoviesScreen> {
  String _searchQuery = '';
  String _selectedGenre = 'Все';
  String _sortBy = 'dateAdded';

  List<Movie> get _filteredMovies {
    var filtered = widget.movies.where((movie) {
      final matchesSearch = movie.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          movie.director.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesGenre = _selectedGenre == 'Все' || movie.genre == _selectedGenre;
      return matchesSearch && matchesGenre;
    }).toList();

    switch (_sortBy) {
      case 'title':
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'director':
        filtered.sort((a, b) => a.director.compareTo(b.director));
        break;
      case 'rating':
        filtered.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
        break;
      case 'dateAdded':
      default:
        filtered.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
    }

    return filtered;
  }

  List<String> get _genres {
    final genres = widget.movies.map((movie) => movie.genre).toSet().toList();
    genres.sort();
    return ['Все', ...genres];
  }

  @override
  Widget build(BuildContext context) {
    final filteredMovies = _filteredMovies;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Поиск по названию или режиссёру',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedGenre,
                      decoration: const InputDecoration(
                        labelText: 'Жанр',
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: _genres.map((genre) {
                        return DropdownMenuItem(
                          value: genre,
                          child: Text(genre),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedGenre = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _sortBy,
                      decoration: const InputDecoration(
                        labelText: 'Сортировка',
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'dateAdded', child: Text('По дате')),
                        DropdownMenuItem(value: 'title', child: Text('По названию')),
                        DropdownMenuItem(value: 'director', child: Text('По режиссёру')),
                        DropdownMenuItem(value: 'rating', child: Text('По оценке')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _sortBy = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: filteredMovies.isEmpty
              ? const EmptyState(
            icon: Icons.search_off,
            title: 'Фильмы не найдены',
            subtitle: 'Попробуйте изменить фильтры',
          )
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: filteredMovies.length,
            itemBuilder: (context, index) {
              final movie = filteredMovies[index];
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
        ),
      ],
    );
  }
}
