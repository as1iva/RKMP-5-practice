import 'package:flutter/material.dart';
import 'package:fadeev_practice_5/features/movies/models/movie.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;
  final void Function(String id) onDelete;
  final void Function(String id, bool watched) onToggleWatched;
  final void Function(String id, int rating) onRate;
  final void Function(Movie movie) onUpdate;

  const MovieDetailScreen({
    super.key,
    required this.movie,
    required this.onDelete,
    required this.onToggleWatched,
    required this.onRate,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        backgroundColor: cs.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(movie.description ?? 'Без описания'),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => onToggleWatched(movie.id, !movie.isWatched),
                icon: const Icon(Icons.check_circle_outline),
                label: Text(movie.isWatched ? 'Снять просмотрено' : 'Отметить просмотрено'),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => onDelete(movie.id),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Удалить'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: List.generate(5, (i) {
              final r = i + 1;
              return ChoiceChip(
                label: Text('$r'),
                selected: movie.rating == r,
                onSelected: (_) => onRate(movie.id, r),
              );
            }),
          ),
        ],
      ),
    );
  }
}
