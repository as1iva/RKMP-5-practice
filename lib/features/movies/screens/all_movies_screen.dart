import 'package:flutter/material.dart';
import 'package:fadeev_practice_5/features/movies/models/movie.dart';
import 'package:fadeev_practice_5/features/movies/widgets/movie_tile.dart';
import 'package:fadeev_practice_5/shared/widgets/empty_state.dart';

enum _StatusFilter { all, watched, toWatch }

class AllMoviesScreen extends StatefulWidget {
  final List<Movie> movies;
  final Function(String) onDeleteMovie;
  final Function(String, bool) onToggleWatched;
  final Function(String, int) onRateMovie;
  final Function(Movie) onUpdateMovie;
  final Function(Movie) onAddMovie;

  const AllMoviesScreen({
    super.key,
    required this.movies,
    required this.onDeleteMovie,
    required this.onToggleWatched,
    required this.onRateMovie,
    required this.onUpdateMovie,
    required this.onAddMovie,
  });

  @override
  State<AllMoviesScreen> createState() => _AllMoviesScreenState();
}

class _AllMoviesScreenState extends State<AllMoviesScreen> {
  final _searchController = TextEditingController();
  _StatusFilter _status = _StatusFilter.all;
  double _minRating = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Movie> _filtered() {
    final q = _searchController.text.trim().toLowerCase();

    final filtered = widget.movies.where((m) {
      final matchesQuery = q.isEmpty
          ? true
          : (m.title.toLowerCase().contains(q) ||
          (m.description?.toLowerCase().contains(q) ?? false));

      final matchesStatus = switch (_status) {
        _StatusFilter.all => true,
        _StatusFilter.watched => m.isWatched,
        _StatusFilter.toWatch => !m.isWatched,
      };

      final minInt = _minRating.round();
      final matchesRating = minInt <= 0 ? true : ((m.rating ?? 0) >= minInt);

      return matchesQuery && matchesStatus && matchesRating;
    }).toList();

    filtered.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
    return filtered;
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _status = _StatusFilter.all;
      _minRating = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final movies = _filtered();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Все фильмы'),
        backgroundColor: cs.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'Поиск по названию',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                  tooltip: 'Очистить',
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('Все'),
                          selected: _status == _StatusFilter.all,
                          onSelected: (_) => setState(() => _status = _StatusFilter.all),
                        ),
                        ChoiceChip(
                          label: const Text('Просмотрено'),
                          selected: _status == _StatusFilter.watched,
                          onSelected: (_) => setState(() => _status = _StatusFilter.watched),
                        ),
                        ChoiceChip(
                          label: const Text('В планах'),
                          selected: _status == _StatusFilter.toWatch,
                          onSelected: (_) => setState(() => _status = _StatusFilter.toWatch),
                        ),
                        TextButton.icon(
                          onPressed: _resetFilters,
                          icon: const Icon(Icons.restart_alt),
                          label: const Text('Сбросить'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.star_border),
                        const SizedBox(width: 8),
                        Text('Мин. оценка: ${_minRating.round()}'),
                      ],
                    ),
                    Slider(
                      value: _minRating,
                      min: 0,
                      max: 5,
                      divisions: 5,
                      label: _minRating.round().toString(),
                      onChanged: (v) => setState(() => _minRating = v),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: movies.isEmpty
                ? const EmptyState(
              icon: Icons.movie_creation_outlined,
              title: 'Ничего не найдено',
              subtitle: 'Поменяйте фильтры или строку поиска',
            )
                : ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
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
          ),
        ],
      ),
    );
  }
}
