import 'package:flutter/material.dart';
import 'package:fadeev_practice_5/features/movies/models/movie.dart';
import 'package:fadeev_practice_5/features/movies/screens/movie_detail_screen.dart';

class MovieTile extends StatelessWidget {
  final Movie movie;
  final VoidCallback onDelete;
  final Function(bool) onToggleWatched;
  final Function(int) onRate;
  final Function(Movie) onUpdate;

  const MovieTile({
    super.key,
    required this.movie,
    required this.onDelete,
    required this.onToggleWatched,
    required this.onRate,
    required this.onUpdate,
  });

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Оценить фильм'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              movie.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(10, (index) {
                final rating = index + 1;
                return IconButton(
                  icon: Icon(
                    rating <= (movie.rating ?? 0)
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 28,
                  ),
                  onPressed: () {
                    onRate(rating);
                    Navigator.pop(context);
                  },
                );
              }),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить фильм?'),
        content: Text('Вы уверены, что хотите удалить "${movie.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailScreen(
          movie: movie,
          onDelete: onDelete,
          onToggleWatched: onToggleWatched,
          onRate: onRate,
          onUpdate: onUpdate,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      elevation: 2,
      child: InkWell(
        onTap: () => _navigateToDetail(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 60,
                    height: 85,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          movie.isWatched
                              ? Colors.green.shade400
                              : Colors.orange.shade400,
                          movie.isWatched
                              ? Colors.green.shade700
                              : Colors.orange.shade700,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.movie,
                        color: Colors.white.withValues(alpha: 0.7),
                        size: 32,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: movie.isWatched ? Colors.green : Colors.orange,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(
                        movie.isWatched ? Icons.check : Icons.schedule,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        decoration: movie.isWatched
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      movie.director,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[700],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            movie.genre,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.indigo.shade700,
                            ),
                          ),
                        ),
                        if (movie.rating != null) ...[
                          const SizedBox(width: 8),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 16),
                              const SizedBox(width: 2),
                              Text(
                                movie.rating.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      movie.isWatched
                          ? Icons.undo
                          : Icons.check_circle_outline,
                      color: movie.isWatched ? Colors.grey : Colors.green,
                    ),
                    onPressed: () => onToggleWatched(!movie.isWatched),
                    tooltip: movie.isWatched ? 'Вернуть' : 'Просмотрено',
                  ),
                  IconButton(
                    icon: Icon(
                      movie.rating == null
                          ? Icons.star_border
                          : Icons.star,
                      color: Colors.amber,
                    ),
                    onPressed: () => _showRatingDialog(context),
                    tooltip: 'Оценить',
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => _showDeleteConfirmation(context),
                tooltip: 'Удалить',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
